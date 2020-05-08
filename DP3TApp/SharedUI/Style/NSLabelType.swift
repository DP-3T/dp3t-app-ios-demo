/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSFontSize {
    private static let normalBodyFontSize: CGFloat = 16.0

    public static let bodyFontSize: CGFloat = {
        // default from system is 17.
        let bfs = UIFontDescriptor.preferredFontDescriptor(withTextStyle: UIFont.TextStyle.body).pointSize - 1.0

        let preferredSize: CGFloat = normalBodyFontSize
        let maximum: CGFloat = 1.5 * preferredSize
        let minimum: CGFloat = 0.5 * preferredSize

        return min(max(minimum, bfs), maximum)
    }()

    public static let fontSizeMultiplicator: CGFloat = {
        max(1.0, bodyFontSize / normalBodyFontSize)
    }()
}

public enum NSLabelType: UBLabelType {
    case title
    case textLight
    case textBold
    case button // used for button
    case uppercaseBold
    case date
    case smallRegular

    public var font: UIFont {
        let bfs = NSFontSize.bodyFontSize

        var boldFontName = "Inter-Bold"
        var regularFontName = "Inter-Regular"
        var lightFontName = "Inter-Light"

        switch UITraitCollection.current.legibilityWeight {
        case .bold:
            boldFontName = "Inter-ExtraBold"
            regularFontName = "Inter-Bold"
            lightFontName = "Inter-Medium"
        default:
            break
        }

        switch self {
        case .title: return UIFont(name: boldFontName, size: bfs + 6.0)!
        case .textLight: return UIFont(name: lightFontName, size: bfs)!
        case .textBold: return UIFont(name: boldFontName, size: bfs)!
        case .button: return UIFont(name: boldFontName, size: bfs)!
        case .uppercaseBold: return UIFont(name: boldFontName, size: bfs)!
        case .date: return UIFont(name: boldFontName, size: bfs - 3.0)!
        case .smallRegular: return UIFont(name: regularFontName, size: bfs - 3.0)!
        }
    }

    public var textColor: UIColor {
        switch self {
        case .button:
            return .white
        case .smallRegular:
            return UIColor.black.withAlphaComponent(0.28)
        default:
            return .ns_text
        }
    }

    public var lineSpacing: CGFloat {
        switch self {
        case .title: return 30.0 / 22.0
        case .textBold: return 24.0 / 16.0
        case .button: return 1.0
        case .uppercaseBold: return 26.0 / 16.0
        case .textLight: return 24.0 / 16.0
        case .date: return 2.0
        case .smallRegular: return 26.0 / 13.0
        }
    }

    public var letterSpacing: CGFloat? {
        if self == .uppercaseBold {
            return 1.0
        }

        if self == .date {
            return 0.5
        }

        if self == .smallRegular {
            return 0.3
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
        1.0
    }

    public var lineBreakMode: NSLineBreakMode {
        .byTruncatingTail
    }
}

class NSLabel: UBLabel<NSLabelType> {}
