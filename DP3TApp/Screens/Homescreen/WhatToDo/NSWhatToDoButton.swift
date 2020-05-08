/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSWhatToDoButton: UBButton {
    // MARK: - Views

    private let titleTextLabel = NSLabel(.textBold)
    private let subtitleLabel = NSLabel(.textLight)

    private let leftImageView: UIImageView

    private var rightCaretImageView = UIImageView(image: UIImage(named: "ic-arrow-forward")!.withRenderingMode(.alwaysTemplate))

    // MARK: - Init

    init(title: String, subtitle: String, image: UIImage?) {
        leftImageView = UIImageView(image: image)

        super.init()

        titleTextLabel.text = title
        subtitleLabel.text = subtitle

        setupBackground()
        setup()

        setupAccessibility()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupBackground() {
        backgroundColor = UIColor.ns_background
        ub_addShadow(radius: 4, opacity: 0.1, xOffset: 0, yOffset: -1)
        highlightedBackgroundColor = .ns_background_highlighted
    }

    private func setup() {
        addSubview(leftImageView)
        addSubview(rightCaretImageView)

        let textViewContainer = UIView()
        addSubview(textViewContainer)

        textViewContainer.isUserInteractionEnabled = false
        textViewContainer.addSubview(titleTextLabel)
        textViewContainer.addSubview(subtitleLabel)

        subtitleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        titleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(3.0)
            make.bottom.right.left.equalToSuperview()
        }

        leftImageView.ub_setContentPriorityRequired()
        leftImageView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview().inset(NSPadding.medium)
        }

        rightCaretImageView.tintColor = .ns_text
        rightCaretImageView.ub_setContentPriorityRequired()
        rightCaretImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(NSPadding.medium)
        }

        textViewContainer.snp.makeConstraints { make in
            make.left.equalTo(self.leftImageView.snp.right).offset(NSPadding.medium)
            make.right.equalTo(self.rightCaretImageView.snp.left).offset(-NSPadding.medium)
            make.top.greaterThanOrEqualToSuperview().inset(NSPadding.medium + NSPadding.small)
            make.bottom.lessThanOrEqualToSuperview().inset(NSPadding.medium + NSPadding.small)
            make.centerY.equalToSuperview()
        }

        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(88)
        }
    }
}

// MARK: - Accessibility

extension NSWhatToDoButton {
    func setupAccessibility() {
        accessibilityLabel = [subtitleLabel, titleTextLabel]
            .compactMap { $0.text }
            .joined(separator: " ")
            .replacingOccurrences(of: "...", with: "")
    }
}
