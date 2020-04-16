/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSSymptomsViewController: NSInformBottomButtonViewController {
    let stackScrollView = NSStackScrollView(axis: .vertical, spacing: 0)

    private let titleLabel = NSLabel(.subtitle, textColor: .ns_primary, numberOfLines: 0, textAlignment: .center)
    private let textLabel = NSLabel(.text, textAlignment: .center)

    private let checkboxes = [NSCheckBoxView(text: "inform_symptom_coughdry".ub_localized), NSCheckBoxView(text: "inform_symptom_hals".ub_localized), NSCheckBoxView(text: "inform_symptom_kurzatmigkeit".ub_localized), NSCheckBoxView(text: "inform_symptom_fieber".ub_localized), NSCheckBoxView(text: "inform_symptom_muskel".ub_localized)]

    private var noSymptomCheckbox = NSCheckBoxView(text: "inform_no_symptom".ub_localized)

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()

        enableBottomButton = false
    }

    private func setup() {
        bottomButtonTitle = "inform_continue_button".ub_localized
        bottomButtonTouchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.continuePressed()
        }

        titleLabel.text = "inform_button_symptom_title".ub_localized
        textLabel.text = "inform_symptom_starttext".ub_localized

        contentView.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(NSPadding.medium * 3.0)
        }

        stackScrollView.addSpacerView(NSPadding.medium * 4.0)
        stackScrollView.addArrangedView(titleLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 2.0)
        stackScrollView.addArrangedView(textLabel)
        stackScrollView.addSpacerView(NSPadding.medium * 4.0)

        for c in checkboxes {
            stackScrollView.addArrangedView(c)
            stackScrollView.addSpacerView(NSPadding.small)

            c.touchUpCallback = { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.symptomPressed()
            }
        }

        stackScrollView.addSpacerView(NSPadding.medium * 3.0)

        stackScrollView.addArrangedView(noSymptomCheckbox)

        noSymptomCheckbox.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.noSymptomPressed()
        }
    }

    private func continuePressed() {
        if noSymptomCheckbox.isChecked {
            navigationController?.pushViewController(NSInformNoSymptomsViewController(), animated: true)
        } else {
            navigationController?.pushViewController(NSSendViewController(flow: .symptoms), animated: true)
        }
    }

    private func symptomPressed() {
        noSymptomCheckbox.isChecked = false

        let hasOne = checkboxes.contains { $0.isChecked }

        enableBottomButton = hasOne
    }

    private func noSymptomPressed() {
        for c in checkboxes {
            c.isChecked = false
        }

        enableBottomButton = noSymptomCheckbox.isChecked
    }
}
