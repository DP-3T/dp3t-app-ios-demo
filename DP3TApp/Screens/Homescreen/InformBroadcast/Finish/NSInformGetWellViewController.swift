/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInformGetWellViewController: NSInformBottomButtonViewController {
    let stackScrollView = NSStackScrollView(axis: .vertical, spacing: 0)

    private let titleLabel = NSLabel(.title, numberOfLines: 0, textAlignment: .center)
    private let textLabel = NSLabel(.textLight, textAlignment: .center)

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

        stackScrollView.addSpacerView(NSPadding.large)
        let imageView = UIImageView(image: UIImage(named: "outro-gute-besserung"))
        imageView.contentMode = .scaleAspectFit
        stackScrollView.addArrangedView(imageView)

        stackScrollView.addSpacerView(2.0 * NSPadding.large)

        stackScrollView.addArrangedView(titleLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 2.0)
        stackScrollView.addArrangedView(textLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 4.0)

        bottomButtonTitle = "inform_fertig_button_title".ub_localized
        bottomButtonTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.sendPressed()
        }

        titleLabel.text = "inform_send_getwell_title".ub_localized
        textLabel.text = "inform_send_getwell_text".ub_localized

        enableBottomButton = true
    }

    private func sendPressed() {
        dismiss(animated: true, completion: nil)
    }
}
