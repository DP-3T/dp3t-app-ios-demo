/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSOnboardingStepViewController: NSOnboardingContentViewController {
    private let headingLabel = NSLabel(.text)
    private let backgroundImageView = UIImageView()
    private let foregroundImageView = UIImageView()
    private let titleLabel = NSLabel(.subtitle, textColor: .ns_primary)
    private let textLabel = NSLabel(.text)

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
        addArrangedView(headingLabel, spacing: NSPadding.large)
        addArrangedView(foregroundImageView, spacing: (useLessSpacing ? 1.0 : 1.5) * NSPadding.large)

        addArrangedView(titleLabel, spacing: (useLessSpacing ? 1.0 : 1.0) * NSPadding.large)
        addArrangedView(textLabel)

        foregroundImageView.contentMode = .scaleAspectFit
        foregroundImageView.snp.makeConstraints { make in
            make.height.equalTo(self.useSmallerImages ? 150 : 220)
        }

        titleLabel.textAlignment = .center
        textLabel.textAlignment = .center
    }

    private func fillViews() {
        headingLabel.text = model.heading
        foregroundImageView.image = model.foregroundImage
        titleLabel.text = model.title
        textLabel.text = model.text
    }
}
