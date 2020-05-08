/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

/// A UIStackView that ignores touches unless they are on instances of UIButton
class NSClickthroughStackView: UIStackView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let target = super.hitTest(point, with: event)

        if let t = target, t is UIButton {
            return t
        }

        return nil
    }
}
