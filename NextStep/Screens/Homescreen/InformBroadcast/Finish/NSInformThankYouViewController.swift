/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInformThankYouViewController: NSInformBottomButtonViewController {
    let stackScrollView = NSStackScrollView(axis: .vertical, spacing: 0)

    private let titleLabel = NSLabel(.subtitle, textColor: .ns_primary, numberOfLines: 0, textAlignment: .center)
    private let textLabel = NSLabel(.text, textAlignment: .center)

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.rightBarButtonItem = nil

        setup()
    }

    private func setup() {
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

        let imageView = UIImageView(image: UIImage(named: "thank-you")!)
        imageView.contentMode = .scaleAspectFit

        stackScrollView.addArrangedView(imageView)

        bottomButtonTitle = "inform_fertig_button_title".ub_localized
        bottomButtonTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.sendPressed()
        }

        if NSContentEnvironment.current.isGenericTracer {
            titleLabel.text = "inform_send_thankyou".ub_localized
            textLabel.text = "inform_send_thankyou_text_star".ub_localized
        } else {
            titleLabel.text = "inform_send_thankyou".ub_localized
            textLabel.text = "inform_send_thankyou_text".ub_localized
        }

        enableBottomButton = true
    }

    private func sendPressed() {
        dismiss(animated: true, completion: nil)
    }
}
