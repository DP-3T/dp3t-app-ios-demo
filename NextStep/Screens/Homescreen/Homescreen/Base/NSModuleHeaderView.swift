/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import SnapKit
import UIKit

class NSModuleHeaderView: UIView {
    private let leftIconImageView = UIImageView()
    private let titleLabel = NSLabel(.subtitle, textColor: .ns_primary)
    private var rightCaretImageView = UIImageView(image: UIImage(named: "ic-arrow-forward")!.withRenderingMode(.alwaysTemplate))

    var icon: UIImage? {
        get { leftIconImageView.image }
        set { leftIconImageView.image = newValue }
    }

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var touchUpCallback: (() -> Void)?

    // MARK: - Init

    init(title: String? = nil, icon: UIImage? = nil) {
        super.init(frame: .zero)

        self.title = title
        self.icon = icon

        addSubview(leftIconImageView)
        addSubview(titleLabel)
        addSubview(rightCaretImageView)

        leftIconImageView.ub_setContentPriorityRequired()
        leftIconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(NSPadding.medium * 2)
        }
        leftIconImageView.image = icon

        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(NSPadding.medium)
            make.leading.equalTo(leftIconImageView.snp.trailing).offset(NSPadding.medium)
            make.trailing.equalTo(rightCaretImageView.snp.leading).offset(-NSPadding.medium)
        }
        titleLabel.text = title

        rightCaretImageView.tintColor = .ns_primary
        rightCaretImageView.ub_setContentPriorityRequired()
        rightCaretImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(NSPadding.medium)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
