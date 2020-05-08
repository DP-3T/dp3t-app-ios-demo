/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSHeaderErrorView: UIView {
    private let imageView = UIImageView()

    var state: UIStateModel.TracingState {
        didSet { update() }
    }

    init(initialState: UIStateModel.TracingState) {
        state = initialState

        super.init(frame: .zero)

        setupView()
        update()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(120)
        }

        // Small dots
        let angles: [CGFloat] = [0, .pi / 4.0, 3 * .pi / 4.0, .pi, 5 * .pi / 4.0, 7 * .pi / 4.0]
        for i in 0 ..< 6 {
            let c = createDot()
            addSubview(c)
            c.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            c.transform = CGAffineTransform(rotationAngle: angles[i]).translatedBy(x: 60, y: 0)
        }

        // Circle
        let circle = UIView()
        circle.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        circle.layer.cornerRadius = 28

        addSubview(circle)
        circle.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(56)
        }

        // Icon
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        alpha = 0
    }

    private func createDot() -> UIView {
        let v = UIView()
        v.backgroundColor = .ns_background
        v.layer.cornerRadius = 4.5
        v.snp.makeConstraints { make in
            make.size.equalTo(9)
        }
        return v
    }

    private func update() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = self.state == .tracingActive || self.state == .tracingEnded ? 0 : 1
        }, completion: nil)

        UIView.transition(with: imageView, duration: 0.3, options: [.beginFromCurrentState, .transitionCrossDissolve], animations: {
            switch self.state {
            case .tracingActive, .tracingEnded:
                self.imageView.image = nil
            case .tracingDisabled:
                self.imageView.image = UIImage(named: "ic-header-status-off")!
            case .timeInconsistencyError, .unexpectedError:
                self.imageView.image = UIImage(named: "ic-header-error")!
            case .bluetoothTurnedOff:
                self.imageView.image = UIImage(named: "ic-header-bt-off")!
            case .bluetoothPermissionError:
                self.imageView.image = UIImage(named: "ic-header-bt-disabled")!
            }
        }, completion: nil)
    }
}
