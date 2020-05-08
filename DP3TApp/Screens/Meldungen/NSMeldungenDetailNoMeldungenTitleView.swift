/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSMeldungenDetailNoMeldungenTitleView: NSTitleView {
    // MARK: - Views

    private let stackView = UIStackView()

    private let imageView = UIImageView(image: UIImage(named: "ic-check-circle"))
    private let titleLabel = NSLabel(.title, textColor: .ns_green, textAlignment: .center)
    private let textLabel = NSLabel(.textLight, textAlignment: .center)

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        titleLabel.text = "meldungen_no_meldungen_title".ub_localized
        textLabel.text = "meldungen_no_meldungen_subtitle".ub_localized

        backgroundColor = UIColor.ns_greenBackground
        setup()
        isAccessibilityElement = true
        accessibilityLabel = "\(titleLabel.text ?? ""). \(textLabel.text ?? "")"
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        imageView.ub_setContentPriorityRequired()

        stackView.axis = .vertical
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(NSPadding.large)
        }

        let v = UIView()
        v.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
        }

        stackView.addSpacerView(NSPadding.medium + NSPadding.small)
        stackView.addArrangedSubview(v)
        stackView.addSpacerView(NSPadding.medium)
        stackView.addArrangedSubview(titleLabel)
        stackView.addSpacerView(NSPadding.small)
        stackView.addArrangedSubview(textLabel)
    }
}
