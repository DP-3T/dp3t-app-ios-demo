/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import SnapKit
import UIKit

class NSBluetoothSettingsControl: UIView {
    // MARK: - Views

    var state: NSUIStateModel.BegegnungenDetail = .init()

    public weak var viewToBeLayouted: UIView?

    private let titleLabel = NSLabel(.title)
    private let subtitleLabel = NSLabel(.text)

    private let switchControl = UISwitch()

    private let line = UIView()

    private let trackingActiveView = NSBluetoothSettingsDetailView(title: "bluetooth_setting_tracking_active".ub_localized, subText: "bluetooth_setting_tracking_active_subtext".ub_localized, image: UIImage(named: "ic-check"), titleColor: UIColor.ns_secondary, subtextColor: UIColor.ns_text)

    private let trackingUnactiveView = NSBluetoothSettingsDetailView(title: "bluetooth_setting_tracking_inactive".ub_localized, subText: "bluetooth_setting_tracking_inactive_subtext".ub_localized, image: UIImage(named: "ic-error"), titleColor: UIColor.ns_error, subtextColor: UIColor.ns_error)

    var activeViewConstraint: Constraint?
    var unactiveViewConstraint: Constraint?

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        backgroundColor = .white

        titleLabel.text = "bluetooth_setting_title".ub_localized
        subtitleLabel.text = "bluetooth_setting_text".ub_localized
        switchControl.onTintColor = .ns_secondary

        setup()

        switchControl.addTarget(self, action: #selector(switchChanged), for: .valueChanged)

        NSUIStateManager.shared.addObserver(self, block: updateState(_:))
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = 3.0
        ub_addShadow(radius: 4.0, opacity: 0.05, xOffset: 0, yOffset: -2)

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(switchControl)

        addSubview(line)
        addSubview(trackingActiveView)
        addSubview(trackingUnactiveView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(2.0 * NSPadding.medium - 2.0)
            make.left.equalToSuperview().inset(2.0 * NSPadding.medium)
            make.right.equalTo(self.switchControl.snp.left).inset(NSPadding.medium)
        }

        switchControl.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(2.0 * NSPadding.medium)
            make.centerY.equalTo(self.titleLabel)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(2.0 * NSPadding.medium)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(NSPadding.small)
        }

        line.snp.makeConstraints { make in
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(2.0 * NSPadding.medium)
            make.left.right.equalToSuperview().inset(NSPadding.medium)
            make.height.equalTo(1.0)
        }

        line.backgroundColor = .ns_background_secondary

        trackingActiveView.snp.makeConstraints { make in
            make.top.equalTo(self.line.snp.bottom).offset(2.0 * NSPadding.medium)
            make.left.right.equalToSuperview()
            activeViewConstraint = make.bottom.equalToSuperview().inset(2.0 * NSPadding.medium).constraint
        }

        activeViewConstraint?.deactivate()

        trackingUnactiveView.snp.makeConstraints { make in
            make.top.equalTo(self.line.snp.bottom).offset(2.0 * NSPadding.medium)
            make.left.right.equalToSuperview()
            unactiveViewConstraint = make.bottom.equalToSuperview().inset(2.0 * NSPadding.medium).constraint
        }

        unactiveViewConstraint?.activate()
    }

    // MARK: - Switch Logic

    @objc private func switchChanged() {
        // change tracing manager
        if NSTracingManager.shared.isActivated != switchControl.isOn {
            NSTracingManager.shared.isActivated = switchControl.isOn
        }
    }

    private func updateState(_ state: NSUIStateModel) {
        switchControl.setOn(state.begegnungenDetail.tracingEnabled, animated: false)

        switch state.begegnungenDetail.tracing {
        case .active:

            unactiveViewConstraint?.deactivate()
            activeViewConstraint?.activate()

            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.trackingActiveView.alpha = 1
                self.trackingUnactiveView.alpha = 0
                self.viewToBeLayouted?.layoutIfNeeded()
            }, completion: nil)

        case .deactivated: fallthrough
        case .error:
            unactiveViewConstraint?.activate()
            activeViewConstraint?.deactivate()

            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.trackingActiveView.alpha = 0
                self.trackingUnactiveView.alpha = 1
                self.viewToBeLayouted?.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
