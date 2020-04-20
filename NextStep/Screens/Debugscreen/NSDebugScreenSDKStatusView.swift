/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import SnapKit
import UIKit

class NSDebugScreenSDKStatusView: NSSimpleModuleBaseView {
    private let stackView = UIStackView()

    private let tracingLabel = NSLabel(.textSemiBold, textAlignment: .center)
    private let commentsLabel = NSLabel(.text, textAlignment: .center)

    // MARK: - Init

    init() {
        super.init(title: "debug_sdk_state_title".ub_localized)
        setup()

        NSUIStateManager.shared.addObserver(self) { [weak self] stateModel in
            guard let strongSelf = self else { return }
            strongSelf.update(stateModel)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        contentView.spacing = NSPadding.small

        let label = NSLabel(.text)
        label.text = "debug_sdk_state_text".ub_localized

        contentView.addArrangedView(label)
        contentView.setCustomSpacing(NSPadding.medium, after: label)

        setupState()
        setupButton()
    }

    private func setupState() {
        let v = UIView()
        v.backgroundColor = UIColor(ub_hexString: "#d3f2ee")
        v.layer.cornerRadius = 3.0

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2.0
        stackView.alignment = .center

        stackView.addArrangedView(tracingLabel)
        stackView.addArrangedView(commentsLabel)

        v.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(NSPadding.medium)
        }

        contentView.addArrangedView(v)
        contentView.setCustomSpacing(NSPadding.medium, after: v)
    }

    private func setupButton() {
        let button = NSButton(title: "debug_sdk_button_reset".ub_localized, style: .primary)
        contentView.addArrangedView(button)

        button.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.resetSDK()
        }
    }

    // MARK: - Logic

    private func resetSDK() {
        NSTracingManager.shared.resetSDK()
    }

    private func update(_ state: NSUIStateModel) {
        switch state.homescreen.begegnungen.tracing {
        case .active:
            tracingLabel.text = "bluetooth_setting_tracking_active".ub_localized
        case .inactive:
            tracingLabel.text = "bluetooth_setting_tracking_inactive".ub_localized
        }

        var texts: [String] = []

        let date = dateFormatter(state.debug.lastSync)
        texts.append("\("debug_sdk_state_last_synced".ub_localized)\(date)")

        let isInfected = state.debug.infectionStatus == .infected
        texts.append("\("debug_sdk_state_self_exposed".ub_localized)\(yesOrNo(isInfected))")

        let isExposed = state.debug.infectionStatus == .exposed
        texts.append("\("debug_sdk_state_contact_exposed".ub_localized)\(yesOrNo(isExposed))")
        texts.append("\("debug_sdk_state_number_handshakes".ub_localized)\(handshakes(state.debug.handshakeCount))")

        commentsLabel.text = texts.joined(separator: "\n")
    }

    private func dateFormatter(_ date: Date?) -> String {
        guard let d = date else { return "–" }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        return dateFormatter.string(from: d)
    }

    private func handshakes(_ n: Int?) -> String {
        return (n == nil) ? "–" : String(n!)
    }

    private func yesOrNo(_ value: Bool) -> String {
        return (value ? "debug_sdk_state_boolean_true" : "debug_sdk_state_boolean_false").ub_localized
    }
}
