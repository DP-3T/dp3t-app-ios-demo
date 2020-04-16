/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSBegegnungenDetailViewController: NSViewController {
    private let stackScrollView = NSStackScrollView()

    private let imageView = UIImageView(image: UIImage(named: "onboarding-4"))

    private let bluetoothControl = NSBluetoothSettingsControl()

    // MARK: - Init

    override init() {
        super.init()
        title = "handshakes_title_homescreen".ub_localized
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ns_background_secondary
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackScrollView.addSpacerView(NSPadding.large)

        let v = UIView()
        v.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
        }

        stackScrollView.addArrangedView(v)

        stackScrollView.addSpacerView(NSPadding.large)

        let control = UIView()
        control.addSubview(bluetoothControl)
        bluetoothControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15.0)
            make.top.bottom.equalToSuperview().inset(15.0)
        }

        bluetoothControl.viewToBeLayouted = view

        stackScrollView.addArrangedView(control)

        stackScrollView.addSpacerView(30.0)

        stackScrollView.addArrangedView(explanationView(title: "bluetooth_setting_tracking_explanation_title".ub_localized, texts: [
            "bluetooth_setting_tracking_explanation_text1".ub_localized, "bluetooth_setting_tracking_explanation_text2".ub_localized,
        ]))

        stackScrollView.addSpacerView(30.0)

        stackScrollView.addArrangedView(explanationView(title: "bluetooth_setting_data_explanation_title".ub_localized, texts: [
            "bluetooth_setting_data_explanation_text1".ub_localized, "bluetooth_setting_data_explanation_text2".ub_localized,
        ]))

        stackScrollView.addSpacerView(30.0)
    }

    private func explanationView(title: String, texts: [String]) -> UIView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2 * NSPadding.medium

        let titleLabel = NSLabel(.textSemiBold)
        titleLabel.text = title

        stackView.addArrangedView(titleLabel)

        for t in texts {
            let v = NSPointTextView(text: t)
            stackView.addArrangedView(v)
        }

        let v = UIView()
        v.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: NSPadding.large, bottom: 0, right: NSPadding.large))
        }

        return v
    }
}
