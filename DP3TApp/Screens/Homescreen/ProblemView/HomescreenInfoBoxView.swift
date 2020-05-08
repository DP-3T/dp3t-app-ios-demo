/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class HomescreenInfoBoxView: UIView {
    // MARK: - API

    var uiState: UIStateModel.Homescreen.InfoBox? {
        didSet {
            if uiState != oldValue {
                updateState(animated: true)
            }
        }
    }

    // MARK: - Views

    let infoBoxView = NSInfoBoxView(title: "", subText: "", image: UIImage(named: "ic-info"), illustration: nil, titleColor: UIColor.white, subtextColor: UIColor.white, backgroundColor: .ns_purple, additionalText: "", additionalURL: "")

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(infoBoxView)

        infoBoxView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(NSPadding.medium + NSPadding.small)
        }

        layer.cornerRadius = 3.0
    }

    // MARK: - Update State

    private func updateState(animated _: Bool) {
        guard let gp = uiState else { return }

        infoBoxView.updateTexts(title: gp.title, subText: gp.text, additionalText: gp.link, additionalURL: gp.url)
    }
}
