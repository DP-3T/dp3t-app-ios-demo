/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation
import UIKit

class NSCodeInputViewController: NSInformStepViewController, NSCodeControlProtocol {
    // MARK: - Views

    let stackScrollView = NSStackScrollView(axis: .vertical, spacing: 0)

    private let titleLabel = NSLabel(.title, numberOfLines: 0, textAlignment: .center)
    private let textLabel = NSLabel(.textLight, textAlignment: .center)

    private let errorView = UIView()
    private let errorTitleLabel = NSLabel(.uppercaseBold, textColor: .ns_red, textAlignment: .center)
    private let errorTextLabel = NSLabel(.textLight, textColor: .ns_red, textAlignment: .center)

    private let codeControl = NSCodeControl()

    private let sendButton = NSButton(title: "inform_send_button_title".ub_localized, style: .normal(.ns_purple))

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupAccessibility()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !UIAccessibility.isVoiceOverRunning {
            codeControl.jumpToNextField()
        }
    }

    // MARK: - Setup

    private func setup() {
        titleLabel.text = "inform_code_title".ub_localized
        textLabel.text = "inform_code_text".ub_localized
        errorTitleLabel.text = "inform_code_invalid_title".ub_localized
        errorTextLabel.text = "inform_code_invalid_subtitle".ub_localized

        view.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(NSPadding.medium * 2.0)
        }

        stackScrollView.addSpacerView(NSPadding.medium * 4.0)
        stackScrollView.addArrangedView(titleLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 2.0)
        stackScrollView.addArrangedView(textLabel)

        // Error View
        errorView.addSubview(errorTitleLabel)
        errorView.addSubview(errorTextLabel)
        errorView.isHidden = true

        errorTitleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        errorTextLabel.snp.makeConstraints { make in
            make.top.equalTo(self.errorTitleLabel.snp.bottom).offset(NSPadding.small)
            make.bottom.left.right.equalToSuperview()
        }

        stackScrollView.addArrangedView(errorView)

        stackScrollView.addSpacerView(NSPadding.medium * 4.0)

        let codeControlContainer = UIView()
        codeControlContainer.addSubview(codeControl)

        codeControl.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        codeControl.controller = self

        stackScrollView.addArrangedView(codeControlContainer)
        stackScrollView.addSpacerView(NSPadding.medium * 4.0)

        let sendContainer = UIView()
        sendContainer.addSubview(sendButton)

        sendButton.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.left.greaterThanOrEqualToSuperview()
        }

        stackScrollView.addArrangedView(sendContainer)

        stackScrollView.addSpacerView(NSPadding.large)

        sendButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.sendPressed()
        }

        sendButton.isEnabled = false
    }

    func setupAccessibility() {}

    // MARK: - Send Logic

    private var rightBarButtonItem: UIBarButtonItem?

    private func sendPressed() {
        _ = codeControl.resignFirstResponder()

        startLoading()

        navigationController?.isModalInPresentation = true

        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        rightBarButtonItem = navigationItem.rightBarButtonItem
        navigationItem.rightBarButtonItem = nil

        ReportingManager.shared.report(covidCode: codeControl.code()) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                switch error {
                case let .failure(error: error):
                    self.stopLoading(error: error, reloadHandler: self.sendPressed)

                    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem

                case .invalidCode:
                    self.codeControl.clearAndRestart()
                    self.errorView.isHidden = false
                    self.textLabel.isHidden = true

                    self.stopLoading()
                    if UIAccessibility.isVoiceOverRunning {
                        UIAccessibility.post(notification: .screenChanged, argument: self.errorTitleLabel)
                    }

                    self.navigationItem.hidesBackButton = false
                    self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
                }

            } else {
                // success
                self.navigationController?.pushViewController(NSInformThankYouViewController(), animated: true)
                self.changePresentingViewController()
            }
        }
    }

    private func changePresentingViewController() {
        let nav = presentingViewController as? NSNavigationController
        nav?.popToRootViewController(animated: true)
        nav?.pushViewController(NSMeldungenDetailViewController(), animated: false)
    }

    private func noCodeButtonPressed() {
        navigationController?.pushViewController(NSNoCodeInformationViewController(), animated: true)
    }

    func changeSendPermission(to sendAllowed: Bool) {
        sendButton.isEnabled = sendAllowed
        if sendAllowed {
            sendButton.accessibilityHint = ""

        } else {
            sendButton.accessibilityHint = "accessibility_code_button_disabled_hint".ub_localized
        }
    }
}
