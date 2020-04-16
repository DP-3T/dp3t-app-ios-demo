/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSSendViewController: NSInformBottomButtonViewController {
    let stackScrollView = NSStackScrollView(axis: .vertical, spacing: 0)

    private let titleLabel = NSLabel(.subtitle, textColor: .ns_primary, numberOfLines: 0, textAlignment: .center)
    private let textLabel = NSLabel(.text, textAlignment: .center)

    let flow: NSTracingManager.InformationType

    init(flow: NSTracingManager.InformationType) {
        self.flow = flow
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch flow {
        case .symptoms:
            setupSymptoms()
        case .tested:
            setupTested()
        }
    }

    private func basicSetup() {
        contentView.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(NSPadding.medium * 3.0)
        }

        stackScrollView.addSpacerView(NSPadding.medium * 4.0)
        stackScrollView.addArrangedView(titleLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 2.0)
        stackScrollView.addArrangedView(textLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 4.0)

        let imageView = UIImageView(image: UIImage(named: "things-to-say")!)
        imageView.contentMode = .scaleAspectFit

        stackScrollView.addArrangedView(imageView)

        enableBottomButton = true
    }

    private func setupSymptoms() {
        titleLabel.text = "inform_button_symptom_title".ub_localized
        textLabel.text = "inform_symptoms_send_text".ub_localized
        bottomButtonTitle = "inform_send_button_title".ub_localized

        bottomButtonTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.sendPressed()
        }

        basicSetup()
    }

    private func setupTested() {
        if NSContentEnvironment.current.isGenericTracer {
            titleLabel.text = "inform_broadcast_title_star".ub_localized
            textLabel.text = "inform_broadcast_long_text_star".ub_localized
        } else {
            titleLabel.text = "inform_button_positive_title".ub_localized
            textLabel.text = "inform_positive_long_text".ub_localized
        }

        bottomButtonTitle = "inform_continue_button".ub_localized

        bottomButtonTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.continuePressed()
        }

        basicSetup()
    }

    private var rightBarButtonItem: UIBarButtonItem?

    private func continuePressed() {
        navigationController?.pushViewController(NSCodeInputViewController(), animated: true)
    }

    private func sendPressed() {
        startLoading()

        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        rightBarButtonItem = navigationItem.rightBarButtonItem
        navigationItem.rightBarButtonItem = nil

        NSTracingManager.shared.sendInformation(type: flow) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.stopLoading(error: error, reloadHandler: self.sendPressed)

                self.navigationItem.hidesBackButton = false
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.navigationItem.rightBarButtonItem = self.rightBarButtonItem
            } else {
                self.navigationController?.pushViewController(NSInformThankYouViewController(), animated: true)
            }
        }
    }
}
