/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSOnboardingFinishViewController: NSOnboardingContentViewController {
    private let foregroundImageView = UIImageView(image: UIImage(named: "onboarding-outro")!)
    private let titleLabel = NSLabel(.title, textAlignment: .center)
    private let textLabel = NSLabel(.textLight, textAlignment: .center)

    let finishButton = NSButton(title: "onboarding_go_button".ub_localized, style: .normal(.ns_blue))

    override func viewDidLoad() {
        super.viewDidLoad()

        addArrangedView(foregroundImageView, spacing: NSPadding.medium)
        addArrangedView(titleLabel, spacing: NSPadding.medium, insets: UIEdgeInsets(top: 0, left: NSPadding.large, bottom: 0, right: NSPadding.large))
        addArrangedView(textLabel, spacing: NSPadding.large + NSPadding.medium, insets: UIEdgeInsets(top: 0, left: NSPadding.large, bottom: 0, right: NSPadding.large))
        addArrangedView(finishButton)

        titleLabel.text = "onboarding_go_title".ub_localized
        textLabel.text = "onboarding_go_text".ub_localized
    }
}
