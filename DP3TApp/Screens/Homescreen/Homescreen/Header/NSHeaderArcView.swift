/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation
import SnapKit
import UIKit

class NSHeaderArcView: UIView {
    var angle: CGFloat = 0.0 {
        didSet {
            transform = CGAffineTransform(rotationAngle: angle / 180.0 * CGFloat.pi)
        }
    }

    var angularVelocity: CGFloat = 0.0

    private let sideLength: CGFloat = 30

    enum Angle {
        case left
        case right

        var startAngle: CGFloat {
            switch self {
            case .left: return 270.0 / 180.0 * CGFloat.pi
            case .right: return 90.0 / 180.0 * CGFloat.pi
            }
        }

        var endAngle: CGFloat {
            switch self {
            case .left: return 90.0 / 180.0 * CGFloat.pi
            case .right: return 270.0 / 180.0 * CGFloat.pi
            }
        }
    }

    init(angle: Angle) {
        super.init(frame: .init(x: 0, y: 0, width: sideLength, height: sideLength))
        snp.makeConstraints { make in
            make.size.equalTo(sideLength)
        }

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: sideLength, height: sideLength)

        let path = UIBezierPath()

        //        path.move(to: CGPoint(x: sideLength / 2.0, y: sideLength / 2.0))

        let radius: CGFloat = 4 + 6 * 9

        path.addArc(withCenter: CGPoint(x: sideLength / 2.0, y: sideLength / 2.0), radius: radius, startAngle: angle.startAngle, endAngle: angle.endAngle, clockwise: false)

        shapeLayer.path = path.cgPath

        shapeLayer.lineWidth = 6

        shapeLayer.strokeColor = UIColor(white: 1.0, alpha: 0.1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor

        layer.addSublayer(shapeLayer)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
