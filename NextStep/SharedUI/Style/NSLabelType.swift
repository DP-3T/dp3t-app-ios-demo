/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

public enum NSLabelType: UBLabelType {
    case title
    case subtitle
    case text
    case textSemiBold
    case button // used for button
    case smallBold // used for begegnungen label
    case uppercaseBold

    public var font: UIFont {
        switch self {
        case .title: return UIFont(name: "Inter-Bold", size: 28.0)!
        case .subtitle: return UIFont(name: "Inter-Bold", size: 24.0)!
        case .text: return UIFont(name: "Inter-Regular", size: 16.0)!
        case .smallBold: return UIFont(name: "Inter-Bold", size: 12.0)!
        case .textSemiBold: return UIFont(name: "Inter-SemiBold", size: 16.0)!
        case .button: return UIFont(name: "Inter-Bold", size: 18.0)!
        case .uppercaseBold: return UIFont(name: "Inter-Bold", size: 16.0)!
        }
    }

    public var textColor: UIColor {
        switch self {
        case .title:
            return .ns_primary
        case .button:
            return .white
        default:
            return .ns_text
        }
    }

    public var lineSpacing: CGFloat {
        switch self {
        case .title: return 34.0 / 28.0
        case .subtitle: return 31.0 / 24.0
        case .text: return 24.0 / 16.0
        case .textSemiBold: return 24.0 / 16.0
        case .button, .smallBold: return 1.0
        case .uppercaseBold: return 26.0 / 16.0
        }
    }

    public var letterSpacing: CGFloat? {
        if self == .uppercaseBold {
            return 1.0
        }

        return nil
    }

    public var isUppercased: Bool {
        if self == .uppercaseBold {
            return true
        }

        return false
    }

    public var hyphenationFactor: Float {
        return 1.0
    }

    public var lineBreakMode: NSLineBreakMode {
        return .byTruncatingTail
    }
}

class NSLabel: UBLabel<NSLabelType> {}
