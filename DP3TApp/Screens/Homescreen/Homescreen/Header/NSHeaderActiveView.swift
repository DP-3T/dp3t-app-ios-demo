/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSHeaderActiveView: UIView {
    private let graphView = NSAnimatedGraphView(type: .header)

    init() {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        snp.makeConstraints { make in
            make.size.equalTo(60)
        }

        layer.cornerRadius = 30
        layer.borderWidth = 4
        layer.borderColor = UIColor.white.withAlphaComponent(0.37).cgColor

        addSubview(graphView)
        graphView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }

        alpha = 0
    }

    func startAnimating() {
        graphView.startAnimating()

        UIView.animate(withDuration: 0.7, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = 1
        }, completion: nil)
    }

    func stopAnimating() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = 0
        }) { _ in
            self.graphView.stopAnimating()
        }
    }
}
