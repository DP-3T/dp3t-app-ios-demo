/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInformButton: NSButton {
    private let informTitleLabel = NSLabel(.subtitle, textColor: .ns_primary, numberOfLines: 0, textAlignment: .center)
    private let informTextLabel = NSLabel(.text, textAlignment: .center)

    init(title: String, text: String) {
        super.init(title: "")

        informTitleLabel.text = title
        informTextLabel.text = text

        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .white
        highlightedBackgroundColor = .ns_background_secondary

        layer.cornerRadius = 4.0
        highlightCornerRadius = 4.0

        layer.borderColor = UIColor.ns_text_secondary.cgColor
        layer.borderWidth = 2.0

        addSubview(informTitleLabel)
        addSubview(informTextLabel)

        informTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(NSPadding.large)
            make.left.right.equalToSuperview().inset(2.0 * NSPadding.medium)
        }

        informTextLabel.snp.makeConstraints { make in
            make.top.equalTo(informTitleLabel.snp.bottom).offset(NSPadding.small)
            make.bottom.equalToSuperview().inset(NSPadding.large + NSPadding.medium)
            make.left.right.equalToSuperview().inset(2.0 * NSPadding.medium)
        }
    }
}
