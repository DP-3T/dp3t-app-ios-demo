/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

struct NSOnboardingStepModel {
    let heading: String
    let headingColor: UIColor
    let foregroundImage: UIImage
    let title: String
    let textGroups: [(UIImage, String)]

    // MARK: - Factory

    static let step1 = NSOnboardingStepModel(heading: "onboarding_prinzip_heading".ub_localized,
                                             headingColor: .ns_blue,
                                             foregroundImage: UIImage(named: "onboarding-prinzip")!,
                                             title: "onboarding_prinzip_title".ub_localized,
                                             textGroups: [
                                                 (UIImage(named: "ic-tracing-onboarding")!, "onboarding_prinzip_text1".ub_localized),
                                                 (UIImage(named: "ic-meldung")!, "onboarding_prinzip_text2".ub_localized),
                                             ])

    static let step2 = NSOnboardingStepModel(heading: "onboarding_privacy_heading".ub_localized,
                                             headingColor: .ns_green,
                                             foregroundImage: UIImage(named: "onboarding-privacy")!,
                                             title: "onboarding_privacy_title".ub_localized,
                                             textGroups: [
                                                 (UIImage(named: "ic-lock")!, "onboarding_privacy_text1".ub_localized),
                                                 (UIImage(named: "ic-key")!, "onboarding_privacy_text2".ub_localized),
                                             ])

    static let step3 = NSOnboardingStepModel(heading: "onboarding_begegnungen_heading".ub_localized,
                                             headingColor: .ns_blue,
                                             foregroundImage: UIImage(named: "onboarding-bluetooth")!,
                                             title: "onboarding_begegnungen_title".ub_localized,
                                             textGroups: [
                                                 (UIImage(named: "ic-tracing-onboarding")!, "onboarding_begegnungen_text1".ub_localized),
                                                 (UIImage(named: "ic-bt")!, "onboarding_begegnungen_text2".ub_localized),
                                             ])

    static let step5 = NSOnboardingStepModel(heading: "onboarding_meldung_heading".ub_localized,
                                             headingColor: .ns_blue,
                                             foregroundImage: UIImage(named: "onboarding-meldung")!,
                                             title: "onboarding_meldung_title".ub_localized,
                                             textGroups: [
                                                 (UIImage(named: "ic-meldung")!, "onboarding_meldung_text1".ub_localized),
                                                 (UIImage(named: "ic-isolation")!, "onboarding_meldung_text2".ub_localized),
                                             ])
}
