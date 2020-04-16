/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import SnapKit
import UIKit

class NSOnboardingViewController: NSViewController {
    private let pageControl = UIPageControl()

    private let leftSwipeRecognizer = UISwipeGestureRecognizer()
    private let rightSwipeRecognizer = UISwipeGestureRecognizer()

    private let step1VC = NSOnboardingStepViewController(model: NSOnboardingStepModel(heading: " ", foregroundImage: UIImage(named: "onboarding-1")!, title: "onboarding_title_1".ub_localized, text: "onboarding_desc_1".ub_localized))
    private let step2VC = NSOnboardingStepViewController(model: NSOnboardingStepModel(heading: "Was macht die App:", foregroundImage: UIImage(named: "onboarding-2")!, title: "onboarding_title_2".ub_localized, text: "onboarding_desc_2".ub_localized))
    private let step3VC = NSOnboardingStepViewController(model: NSOnboardingStepModel(heading: "Was macht die App:", foregroundImage: UIImage(named: "onboarding-3")!, title: "onboarding_title_3".ub_localized, text: "onboarding_desc_3".ub_localized))
    private let step4VC = NSOnboardingPermissionsViewController()
    private let step5VC = NSOnboardingStepViewController(model: NSOnboardingStepModel(heading: " ", foregroundImage: UIImage(named: "onboarding-3")!, title: "onboarding_title_5".ub_localized, text: "onboarding_desc_5".ub_localized))

    private var stepViewControllers: [NSOnboardingContentViewController] {
        if NSContentEnvironment.current.isGenericTracer {
            return [step4VC]
        } else {
            return [step1VC, step2VC, step3VC, step4VC, step5VC]
        }
    }

    private let finishButton = NSButton(title: "onboarding_finish_button".ub_localized)

    private var currentStep: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        step4VC.continueButton.touchUpCallback = { [weak self] in
            guard let self = self else { return }
            if NSContentEnvironment.current.isGenericTracer {
                self.finishAnimation()
            } else {
                self.setOnboardingStep(self.currentStep + 1, animated: true)
            }
        }
        step4VC.continueWithoutButton.touchUpCallback = { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: nil, message: "onboarding_continue_without_popup_text".ub_localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "onboarding_continue_without_popup_abort".ub_localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "onboarding_continue_without_popup_continue".ub_localized, style: .default, handler: { _ in
                self.setOnboardingStep(self.currentStep + 1, animated: true)
            }))

            self.present(alert, animated: true, completion: nil)
        }

        setupSwipeRecognizers()
        addStepViewControllers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setOnboardingStep(0, animated: true)
    }

    fileprivate func setOnboardingStep(_ step: Int, animated: Bool) {
        guard step >= 0, step < stepViewControllers.count else { return }
        let isLast = step == stepViewControllers.count - 1

        if isLast, !NSContentEnvironment.current.isGenericTracer {
            finishButton.alpha = 0
            finishButton.transform = CGAffineTransform(translationX: 300, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [.beginFromCurrentState], animations: {
                self.finishButton.alpha = 1
                self.finishButton.transform = .identity
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.2, options: [.beginFromCurrentState], animations: {
                self.finishButton.alpha = 0
                self.finishButton.transform = CGAffineTransform(translationX: 300, y: 0)
            }, completion: nil)
        }

        let forward = step >= currentStep

        let vcToShow = stepViewControllers[step]
        vcToShow.view.isHidden = false

        vcToShow.view.layoutIfNeeded()

        if animated {
            vcToShow.fadeAnimation(fromFactor: forward ? 1 : -1, toFactor: 0, delay: 0.3, completion: nil)
        }

        if step > 0, forward {
            let vcToHide = stepViewControllers[step - 1]
            vcToHide.fadeAnimation(fromFactor: 0, toFactor: -1, delay: 0.0, completion: { completed in
                if completed {
                    vcToHide.view.isHidden = true
                }
            })
        } else if step < stepViewControllers.count - 1, !forward {
            let vcToHide = stepViewControllers[step + 1]
            vcToHide.fadeAnimation(fromFactor: 0, toFactor: 1, delay: 0.0, completion: { completed in
                if completed {
                    vcToHide.view.isHidden = true
                }
            })
        }

        currentStep = step

        pageControl.currentPage = currentStep
    }

    private func finishAnimation() {
        let vcToHide = stepViewControllers[currentStep]
        UIView.animate(withDuration: 0.4, delay: 0, options: [.beginFromCurrentState], animations: {
            self.finishButton.alpha = 0
            self.finishButton.transform = CGAffineTransform(translationX: -300, y: 0)
        }, completion: nil)
        vcToHide.fadeAnimation(fromFactor: 0, toFactor: -1, delay: 0.0) { (_) -> Void in
            User.shared.hasCompletedOnboarding = true
            self.dismiss(animated: true, completion: nil)
        }
    }

    private func setupViews() {
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(NSPadding.medium)
        }

        pageControl.currentPageIndicatorTintColor = .ns_secondary
        pageControl.pageIndicatorTintColor = .ns_text
        pageControl.numberOfPages = stepViewControllers.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false

        view.addSubview(finishButton)
        finishButton.snp.makeConstraints { make in
            make.bottom.equalTo(pageControl.snp.top).offset(-NSPadding.small)
            make.centerX.equalToSuperview()
        }
        finishButton.touchUpCallback = finishAnimation
        finishButton.alpha = 0

        if NSContentEnvironment.current.isGenericTracer {
            pageControl.isHidden = true
        }
    }

    private func setupSwipeRecognizers() {
        leftSwipeRecognizer.direction = .left
        leftSwipeRecognizer.addTarget(self, action: #selector(didSwipe(recognizer:)))
        view.addGestureRecognizer(leftSwipeRecognizer)

        rightSwipeRecognizer.direction = .right
        rightSwipeRecognizer.addTarget(self, action: #selector(didSwipe(recognizer:)))
        view.addGestureRecognizer(rightSwipeRecognizer)
    }

    private func addStepViewControllers() {
        for vc in stepViewControllers {
            addChild(vc)
            view.insertSubview(vc.view, belowSubview: finishButton)
            vc.view.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.bottom.equalTo(pageControl.snp.top).inset(NSPadding.small)
            }
            vc.didMove(toParent: self)

            vc.view.isHidden = true
        }
    }

    @objc private func didSwipe(recognizer: UISwipeGestureRecognizer) {
        switch recognizer.direction {
        case .left:
            if currentStep == 3 { // Disable swipe forward on permission screen
                return
            }
            setOnboardingStep(currentStep + 1, animated: true)
        case .right:
            setOnboardingStep(currentStep - 1, animated: true)
        default:
            break
        }
    }
}
