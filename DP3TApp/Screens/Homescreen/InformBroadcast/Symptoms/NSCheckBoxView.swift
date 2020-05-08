/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSCheckBoxView: UIView {
    private let textLabel = NSLabel(.textLight)
    private let checkBox = NSCheckBoxControl(isChecked: false)

    private let button = NSButton(title: "")

    public var isChecked: Bool = false {
        didSet {
            checkBox.setChecked(checked: isChecked, animated: true)
            accessibilityTraits = isChecked ? [.selected, .button] : [.button]
        }
    }

    public var touchUpCallback: (() -> Void)?

    public var radioMode: Bool = false

    // MARK: - Init

    init(text: String) {
        super.init(frame: .zero)
        setup()

        textLabel.text = text

        isAccessibilityElement = true
        accessibilityLabel = text
        accessibilityTraits = isChecked ? [.selected, .button] : [.button]
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        button.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }

            if strongSelf.radioMode, !strongSelf.isChecked {
                strongSelf.isChecked = !strongSelf.isChecked
                strongSelf.touchUpCallback?()
            }
        }

        button.backgroundColor = .clear
        button.highlightedBackgroundColor = .clear

        addSubview(button)

        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(checkBox)
        checkBox.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }

        checkBox.isUserInteractionEnabled = false

        addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.left.equalTo(checkBox.snp.right).offset(NSPadding.medium + NSPadding.small)
            make.top.equalToSuperview().offset(2.0)
            make.bottom.right.equalToSuperview().inset(NSPadding.small)
        }
    }
}
