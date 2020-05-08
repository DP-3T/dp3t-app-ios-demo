/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

extension UIStackView {
    func addArrangedView(_ view: UIView, size: CGFloat? = nil, index: Int? = nil, insets: UIEdgeInsets? = nil) {
        if let h = size, axis == .vertical {
            view.snp.makeConstraints { make in
                make.height.equalTo(h)
            }
        } else if let w = size, axis == .horizontal {
            view.snp.makeConstraints { make in
                make.width.equalTo(w)
            }
        }

        if let i = index {
            insertArrangedSubview(view, at: i)
        } else {
            addArrangedSubview(view)
        }

        if let insets = insets {
            view.snp.makeConstraints { make in
                if axis == .vertical {
                    make.leading.trailing.equalToSuperview().inset(insets)
                } else {
                    make.top.bottom.equalToSuperview().inset(insets)
                }
            }
        }
    }

    func addSpacerView(_ size: CGFloat, color: UIColor? = nil, insets: UIEdgeInsets? = nil) {
        let extraSpacer = UIView()
        extraSpacer.backgroundColor = color
        addArrangedView(extraSpacer, size: size)
        if let insets = insets {
            extraSpacer.snp.makeConstraints { make in
                if axis == .vertical {
                    make.leading.trailing.equalToSuperview().inset(insets)
                } else {
                    make.top.bottom.equalToSuperview().inset(insets)
                }
            }
        }
    }

    func clearSubviews() {
        for v in arrangedSubviews {
            v.removeFromSuperview()
        }
    }

    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
