/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

public class NSCheckBoxControl: UIControl {
    private let checkmarkShortLineView = UIView()
    private let checkmarkLongLineView = UIView()

    private let checkmarkContainer = UIView()

    private var isChecked: Bool

    public func setChecked(checked: Bool, animated: Bool) {
        isChecked = checked
        update(animated: animated)
    }

    private var activeColor: UIColor
    private var inactiveColor: UIColor
    private var inactiveBackground: UIColor

    init(isChecked: Bool, noBorder: Bool = false) {
        self.isChecked = isChecked

        if noBorder { // no nations
            activeColor = .clear
            inactiveColor = .clear
            inactiveBackground = .clear
        } else {
            activeColor = .ns_green
            inactiveColor = .ns_text_secondary
            inactiveBackground = .white
        }

        super.init(frame: .zero)

        setupView()
        update(animated: false)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        snp.makeConstraints { make in
            make.size.equalTo(24)
        }

        addSubview(checkmarkContainer)
        checkmarkContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        clipsToBounds = true

        layer.borderColor = isChecked ? UIColor.clear.cgColor : UIColor.ns_text_secondary.cgColor
        layer.borderWidth = 2

        checkmarkContainer.layer.cornerRadius = 0
        checkmarkContainer.layer.borderWidth = 2
        checkmarkContainer.layer.borderColor = isChecked ? activeColor.cgColor : UIColor.ns_text_secondary.cgColor

        let checkmarkShortContainerView = UIView()
        checkmarkShortContainerView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkContainer.addSubview(checkmarkShortContainerView)
        checkmarkShortContainerView.addSubview(checkmarkShortLineView)
        checkmarkShortLineView.backgroundColor = .white
        checkmarkShortLineView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalTo(self)
            make.height.equalTo(2)
            make.width.equalTo(6)
        }
        checkmarkShortLineView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        checkmarkShortContainerView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        checkmarkShortContainerView.transform = CGAffineTransform(rotationAngle: .pi * 0.25).translatedBy(x: -7, y: 4)

        let checkmarkLongContainerView = UIView()
        checkmarkLongContainerView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkContainer.addSubview(checkmarkLongContainerView)
        checkmarkLongContainerView.addSubview(checkmarkLongLineView)
        checkmarkLongLineView.backgroundColor = .white
        checkmarkLongLineView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.center.equalTo(self)
            make.height.equalTo(2)
            make.width.equalTo(12)
        }
        checkmarkLongLineView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        checkmarkLongContainerView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        checkmarkLongContainerView.transform = CGAffineTransform(rotationAngle: -.pi * 0.25).translatedBy(x: -11, y: 1)
    }

    private func update(animated: Bool) {
        if !animated {
            checkmarkContainer.transform = .identity
            checkmarkContainer.backgroundColor = isChecked ? activeColor : inactiveBackground
            checkmarkContainer.layer.borderColor = isChecked ? activeColor.cgColor : inactiveColor.cgColor
            layer.borderColor = isChecked ? UIColor.clear.cgColor : inactiveColor.cgColor
        } else {
            if isChecked {
                checkmarkContainer.transform = .identity
                checkmarkContainer.layer.borderColor = activeColor.cgColor
                checkmarkShortLineView.transform = CGAffineTransform(scaleX: 0.00001, y: 1)
                checkmarkLongLineView.transform = CGAffineTransform(scaleX: 0.00001, y: 1)

                UIView.animate(withDuration: 0.075, delay: 0.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                    self.checkmarkShortLineView.transform = .identity
                    self.checkmarkContainer.backgroundColor = self.activeColor
                }, completion: { _ in
                    UIView.animate(withDuration: 0.15, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                        self.checkmarkLongLineView.transform = .identity
                    }, completion: { _ in
                        self.isUserInteractionEnabled = true
                    })
                })

                layer.borderColor = activeColor.cgColor
                UIView.transition(with: self, duration: 0.225, options: .transitionCrossDissolve, animations: {
                    self.layer.borderColor = UIColor.clear.cgColor
                }, completion: nil)

            } else {
                checkmarkContainer.layer.borderColor = inactiveColor.cgColor
                layer.borderColor = inactiveColor.cgColor

                UIView.animate(withDuration: 0.15, delay: 0.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                    self.checkmarkContainer.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.checkmarkContainer.backgroundColor = self.inactiveBackground
                    self.checkmarkContainer.layer.borderColor = UIColor.clear.cgColor
                    self.layer.borderColor = self.activeColor.cgColor
                }, completion: { _ in
                    self.checkmarkContainer.transform = .identity
                    self.isUserInteractionEnabled = true
                })

                layer.borderColor = inactiveColor.cgColor
                UIView.transition(with: self, duration: 0.03, options: .transitionCrossDissolve, animations: {
                    self.layer.borderColor = self.inactiveColor.cgColor
                }, completion: nil)
            }
        }
    }

    public override func hitTest(_: CGPoint, with _: UIEvent?) -> UIView? {
        nil
    }
}
