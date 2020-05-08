/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import SnapKit
import UIKit

class NSModuleHeaderView: UIView {
    private let titleLabel = NSLabel(.title)
    private var rightCaretImageView = UIImageView(image: UIImage(named: "ic-arrow-forward")?.withRenderingMode(.alwaysTemplate))

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var showCaret: Bool = true {
        didSet {
            rightCaretImageView.isHidden = !showCaret
        }
    }

    // MARK: - Init

    init(title: String? = nil) {
        super.init(frame: .zero)

        self.title = title

        addSubview(titleLabel)
        addSubview(rightCaretImageView)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(NSPadding.small)
            make.top.bottom.equalToSuperview().inset(NSPadding.medium + NSPadding.small)
            make.trailing.equalTo(rightCaretImageView.snp.leading).offset(-NSPadding.medium)
        }
        titleLabel.text = title

        rightCaretImageView.tintColor = .ns_text
        rightCaretImageView.ub_setContentPriorityRequired()
        rightCaretImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
