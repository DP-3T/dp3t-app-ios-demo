/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSButton: UBButton {
    enum Style {
        case primary, secondary, primaryOutline, secondaryOutline

        var textColor: UIColor {
            switch self {
            case .primary, .secondary:
                return .white
            case .primaryOutline:
                return .ns_primary
            case .secondaryOutline:
                return .ns_secondary
            }
        }

        var backgroundColor: UIColor {
            switch self {
            case .primary:
                return .ns_primary
            case .secondary:
                return .ns_secondary
            case .primaryOutline, .secondaryOutline:
                return .white
            }
        }

        var borderColor: UIColor {
            switch self {
            case .primaryOutline:
                return .ns_primary
            case .secondaryOutline:
                return .ns_secondary
            default:
                return .clear
            }
        }

        var highlightedColor: UIColor {
            switch self {
            case .primary, .secondary:
                return UIColor.black.withAlphaComponent(0.3)
            case .primaryOutline:
                return UIColor.ns_primary.withAlphaComponent(0.15)
            case .secondaryOutline:
                return UIColor.ns_secondary.withAlphaComponent(0.15)
            }
        }
    }

    var style: Style {
        didSet {
            setTitleColor(style.textColor, for: .normal)
            backgroundColor = style.backgroundColor
            layer.borderColor = style.borderColor.cgColor
        }
    }

    // MARK: - Init

    init(title: String, style: Style = .secondary) {
        self.style = style

        super.init()

        if style == .primaryOutline {
            self.title = title.uppercased()
        } else {
            self.title = title
        }
        titleLabel?.font = NSLabelType.button.font
        setTitleColor(style.textColor, for: .normal)
        backgroundColor = style.backgroundColor
        highlightedBackgroundColor = style.highlightedColor

        layer.borderColor = style.borderColor.cgColor
        layer.borderWidth = 2

        highlightCornerRadius = 3
        layer.cornerRadius = 3
        contentEdgeInsets = UIEdgeInsets(top: NSPadding.medium, left: NSPadding.large, bottom: NSPadding.medium, right: NSPadding.large)

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(44.0)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? style.backgroundColor : UIColor.black.withAlphaComponent(0.15)
        }
    }
}
