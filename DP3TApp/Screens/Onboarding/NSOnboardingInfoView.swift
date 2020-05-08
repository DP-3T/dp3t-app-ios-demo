/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSOnboardingInfoView: UIView {
    public let stackView = UIStackView()

    private let leftRightInset: CGFloat

    init(icon: UIImage, text: String, title: String? = nil, leftRightInset: CGFloat = 2 * NSPadding.medium) {
        self.leftRightInset = leftRightInset

        super.init(frame: .zero)

        let hasTitle = title != nil

        let imgView = UIImageView(image: icon)
        imgView.ub_setContentPriorityRequired()

        let label = NSLabel(.textLight)
        label.text = text

        addSubview(imgView)
        addSubview(label)

        let titleLabel = NSLabel(.textBold)
        if hasTitle {
            addSubview(titleLabel)
            titleLabel.text = title

            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(NSPadding.medium)
                make.leading.trailing.equalToSuperview().inset(leftRightInset)
            }
        }

        imgView.snp.makeConstraints { make in
            if hasTitle {
                make.top.equalTo(titleLabel.snp.bottom).offset(NSPadding.medium)
            } else {
                make.top.equalToSuperview().inset(NSPadding.medium)
            }
            make.leading.equalToSuperview().inset(leftRightInset)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(imgView)
            make.leading.equalTo(imgView.snp.trailing).offset(NSPadding.medium + NSPadding.small)
            make.trailing.equalToSuperview().inset(leftRightInset)
        }

        addSubview(stackView)

        stackView.axis = .vertical
        stackView.spacing = 0

        stackView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.equalTo(imgView.snp.trailing).offset(NSPadding.medium + NSPadding.small)
            make.trailing.equalToSuperview().inset(leftRightInset)
            make.bottom.equalToSuperview().inset(NSPadding.medium)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
