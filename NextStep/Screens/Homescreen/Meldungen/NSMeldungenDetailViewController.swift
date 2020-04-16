/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSMeldungenDetailViewController: NSViewController {
    private let stackScrollView = NSStackScrollView()

    private let imageView = UIImageView(image: UIImage(named: "24-ansteckung"))

    // MARK: - Init

    override init() {
        super.init()
        title = "reports_title_homescreen".ub_localized
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ns_background_secondary

        NSUIStateManager.shared.addObserver(self) { [weak self] state in
            guard let self = self else { return }
            let meldung = state.meldungenDetail.meldung
            self.setup(meldung)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Setup

    private func setup(_ meldung: NSUIStateModel.MeldungenDetail.Meldung) {
        for v in view.subviews {
            v.removeFromSuperview()
        }

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

        let title: String
        let subText: String
        switch meldung {
        case .exposed:
            title = "hinweis_title".ub_localized
            subText = "hinweis_text".ub_localized
        case .infected:
            title = "meldungen_infected_title".ub_localized
            subText = "meldungen_infected_text".ub_localized
        case .noMeldung:
            title = "meldungen_no_meldungen_title".ub_localized
            subText = "meldungen_no_meldungen_text".ub_localized
        }

        let highlight = meldung != .noMeldung

        let titleColor = highlight ? UIColor.white : UIColor.ns_secondary
        let textColor = highlight ? UIColor.white : UIColor.ns_text
        let image = highlight ? UIImage(named: "ic-info") : UIImage(named: "ic-check")
        let backgroundColor = highlight ? .ns_primary : UIColor(ub_hexString: "#d3f2ee")

        stackScrollView.addSpacerView(NSPadding.large)

        let container = UIView()
        let view = NSBluetoothSettingsDetailView(title: title, subText: subText, image: image, titleColor: titleColor, subtextColor: textColor, backgroundColor: backgroundColor, backgroundInset: false, hasBubble: true)

        container.addSubview(view)

        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0.0, left: 14.0, bottom: 0.0, right: 14.0))
        }

        stackScrollView.addArrangedView(container)

        if highlight {
            let v = meldungenInfoView(meldung: meldung)

            let c = UIView()
            c.addSubview(v)

            v.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0.0, left: 14.0, bottom: 0.0, right: 14.0))
            }

            stackScrollView.addArrangedView(c)
            stackScrollView.stackView.sendSubviewToBack(c)
        }

        // TODO: Missing view: If Push is not working, add a view here
        // (see here: https://app.zeplin.io/project/5e7e78de356f3e6c665c93cb/screen/5e95b2133501187a87ca7a34

        stackScrollView.addSpacerView(30.0)

        stackScrollView.addArrangedView(explanationView(title: "meldungen_additional_info_title".ub_localized, texts: [
            "meldungen_additional_info_text1".ub_localized, "meldungen_additional_info_text2".ub_localized,
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

    private func meldungenInfoView(meldung: NSUIStateModel.MeldungenDetail.Meldung) -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor(ub_hexString: "#e9e9e9")
        v.layer.borderColor = UIColor(ub_hexString: "#dfdfdf")?.cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 3.0

        // TODO: Missing views:
        // see here: https://app.zeplin.io/project/5e7e78de356f3e6c665c93cb/screen/5e95b21377cb6f519d690c91
        // Button logic to call (search for exposed_info_tel_button_title)
        // Remove fix height of this view (search for 200)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2 * NSPadding.medium

        v.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: NSPadding.large, left: NSPadding.large, bottom: 2 * NSPadding.medium, right: NSPadding.large))
        }

        let titleLabel = NSLabel(.textSemiBold)
        titleLabel.text = "meldungen_additional_info_title".ub_localized

        stackView.addArrangedView(titleLabel)

        let ptv = NSPointTextView(text: meldung == .exposed ? "meldungen_hinweis_info_text1".ub_localized : "meldungen_hinweis_info_text1_infected".ub_localized)
        stackView.addArrangedView(ptv)

        let titleLabel2 = NSLabel(.textSemiBold)
        titleLabel2.text = "meldungen_additional_info_title2".ub_localized

        stackView.addArrangedView(titleLabel2)

        let ptv2 = NSPointTextView(text: "meldungen_additional_info_text3".ub_localized)
        stackView.addArrangedView(ptv2)

        let button = NSButton(title: "meldungen_call_button_title".ub_localized)

        button.touchUpCallback = {
            var phoneNumber = "exposed_info_tel_button_title".ub_localized

            phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+", with: "00")

            if let url = URL(string: "tel://\(phoneNumber)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        stackView.addArrangedView(button)

        return v
    }
}
