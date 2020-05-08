/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSTracingErrorView: UIView {
    // MARK: - Views

    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let titleLabel = NSLabel(.uppercaseBold, textColor: .ns_red, numberOfLines: 2, textAlignment: .center)
    private let textLabel = NSLabel(.textLight, textColor: .ns_text, textAlignment: .center)
    private let errorCodeLabel = NSLabel(.smallRegular, textAlignment: .center)
    private let actionButton = NSUnderlinedButton()

    // MARK: - Model

    struct NSTracingErrorViewModel {
        let icon: UIImage
        let title: String
        let text: String
        let buttonTitle: String?
        let action: (() -> Void)?
    }

    var model: NSTracingErrorViewModel? {
        didSet { update() }
    }

    var errorCode: String? {
        didSet { update() }
    }

    init(model: NSTracingErrorViewModel) {
        self.model = model

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setupView()
        setupAccessibility()

        update()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .ns_backgroundSecondary
        layer.cornerRadius = 5

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = NSPadding.medium
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: NSPadding.medium + NSPadding.small, left: 2 * NSPadding.medium, bottom: NSPadding.medium, right: 2 * NSPadding.medium)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func update() {
        imageView.image = model?.icon
        titleLabel.text = model?.title
        titleLabel.accessibilityLabel = "\("loading_view_error_title".ub_localized): \(titleLabel.text ?? "")"
        textLabel.text = model?.text
        actionButton.touchUpCallback = model?.action
        actionButton.title = model?.buttonTitle

        stackView.setNeedsLayout()
        stackView.clearSubviews()

        stackView.addArrangedView(imageView)
        stackView.addArrangedView(titleLabel)
        stackView.addArrangedView(textLabel)
        if model?.action != nil {
            stackView.addArrangedView(actionButton)
        }
        if let code = self.errorCode {
            stackView.addArrangedView(errorCodeLabel)
            errorCodeLabel.text = code
        }
        stackView.addSpacerView(20)

        stackView.layoutIfNeeded()

        updateAccessibility()
    }

    // MARK: - Factory

    static func tracingErrorView(for state: UIStateModel.TracingState) -> NSTracingErrorView? {
        if let model = self.model(for: state) {
            return NSTracingErrorView(model: model)
        }

        return nil
    }

    static func model(for state: UIStateModel.TracingState) -> NSTracingErrorViewModel? {
        switch state {
        case .tracingDisabled:
            return NSTracingErrorViewModel(icon: UIImage(named: "ic-error")!,
                                           title: "tracing_turned_off_title".ub_localized,
                                           text: "tracing_turned_off_text".ub_localized,
                                           buttonTitle: nil,
                                           action: nil)
        case .bluetoothPermissionError:
            return NSTracingErrorViewModel(icon: UIImage(named: "ic-bluetooth-disabled")!,
                                           title: "bluetooth_permission_error_title".ub_localized,
                                           text: "bluetooth_permission_error_text".ub_localized,
                                           buttonTitle: "onboarding_bluetooth_button".ub_localized,
                                           action: {
                                               guard let settingsUrl = URL(string: UIApplication.openSettingsURLString),
                                                   UIApplication.shared.canOpenURL(settingsUrl) else { return }

                                               UIApplication.shared.open(settingsUrl)
            })
        case .bluetoothTurnedOff:
            return NSTracingErrorViewModel(icon: UIImage(named: "ic-bluetooth-off")!,
                                           title: "bluetooth_turned_off_title".ub_localized,
                                           text: "bluetooth_turned_off_text".ub_localized,
                                           buttonTitle: "bluetooth_turn_on_button_title".ub_localized,
                                           action: {
                                               TracingManager.shared.endTracing()
                                               TracingManager.shared.beginUpdatesAndTracing()
            })
        case .timeInconsistencyError:
            return NSTracingErrorViewModel(icon: UIImage(named: "ic-error")!,
                                           title: "time_inconsistency_title".ub_localized,
                                           text: "time_inconsistency_text".ub_localized,
                                           buttonTitle: nil,
                                           action: nil)
        case .unexpectedError:
            return NSTracingErrorViewModel(icon: UIImage(named: "ic-error")!,
                                           title: "begegnungen_restart_error_title".ub_localized,
                                           text: "begegnungen_restart_error_text".ub_localized,
                                           buttonTitle: nil,
                                           action: nil)
        default:
            return nil
        }
    }
}

// MARK: - Accessibility

extension NSTracingErrorView {
    func setupAccessibility() {
        isAccessibilityElement = false
        accessibilityElementsHidden = false
        stackView.isAccessibilityElement = true
        updateAccessibility()
    }

    func updateAccessibility() {
        accessibilityElements = model?.action != nil ? [stackView, actionButton] : [stackView]
        stackView.accessibilityLabel = model.map { "\($0.title), \($0.text)" }
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
