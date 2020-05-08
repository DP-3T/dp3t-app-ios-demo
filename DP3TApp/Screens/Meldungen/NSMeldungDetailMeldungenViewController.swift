/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSMeldungDetailMeldungenViewController: NSTitleViewScrollViewController {
    // MARK: - API

    public var meldungen: [UIStateModel.MeldungenDetail.NSMeldungModel] = [] {
        didSet { update() }
    }

    public var showMeldungWithAnimation: Bool = false

    public var phoneCallState: UIStateModel.MeldungenDetail.PhoneCallState = .notCalled {
        didSet { update() }
    }

    // MARK: - Views

    private var callLabels = [NSLabel]()
    private var notYetCalledView: NSSimpleModuleBaseView?
    private var alreadyCalledView: NSSimpleModuleBaseView?
    private var callAgainView: NSSimpleModuleBaseView?

    private var daysLeftLabels = [NSLabel]()

    private var overrideHitTestAnyway: Bool = true

    // MARK: - Init

    override init() {
        super.init()
        titleView = NSMeldungDetailMeldungTitleView(overlapInset: titleHeight - startPositionScrollView)

        stackScrollView.hitTestDelegate = self
    }



    override var useFullScreenHeaderAnimation: Bool {
        return UIAccessibility.isVoiceOverRunning ? false : showMeldungWithAnimation
    }

    override var titleHeight: CGFloat {
        return 260.0 * NSFontSize.fontSizeMultiplicator
    }

    override var startPositionScrollView: CGFloat {
        return titleHeight - 30
    }

    override func startHeaderAnimation() {
        overrideHitTestAnyway = false

        for m in meldungen {
            UserStorage.shared.registerSeenMessages(identifier: m.identifier)
        }
        
        super.startHeaderAnimation()
    }

    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }


    // MARK: - Setup

    private func setupLayout() {
        notYetCalledView = makeNotYetCalledView()
        alreadyCalledView = makeAlreadyCalledView()
        callAgainView = makeCallAgainView()

        // !: function have return type UIView
        stackScrollView.addArrangedView(notYetCalledView!)
        stackScrollView.addArrangedView(alreadyCalledView!)
        stackScrollView.addArrangedView(callAgainView!)
        stackScrollView.addSpacerView(NSPadding.large)

        stackScrollView.addSpacerView(2 * NSPadding.large)

        stackScrollView.addArrangedView(NSOnboardingInfoView(icon: UIImage(named: "ic-call")!, text: "meldungen_meldungen_faq1_text".ub_localized, title: "meldungen_meldungen_faq1_title".ub_localized, leftRightInset: 0))

        stackScrollView.addSpacerView(3 * NSPadding.large)

        stackScrollView.addSpacerView(NSPadding.large)
    }

    // MARK: - Update

    private func update() {
        if let tv = titleView as? NSMeldungDetailMeldungTitleView {
            tv.meldungen = meldungen
        }

        notYetCalledView?.isHidden = phoneCallState != .notCalled
        alreadyCalledView?.isHidden = phoneCallState != .calledAfterLastExposure
        callAgainView?.isHidden = phoneCallState != .multipleExposuresNotCalled

        if let lastMeldungId = meldungen.last?.identifier,
            let lastCall = UserStorage.shared.lastPhoneCall(for: lastMeldungId) {
            callLabels.forEach {
                $0.text = "meldungen_detail_call_last_call".ub_localized.replacingOccurrences(of: "{DATE}", with: DateFormatter.ub_string(from: lastCall))
            }
            daysLeftLabels.forEach {
                $0.text = DateFormatter.ub_inDays(until: lastCall.addingTimeInterval(60 * 60 * 24 * 10)) // 10 days after last exposure
            }
        }
    }

    // MARK: - Detail Views

    private func makeNotYetCalledView() -> NSSimpleModuleBaseView {
        let whiteBoxView = NSSimpleModuleBaseView(title: "meldungen_detail_call".ub_localized, subtitle: "meldung_detail_positive_test_box_subtitle".ub_localized, boldText: "infoline_tel_number".ub_localized, text: "meldungen_detail_call_text".ub_localized, image: UIImage(named: "illu-anrufen"), subtitleColor: .ns_blue)

        whiteBoxView.contentView.addSpacerView(NSPadding.medium)

        let callButton = NSButton(title: "meldungen_detail_call_button".ub_localized, style: .uppercase(.ns_blue))

        callButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.call()
        }

        whiteBoxView.contentView.addArrangedSubview(callButton)
        whiteBoxView.contentView.addSpacerView(40.0)
        whiteBoxView.contentView.addArrangedSubview(createExplanationView())
        whiteBoxView.contentView.addSpacerView(NSPadding.large)
        whiteBoxView.contentView.addArrangedSubview(createExternalLinkButton())
        whiteBoxView.contentView.addSpacerView(20.0)

        return whiteBoxView
    }

    private func makeAlreadyCalledView() -> NSSimpleModuleBaseView {
        let whiteBoxView = NSSimpleModuleBaseView(title: "meldungen_detail_call_thankyou_title".ub_localized, subtitle: "meldungen_detail_call_thankyou_subtitle".ub_localized, text: "meldungen_detail_guard_text".ub_localized, image: UIImage(named: "illu-verhalten"), subtitleColor: .ns_blue)

        whiteBoxView.contentView.addSpacerView(NSPadding.medium)

        let callButton = NSButton(title: "meldungen_detail_call_again_button".ub_localized, style: .outlineUppercase(.ns_blue))

        callButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.call()
        }

        whiteBoxView.contentView.addArrangedSubview(callButton)
        whiteBoxView.contentView.addSpacerView(NSPadding.medium)
        whiteBoxView.contentView.addArrangedSubview(createCallLabel())
        whiteBoxView.contentView.addSpacerView(40.0)
        whiteBoxView.contentView.addArrangedSubview(createExplanationView())
        whiteBoxView.contentView.addSpacerView(NSPadding.large)
        whiteBoxView.contentView.addArrangedSubview(createExternalLinkButton())
        whiteBoxView.contentView.addSpacerView(20.0)

        return whiteBoxView
    }

    private func makeCallAgainView() -> NSSimpleModuleBaseView {
        let whiteBoxView = NSSimpleModuleBaseView(title: "meldungen_detail_call_again".ub_localized, subtitle: "meldung_detail_positive_test_box_subtitle".ub_localized, boldText: "infoline_tel_number".ub_localized, text: "meldungen_detail_guard_text".ub_localized, image: UIImage(named: "illu-anrufen"), subtitleColor: .ns_blue)

        whiteBoxView.contentView.addSpacerView(NSPadding.medium)

        let callButton = NSButton(title: "meldungen_detail_call_button".ub_localized, style: .uppercase(.ns_blue))

        callButton.touchUpCallback = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.call()
        }

        whiteBoxView.contentView.addArrangedSubview(callButton)
        whiteBoxView.contentView.addSpacerView(NSPadding.medium)
        whiteBoxView.contentView.addArrangedSubview(createCallLabel())
        whiteBoxView.contentView.addSpacerView(40.0)
        whiteBoxView.contentView.addArrangedSubview(createExplanationView())
        whiteBoxView.contentView.addSpacerView(NSPadding.large)
        whiteBoxView.contentView.addArrangedSubview(createExternalLinkButton())
        whiteBoxView.contentView.addSpacerView(20.0)

        return whiteBoxView
    }

    private func createCallLabel() -> NSLabel {
        let label = NSLabel(.smallRegular)
        callLabels.append(label)
        return label
    }

    private func createExplanationView() -> UIView {
        let ev = NSExplanationView(title: "meldungen_detail_explanation_title".ub_localized, texts: ["meldungen_detail_explanation_text1".ub_localized, "meldungen_detail_explanation_text2".ub_localized, "meldungen_detail_explanation_text3".ub_localized], edgeInsets: .zero)

        let wrapper = UIView()
        let daysLeftLabel = NSLabel(.textBold)
        daysLeftLabels.append(daysLeftLabel)
        wrapper.addSubview(daysLeftLabel)
        daysLeftLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }

        ev.stackView.insertArrangedSubview(wrapper, at: 3)
        ev.stackView.setCustomSpacing(NSPadding.small, after: ev.stackView.arrangedSubviews[2])

        return ev
    }

    private func createExternalLinkButton() -> NSExternalLinkButton {
        let button = NSExternalLinkButton(color: .ns_blue)
        button.title = "meldungen_explanation_link_title".ub_localized
        button.touchUpCallback = {
            if let url = URL(string: "meldungen_explanation_link_url".ub_localized), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        return button
    }

    // MARK: - Logic

    private func call() {
        guard let last = meldungen.last else { return }

        let phoneNumber = "infoline_tel_number".ub_localized
        PhoneCallHelper.call(phoneNumber)

        UserStorage.shared.registerPhoneCall(identifier: last.identifier)
        UIStateManager.shared.refresh()
    }
}

extension NSMeldungDetailMeldungenViewController: NSHitTestDelegate {
    func overrideHitTest(_ point: CGPoint, with _: UIEvent?) -> Bool {
        if overrideHitTestAnyway && useFullScreenHeaderAnimation {
            return true
        }

        return point.y + stackScrollView.scrollView.contentOffset.y < startPositionScrollView
    }
}
