/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSMeldungenDetailNoMeldungenViewController: NSTitleViewScrollViewController {
    // MARK: - Init

    override init() {
        super.init()
        titleView = NSMeldungenDetailNoMeldungenTitleView()
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    // MARK: - Setup

    private func setupLayout() {
        let whiteBoxView = NSSimpleModuleBaseView(title: "no_meldungen_box_title".ub_localized, subtitle: "no_meldungen_box_subtitle".ub_localized, text: "no_meldungen_box_text".ub_localized, image: UIImage(named: "illu-no-message"), subtitleColor: .ns_green)

        let buttonView = UIView()

        let externalLinkButton = NSExternalLinkButton(color: .ns_green)
        externalLinkButton.title = "no_meldungen_box_link".ub_localized
        externalLinkButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.externalLinkPressed()
        }

        buttonView.addSubview(externalLinkButton)
        externalLinkButton.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }

        whiteBoxView.contentView.addSpacerView(NSPadding.medium)
        whiteBoxView.contentView.addArrangedView(buttonView)

        stackScrollView.addArrangedView(whiteBoxView)

        stackScrollView.addSpacerView(3.0 * NSPadding.large)

        stackScrollView.addArrangedView(NSOnboardingInfoView(icon: UIImage(named: "ic-meldung")!, text: "meldungen_nomeldungen_faq1_text".ub_localized, title: "meldungen_nomeldungen_faq1_title".ub_localized, leftRightInset: 0))

        stackScrollView.addSpacerView(2.0 * NSPadding.medium)

        stackScrollView.addArrangedView(NSOnboardingInfoView(icon: UIImage(named: "ic-tracing")!, text: "meldungen_nomeldungen_faq2_text".ub_localized, title: "meldungen_nomeldungen_faq2_titel".ub_localized, leftRightInset: 0))

        stackScrollView.addSpacerView(3 * NSPadding.large)

        stackScrollView.addSpacerView(NSPadding.large)
    }

    override var titleHeight: CGFloat {
        return super.titleHeight * NSFontSize.fontSizeMultiplicator
    }

    override var startPositionScrollView: CGFloat {
        return titleHeight - 30
    }

    // MARK: - Logic

    private func externalLinkPressed() {
        if let url = URL(string: "no_meldungen_box_url".ub_localized) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
