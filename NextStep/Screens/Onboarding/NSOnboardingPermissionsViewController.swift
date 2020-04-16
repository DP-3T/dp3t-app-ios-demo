/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import CoreBluetooth
import UIKit

class NSOnboardingPermissionsViewController: NSOnboardingContentViewController {
    private class EnabledView: UIView {
        init(text: String) {
            super.init(frame: .zero)

            snp.makeConstraints { make in
                make.height.equalTo(44)
            }

            let icon = UIImageView(image: #imageLiteral(resourceName: "ic-check"))
            addSubview(icon)
            icon.snp.makeConstraints { make in
                make.leading.centerY.equalToSuperview()
            }
            icon.ub_setContentPriorityRequired()

            let label = NSLabel(.textSemiBold, textColor: .ns_secondary)
            label.text = text
            addSubview(label)
            label.snp.makeConstraints { make in
                make.trailing.centerY.equalToSuperview()
                make.leading.equalTo(icon.snp.trailing).offset(NSPadding.medium)
            }
        }

        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    private let headingLabel = NSLabel(.text)
    private let foregroundImageView = UIImageView(image: UIImage(named: "onboarding-4")!)
    private let titleLabel = NSLabel(.subtitle, textColor: .ns_primary)
    private let textLabel = NSLabel(.text)

    private let bluetoothButton = NSButton(title: "activate_bluetooth_button".ub_localized, style: .primary)
    private let pushButton = NSButton(title: "activate_push_button".ub_localized, style: .primary)

    private let bluetoothEnabledView = EnabledView(text: "bluetooth_activated_label".ub_localized)
    private let pushEnabledView = EnabledView(text: "push_activated_label".ub_localized)

    let continueButton = NSButton(title: "onboarding_continue_button".ub_localized, style: .secondary)
    let continueWithoutButton = UBButton()

    private var isBluetoothEnabled: Bool = false
    private var bluetoothAsked: Bool = false

    private var centralManager: CBCentralManager?

    private var isPushEnabled: Bool = false
    private var pushAsked: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(checkPermissionSettings), name: UIApplication.didBecomeActiveNotification, object: nil)

        setupViews()

        checkPermissionSettings()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    private func setupViews() {
        addArrangedView(headingLabel, spacing: NSPadding.large)
        addArrangedView(foregroundImageView, spacing: (useLessSpacing ? 1.0 : 1.5) * NSPadding.large)
        addArrangedView(titleLabel, spacing: (useLessSpacing ? 1.0 : 1.0) * NSPadding.large)
        addArrangedView(textLabel, spacing: (useLessSpacing ? 1.0 : 1.5) * NSPadding.large)
        addArrangedView(bluetoothButton, spacing: NSPadding.medium)
        addArrangedView(pushButton, spacing: (useLessSpacing ? 1.0 : 1.5) * NSPadding.large)
        addArrangedView(continueButton, spacing: NSPadding.medium)
        addArrangedView(continueWithoutButton)

        foregroundImageView.contentMode = .scaleAspectFit
        foregroundImageView.snp.makeConstraints { make in
            make.height.equalTo(self.useSmallerImages ? 95.0 : 220.0)
        }

        titleLabel.textAlignment = .center
        textLabel.textAlignment = .center

        bluetoothButton.touchUpCallback = {
            self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: NSNumber(integerLiteral: 1)])
        }

        pushButton.touchUpCallback = {
            self.pushButton.isEnabled = false

            UBPushManager.shared.requestPushPermissions { result in
                self.pushAsked = true

                switch result {
                case .nonRecoverableFailure, .recoverableFailure:
                    self.isPushEnabled = false
                case .success:
                    self.isPushEnabled = true
                    self.pushButton.superview?.removeFromSuperview()
                    self.addArrangedView(self.pushEnabledView, spacing: (self.useLessSpacing ? 1.0 : 1.5) * NSPadding.large, index: 5)
                    self.pushEnabledView.alpha = 1
                }

                self.updateUI()
            }
        }

        titleLabel.text = "onboarding_title_4".ub_localized
        textLabel.text = "onboarding_desc_4".ub_localized
        continueWithoutButton.titleLabel?.font = NSLabelType.text.font
        continueWithoutButton.setTitleColor(.ns_secondary, for: .normal)
        continueWithoutButton.setTitle("onboarding_continue_without_button".ub_localized, for: .normal)
        continueWithoutButton.highlightCornerRadius = 3
        continueWithoutButton.contentEdgeInsets = UIEdgeInsets(top: NSPadding.small, left: NSPadding.small, bottom: NSPadding.small, right: NSPadding.small)
    }

    @objc private func checkPermissionSettings() {
        if #available(iOS 13.1, *) {
            switch CBCentralManager.authorization {
            case .notDetermined:
                self.bluetoothAsked = false
                self.isBluetoothEnabled = false
            case .allowedAlways:
                self.bluetoothAsked = true
                self.isBluetoothEnabled = true
                self.bluetoothButton.superview?.removeFromSuperview()
                if self.bluetoothEnabledView.superview == nil {
                    self.addArrangedView(self.bluetoothEnabledView, spacing: NSPadding.medium, index: 4)
                }
                self.bluetoothEnabledView.alpha = 1
            case .denied, .restricted:
                self.bluetoothAsked = true
                self.isBluetoothEnabled = false
            @unknown default:
                fatalError()
            }
        } else {
            bluetoothAsked = true
            isBluetoothEnabled = true
            bluetoothButton.superview?.removeFromSuperview()
        }

        UBPushManager.shared.queryPushPermissions { enabled in
            self.isPushEnabled = enabled
            print("Bluetooth: \(self.isBluetoothEnabled) / Push: \(self.isPushEnabled)")
            self.updateUI()
        }
    }

    private func updateUI() {
        continueButton.isEnabled = isBluetoothEnabled && isPushEnabled
        let showContinueWithout = bluetoothAsked && pushAsked && (!isBluetoothEnabled || !isPushEnabled)
        continueWithoutButton.isHidden = !showContinueWithout
    }
}

extension NSOnboardingPermissionsViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothButton.isEnabled = false

        if #available(iOS 13.0, *) {
            switch central.authorization {
            case .notDetermined:
                self.bluetoothAsked = false
            case .allowedAlways:
                self.bluetoothAsked = true
                self.isBluetoothEnabled = true
                self.bluetoothButton.superview?.removeFromSuperview()
                if self.bluetoothEnabledView.superview == nil {
                    self.addArrangedView(self.bluetoothEnabledView, spacing: NSPadding.medium, index: 4)
                }
                self.bluetoothEnabledView.alpha = 1

                central.delegate = nil
            case .denied, .restricted:
                self.bluetoothAsked = true
                self.isBluetoothEnabled = false
            @unknown default:
                fatalError()
            }
        } else {
            bluetoothAsked = true
            isBluetoothEnabled = true

            bluetoothButton.superview?.removeFromSuperview()
        }
    }
}
