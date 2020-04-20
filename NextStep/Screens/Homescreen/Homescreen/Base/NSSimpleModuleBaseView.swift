/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSSimpleModuleBaseView: UIView {
    // MARK: - Private subviews

    private let titleLabel = NSLabel(.subtitle, textColor: .ns_primary)

    // MARK: - Public

    public let contentView = UIStackView()

    // MARK: - Init

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .ns_background
        ub_addShadow(radius: 4, opacity: 0.1, xOffset: 0, yOffset: -1)

        addSubview(titleLabel)
        addSubview(contentView)

        let inset = NSPadding.medium + NSPadding.small

        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(inset)
        }

        contentView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(NSPadding.small)
            make.left.right.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(inset)
        }

        contentView.axis = .vertical
    }
}
