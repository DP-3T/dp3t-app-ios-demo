/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInformViewController: NSInformStepViewController {
    static func present(from rootViewController: UIViewController) {
        let informVC: UIViewController

        if NSContentEnvironment.current.hasSymptomInputs {
            informVC = NSInformViewController()
        } else {
            informVC = NSSendViewController(flow: .tested)
        }

        let navCon = NSNavigationController(rootViewController: informVC)
        rootViewController.present(navCon, animated: true, completion: nil)
    }

    let stackScrollView = NSStackScrollView(axis: .vertical, spacing: 0)
    let titleLabel = NSLabel(.title, textColor: .ns_secondary, textAlignment: .center)
    let textLabel = NSLabel(.text, textAlignment: .center)

    let buttonSymptome = NSInformButton(title: "inform_button_symptom_title".ub_localized, text: "inform_button_symptom_text".ub_localized)
    let buttonPositive = NSInformButton(title: "inform_button_positive_title".ub_localized, text: "inform_button_positive_text".ub_localized)

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(NSPadding.medium * 3.0)
        }

        titleLabel.text = "inform_title".ub_localized
        textLabel.text = "inform_subtext".ub_localized

        stackScrollView.addSpacerView(NSPadding.medium * 4.0)
        stackScrollView.addArrangedView(titleLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 2.0)
        stackScrollView.addArrangedView(textLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 4.0)
        stackScrollView.addArrangedView(buttonSymptome)
        stackScrollView.addSpacerView(NSPadding.medium * 3.0)
        stackScrollView.addArrangedView(buttonPositive)
        stackScrollView.addSpacerView(NSPadding.medium * 3.0)

        buttonSymptome.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.pushViewController(NSSymptomsViewController(), animated: true)
        }

        buttonPositive.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.pushViewController(NSSendViewController(flow: .tested), animated: true)
        }
    }
}
