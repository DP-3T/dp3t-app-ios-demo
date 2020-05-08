/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInfoBoxView: UIView {
    // MARK: - Views

    private let titleLabel = NSLabel(.uppercaseBold)
    private let subtextLabel = NSLabel(.textLight)
    private let leadingIconImageView = UIImageView()
    private let illustrationImageView = UIImageView()

    private let additionalLabel = NSLabel(.textBold)
    private let externalLinkButton = NSExternalLinkButton()

    // MARK: - Update

    public func updateTexts(title: String?, subText: String?, additionalText: String?, additionalURL: URL?) {
        titleLabel.text = title
        subtextLabel.text = subText

        if let url = additionalURL {
            externalLinkButton.title = additionalText

            externalLinkButton.touchUpCallback = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.openLink(url)
            }

            illustrationImageView.isHidden = false
        } else {
            additionalLabel.text = additionalText

            illustrationImageView.isHidden = true
        }
    }

    // MARK: - Init

    init(title: String, subText: String, image: UIImage?, illustration: UIImage? = nil, titleColor: UIColor, subtextColor: UIColor, backgroundColor: UIColor? = nil, hasBubble: Bool = false, additionalText: String? = nil, additionalURL: String? = nil, leadingIconRenderingMode: UIImage.RenderingMode = .alwaysTemplate) {
        super.init(frame: .zero)

        titleLabel.text = title
        subtextLabel.text = subText
        leadingIconImageView.image = image?.withRenderingMode(leadingIconRenderingMode)
        leadingIconImageView.tintColor = titleColor
        titleLabel.textColor = titleColor
        subtextLabel.textColor = subtextColor
        additionalLabel.textColor = subtextColor
        illustrationImageView.image = illustration

        setup(backgroundColor: backgroundColor, hasBubble: hasBubble, additionalText: additionalText, additionalURL: additionalURL)
        setupAccessibility(title: title, subText: subText)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(backgroundColor: UIColor?, hasBubble: Bool, additionalText: String? = nil, additionalURL: String? = nil) {
        clipsToBounds = false

        var topBottomPadding: CGFloat = 0

        if let bgc = backgroundColor {
            let v = UIView()
            v.layer.cornerRadius = 3.0
            addSubview(v)

            v.snp.makeConstraints { make in
                make.edges.equalToSuperview()
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

            topBottomPadding = 14
        }

        let hasAdditionalStuff = additionalText != nil

        addSubview(titleLabel)
        addSubview(subtextLabel)
        addSubview(leadingIconImageView)
        addSubview(illustrationImageView)

        illustrationImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(NSPadding.small)
        }

        illustrationImageView.ub_setContentPriorityRequired()
        leadingIconImageView.ub_setContentPriorityRequired()

        leadingIconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(NSPadding.medium)
            make.top.equalToSuperview().inset(topBottomPadding)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topBottomPadding + 3.0)
            make.leading.equalTo(self.leadingIconImageView.snp.trailing).offset(NSPadding.medium)
            if illustrationImageView.image == nil {
                make.trailing.equalToSuperview().inset(NSPadding.medium)
            } else {
                make.trailing.equalTo(illustrationImageView.snp.leading).inset(NSPadding.medium)
            }
        }

        subtextLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(NSPadding.medium - 2.0)
            make.leading.trailing.equalTo(self.titleLabel)
            if !hasAdditionalStuff {
                make.bottom.equalToSuperview().inset(topBottomPadding)
            }
        }

        if let adt = additionalText {
            if let url = additionalURL {
                addSubview(externalLinkButton)
                externalLinkButton.title = adt

                externalLinkButton.touchUpCallback = { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.openLink(url)
                }

                externalLinkButton.snp.makeConstraints { make in
                    make.top.equalTo(self.subtextLabel.snp.bottom).offset(NSPadding.medium + NSPadding.small)
                    make.leading.equalTo(self.titleLabel)
                    make.trailing.lessThanOrEqualTo(self.titleLabel)
                    make.bottom.equalToSuperview().inset(NSPadding.large)
                }
            } else {
                addSubview(additionalLabel)
                additionalLabel.text = adt

                additionalLabel.snp.makeConstraints { make in
                    make.top.equalTo(self.subtextLabel.snp.bottom).offset(NSPadding.medium)
                    make.leading.trailing.equalTo(self.titleLabel)
                    make.bottom.equalToSuperview().inset(topBottomPadding)
                }
            }
        }
    }

    // MARK: - Link logic

    private func openLink(_ link: String) {
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private func openLink(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - Accessibility

extension NSInfoBoxView {
    private func setupAccessibility(title: String, subText: String) {
        isAccessibilityElement = true
        accessibilityLabel = "\(title), \(subText)"
    }
}
