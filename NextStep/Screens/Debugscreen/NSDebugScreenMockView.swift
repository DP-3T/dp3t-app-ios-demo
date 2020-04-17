/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import SnapKit
import UIKit

class NSDebugScreenMockView: NSSimpleModuleBaseView {
    private let stackView = UIStackView()

    private let checkboxes = [NSCheckBoxView(text: "debug_state_setting_option_none".ub_localized), NSCheckBoxView(text: "debug_state_setting_option_ok".ub_localized), NSCheckBoxView(text: "debug_state_setting_option_exposed".ub_localized), NSCheckBoxView(text: "debug_state_setting_option_infected".ub_localized)]

    // MARK: - Init

    init() {
        super.init(title: "debug_state_setting_title".ub_localized)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        contentView.spacing = NSPadding.small

        let label = NSLabel(.text)
        label.text = "debug_state_setting_text".ub_localized

        contentView.addArrangedView(label)

        let checkBoxStackView = UIStackView()
        checkBoxStackView.spacing = NSPadding.small
        checkBoxStackView.axis = .vertical

        for c in checkboxes {
            checkBoxStackView.addArrangedView(c)
            c.radioMode = true
            c.touchUpCallback = { [weak self, weak c] in
                guard let strongSelf = self, let strongC = c else { return }
                strongSelf.select(strongC)
            }
        }

        let cbc = UIView()
        cbc.addSubview(checkBoxStackView)

        checkBoxStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0.0, left: NSPadding.medium + NSPadding.small, bottom: 0.0, right: NSPadding.medium))
        }

        contentView.addArrangedView(cbc)

        let stateManager = NSTracingManager.shared.uiStateManager

        if let status = stateManager.overwrittenInfectionState {
            switch status {
            case .healthy: checkboxes[1].isChecked = true
            case .exposed: checkboxes[2].isChecked = true
            case .infected: checkboxes[3].isChecked = true
            }
        } else {
            checkboxes[0].isChecked = true
        }
    }

    // MARK: - Logic

    private func select(_ checkBox: NSCheckBoxView) {
        let stateManager = NSTracingManager.shared.uiStateManager

        if let index = checkboxes.firstIndex(of: checkBox) {
            switch index {
            case 1:
                stateManager.overwrittenInfectionState = .healthy
            case 2:
                stateManager.overwrittenInfectionState = .exposed
            case 3:
                stateManager.overwrittenInfectionState = .infected
            default:
                stateManager.overwrittenInfectionState = nil
            }
        }

        for c in checkboxes {
            if c != checkBox {
                c.isChecked = false
            }
        }
    }
}
