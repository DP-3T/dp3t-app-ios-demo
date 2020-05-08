/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

#if ENABLE_TESTING

import SnapKit
import UIKit

class NSDebugScreenSDKStatusView: NSSimpleModuleBaseView {
    private let stackView = UIStackView()

    private let tracingLabel = NSLabel(.textBold, textAlignment: .center)
    private let commentsLabel = NSLabel(.textLight, textAlignment: .center)

    // MARK: - Init

    init() {
        super.init(title: "debug_sdk_state_title".ub_localized)
        setup()

        UIStateManager.shared.addObserver(self) { [weak self] stateModel in
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

        let label = NSLabel(.textLight)
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
        let button = NSButton(title: "debug_sdk_button_reset".ub_localized, style: .uppercase(.ns_purple))
        contentView.addArrangedView(button)

        button.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.resetSDK()
        }

        let button2 = NSButton(title: "reset_onboarding".ub_localized, style: .uppercase(.ns_purple))
        contentView.addArrangedView(button2)

        button2.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.resetOnboarding()
        }
    }

    // MARK: - Logic

    private func resetSDK() {
        TracingManager.shared.resetSDK()
    }

    private func resetOnboarding() {
        UserStorage.shared.hasCompletedOnboarding = false
        abort()
    }

    private func update(_ state: UIStateModel) {
        switch state.homescreen.begegnungen {
        case .tracingActive:
            tracingLabel.text = "tracing_active_title".ub_localized
        case .tracingDisabled, .bluetoothTurnedOff, .bluetoothPermissionError, .tracingEnded, .timeInconsistencyError, .unexpectedError:
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

        texts.append("\("debug_sdk_state_number_contacts".ub_localized)\(handshakes(state.debug.contactCount))")

        let secretKeyRepresentation = state.debug.secretKeyRepresentation ?? "???"
        texts.append("SK: " + secretKeyRepresentation)

        commentsLabel.text = texts.joined(separator: "\n")
    }

    private func dateFormatter(_ date: Date?) -> String {
        guard let d = date else { return "–" }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        return dateFormatter.string(from: d)
    }

    private func handshakes(_ n: Int?) -> String {
        (n == nil) ? "–" : String(n!)
    }

    private func yesOrNo(_ value: Bool) -> String {
        (value ? "debug_sdk_state_boolean_true" : "debug_sdk_state_boolean_false").ub_localized
    }
}

#endif
