/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSExplanationView: UIView {
    let stackView = UIStackView()

    // MARK: - Init

    init(title: String, texts: [String], edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: NSPadding.large, bottom: 0, right: NSPadding.large)) {
        super.init(frame: .zero)

        stackView.axis = .vertical
        stackView.spacing = 2 * NSPadding.medium

        let titleLabel = NSLabel(.textBold)
        titleLabel.text = title

        stackView.addArrangedView(titleLabel)

        for t in texts {
            let v = NSPointTextView(text: t)
            stackView.addArrangedView(v)
        }

        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(edgeInsets)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
