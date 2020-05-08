/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSSendViewController: NSInformBottomButtonViewController {
    let stackScrollView = NSStackScrollView(axis: .vertical, spacing: 0)

    private let titleLabel = NSLabel(.title, numberOfLines: 0, textAlignment: .center)
    private let textLabel = NSLabel(.textLight, textAlignment: .center)

    override init() {
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTested()
    }

    private func basicSetup() {
        contentView.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(NSPadding.medium * 3.0)
        }

        let imageView = UIImageView(image: UIImage(named: "illu-code-wichtiger-hinweis"))
        imageView.contentMode = .scaleAspectFit

        stackScrollView.addSpacerView(NSPadding.large)
        stackScrollView.addArrangedView(imageView)
        stackScrollView.addSpacerView(NSPadding.large)
        stackScrollView.addArrangedView(titleLabel)
        stackScrollView.addSpacerView(NSPadding.large)
        stackScrollView.addArrangedView(textLabel)
        stackScrollView.addSpacerView(NSPadding.large)

        enableBottomButton = true
    }

    private func setupTested() {
        titleLabel.text = "inform_code_intro_title".ub_localized
        textLabel.text = "inform_code_intro_text".ub_localized

        bottomButtonTitle = "inform_code_intro_button".ub_localized

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
}
