/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSOnboardingStepViewController: NSOnboardingContentViewController {
    private let headingLabel = NSLabel(.textLight)
    private let foregroundImageView = UIImageView()
    private let titleLabel = NSLabel(.title, textAlignment: .center)

    private let model: NSOnboardingStepModel

    init(model: NSOnboardingStepModel) {
        self.model = model
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        fillViews()
    }

    private func setupViews() {
        headingLabel.textColor = model.headingColor

        addArrangedView(headingLabel, spacing: NSPadding.medium)
        addArrangedView(foregroundImageView, spacing: NSPadding.medium)
        addArrangedView(titleLabel, spacing: NSPadding.large + NSPadding.small)

        for (icon, text) in model.textGroups {
            let v = NSOnboardingInfoView(icon: icon, text: text)
            addArrangedView(v)
            v.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self.stackScrollView.stackView)
            }
        }

        let bottomSpacer = UIView()
        bottomSpacer.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        addArrangedView(bottomSpacer)
    }

    private func fillViews() {
        headingLabel.text = model.heading
        foregroundImageView.image = model.foregroundImage
        titleLabel.text = model.title
    }
}
