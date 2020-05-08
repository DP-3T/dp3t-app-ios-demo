/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSUnderlinedButton: UBButton {
    override var title: String? {
        didSet {
            guard let t = title else { return }

            let range = NSMakeRange(0, t.count)
            let attributedText = NSMutableAttributedString(string: t)
            attributedText.addAttributes([
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: NSLabelType.button.font,
                .underlineColor: UIColor.ns_text,
                .foregroundColor: UIColor.ns_text,
            ], range: range)

            setAttributedTitle(attributedText, for: .normal)
        }
    }

    override init() {
        super.init()

        highlightCornerRadius = 3
        highlightedBackgroundColor = UIColor.ns_text.withAlphaComponent(0.15)
        contentEdgeInsets = UIEdgeInsets(top: NSPadding.medium, left: NSPadding.medium, bottom: NSPadding.medium, right: NSPadding.medium)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize

        if contentSize.height > 44.0 {
            contentSize.height = contentSize.height + NSPadding.medium
        }

        return contentSize
    }
}
