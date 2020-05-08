/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInformTracingEndViewController: NSInformBottomButtonViewController {
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
        let imageView = UIImageView(image: UIImage(named: "outro-tracing-beenden"))
        imageView.contentMode = .scaleAspectFit
        stackScrollView.addArrangedView(imageView)

        stackScrollView.addSpacerView(2.0 * NSPadding.large)

        stackScrollView.addArrangedView(titleLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 2.0)
        stackScrollView.addArrangedView(textLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 4.0)

        bottomButtonTitle = "inform_continue_button".ub_localized
        bottomButtonTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.sendPressed()
        }

        titleLabel.text = "tracing_ended_title".ub_localized
        textLabel.text = "tracing_ended_text".ub_localized

        enableBottomButton = true
    }

    private func sendPressed() {
        navigationController?.pushViewController(NSInformGetWellViewController(), animated: true)
    }
}
