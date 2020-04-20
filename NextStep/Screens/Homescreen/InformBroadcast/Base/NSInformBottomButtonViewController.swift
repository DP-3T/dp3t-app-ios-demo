/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInformBottomButtonViewController: NSInformStepViewController {
    // MARK: - API

    public let contentView = UIView()

    public var bottomButtonTitle: String? {
        didSet { button.title = bottomButtonTitle }
    }

    public var bottomButtonTouchUpCallback: (() -> Void)? {
        didSet { button.touchUpCallback = bottomButtonTouchUpCallback }
    }

    public var enableBottomButton: Bool = false {
        didSet { button.isEnabled = enableBottomButton }
    }

    // MARK: - Views

    private let buttonView = UIView()

    private let button = NSButton(title: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Init

    override init() {
        super.init()
    }

    // MARK: - Setup

    private func setup() {
        let stackView = UIStackView(arrangedSubviews: [contentView, buttonView])
        stackView.axis = .vertical
        stackView.spacing = 0

        view.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        buttonView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }

        buttonView.ub_addShadow(radius: 8.0, opacity: 0.15, xOffset: 0.0, yOffset: 0.0)

        buttonView.backgroundColor = UIColor.white

        buttonView.addSubview(button)

        button.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(NSPadding.large)
            make.left.right.lessThanOrEqualToSuperview().inset(NSPadding.medium * 2.0)
            make.centerX.equalToSuperview()

            make.bottom.equalTo(self.view.safeAreaLayoutGuide).priority(.low)
            make.bottom.lessThanOrEqualTo(self.view.snp.bottom).inset(NSPadding.large)
        }

        button.isEnabled = enableBottomButton
    }
}
