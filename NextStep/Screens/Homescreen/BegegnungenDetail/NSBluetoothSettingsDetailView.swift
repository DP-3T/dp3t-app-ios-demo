/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSBluetoothSettingsDetailView: UIView {
    // MARK: - Views

    private let titleLabel = NSLabel(.uppercaseBold)
    private let subtextLabel = NSLabel(.text)
    private let imageView = UIImageView()

    private let additionalLabel = NSLabel(.textSemiBold)

    // MARK: - Init

    init(title: String, subText: String, image: UIImage?, titleColor: UIColor, subtextColor: UIColor, backgroundColor: UIColor? = nil, backgroundInset: Bool = true, hasBubble: Bool = false, additionalText: String? = nil) {
        super.init(frame: .zero)

        titleLabel.text = title
        subtextLabel.text = subText
        imageView.image = image
        titleLabel.textColor = titleColor
        subtextLabel.textColor = subtextColor
        additionalLabel.textColor = subtextColor

        setup(backgroundColor: backgroundColor, backgroundInset: backgroundInset, hasBubble: hasBubble, additionalText: additionalText)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(backgroundColor: UIColor?, backgroundInset: Bool, hasBubble: Bool, additionalText: String? = nil) {
        var topBottomPadding: CGFloat = 0

        if let bgc = backgroundColor {
            let v = UIView()
            v.layer.cornerRadius = 3.0
            addSubview(v)

            v.snp.makeConstraints { make in
                if backgroundInset {
                    make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: NSPadding.medium, bottom: 0, right: NSPadding.medium))
                } else {
                    make.edges.equalToSuperview()
                }
            }

            v.backgroundColor = bgc

            if hasBubble {
                let imageView = UIImageView(image: UIImage(named: "bubble")?.withRenderingMode(.alwaysTemplate))
                imageView.tintColor = bgc
                addSubview(imageView)

                imageView.snp.makeConstraints { make in
                    make.top.equalTo(self.snp.bottom)
                    make.left.equalToSuperview().inset(NSPadding.large)
                }
            }

            topBottomPadding = backgroundInset ? 14.0 : (2.0 * NSPadding.medium)
        }

        let hasAdditionalStuff = additionalText != nil

        addSubview(titleLabel)
        addSubview(subtextLabel)
        addSubview(imageView)

        imageView.ub_setContentPriorityRequired()

        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(NSPadding.medium * 2.0)
            make.top.equalToSuperview().inset(topBottomPadding)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topBottomPadding + 3.0)
            make.left.equalTo(self.imageView.snp.right).offset(NSPadding.medium)
            make.right.equalToSuperview().inset(NSPadding.medium * 2.0)
        }

        subtextLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(NSPadding.medium - 2.0)
            make.left.right.equalTo(self.titleLabel)
            if !hasAdditionalStuff {
                make.bottom.equalToSuperview().inset(topBottomPadding)
            }
        }

        if let adt = additionalText {
            addSubview(additionalLabel)
            additionalLabel.text = adt

            additionalLabel.snp.makeConstraints { make in
                make.top.equalTo(self.subtextLabel.snp.bottom).offset(NSPadding.medium)
                make.left.right.equalTo(self.titleLabel)
                make.bottom.equalToSuperview().inset(topBottomPadding)
            }
        }
    }
}
