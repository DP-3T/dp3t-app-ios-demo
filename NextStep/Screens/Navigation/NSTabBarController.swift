/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSTabBarController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
        style()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if NSContentEnvironment.current.isGenericTracer {
            viewControllers = [
                NSHomescreenViewController(),
                NSAboutViewController(),
            ]
        } else {
            viewControllers = [
                NSHomescreenViewController(),
                NSVerhaltenViewController(),
                NSInfoViewController(),
                NSAboutViewController(),
            ]
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presentOnboardingIfNeeded()
    }

    private func style() {
        tabBar.tintColor = UIColor.ns_secondary

        let font = UIFont(name: "Inter-Light", size: 12.0)
        let attributes = [NSAttributedString.Key.font: font]

        UITabBarItem.appearance().setTitleTextAttributes(attributes as [NSAttributedString.Key: Any], for: .normal)
    }

    private func presentOnboardingIfNeeded() {
        if !User.shared.hasCompletedOnboarding {
            let onboardingViewController = NSOnboardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            present(onboardingViewController, animated: false)
        }
    }
}
