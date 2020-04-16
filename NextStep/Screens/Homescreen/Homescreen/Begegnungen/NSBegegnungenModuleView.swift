/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import DP3TSDK
import SnapKit
import UIKit

class NSBegegnungenModuleView: NSModuleBaseView {
    var uiState: NSUIStateModel.Homescreen.Begegnungen.Tracing = .active {
        didSet { updateUI() }
    }

    private let tracingActiveView = NSBluetoothSettingsDetailView(title: "tracing_active_title".ub_localized, subText: "tracing_active_text".ub_localized, image: UIImage(named: "ic-check")!, titleColor: .ns_secondary, subtextColor: .ns_text)
    private let tracingInactiveView = NSBluetoothSettingsDetailView(title: "tracing_error_title".ub_localized, subText: "tracing_error_text".ub_localized, image: UIImage(named: "ic-error")!, titleColor: .ns_error, subtextColor: .ns_error)

    override init() {
        super.init()

        headerIcon = UIImage(named: "ic-begegnungen")!
        headerTitle = "handshakes_title_homescreen".ub_localized

        updateUI()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sectionViews() -> [UIView] {
        [tracingActiveView, tracingInactiveView]
    }

    private func updateUI() {
        updateLayout()
        stackView.setNeedsLayout()
        let isTracingActive = uiState == .active
        tracingActiveView.alpha = isTracingActive ? 1 : 0
        tracingInactiveView.alpha = isTracingActive ? 0 : 1
        tracingActiveView.isHidden = !isTracingActive
        tracingInactiveView.isHidden = isTracingActive
        stackView.layoutIfNeeded()
    }
}

//// MARK: - Handshake Count View
//
// private class NSHandshakesModuleCountView: UIView {
//    // State
//    var handshakeCount: Int {
//        didSet {
//            updateState(animated: true)
//        }
//    }
//
//    private var iconImageView = UIImageView(image: UIImage(named: "ic-check"))
//    private var infoLabel = NSLabel(.text)
//    private var countLabel = NSFancyNumberView()
//    private var begegnungenLabel = NSLabel(.smallBold, textColor: .ns_secondary, numberOfLines: 1)
//    private var begegnungenImageView = UIImageView(image: UIImage(named: "ic-begegnungen-fancy"))
//
//    // MARK: - Initialization
//
//    init(handshakeCount: Int = 0) {
//        self.handshakeCount = handshakeCount
//        super.init(frame: .zero)
//
//        infoLabel.text = "homescreen_handshakes_module_count_info_label".ub_localized
//        begegnungenLabel.text = "begegnungen_counter_title".ub_localized
//
//        setupLayout()
//        updateState(animated: false)
//    }
//
//    required init?(coder _: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupLayout() {
//        addSubview(iconImageView)
//        addSubview(infoLabel)
//        addSubview(countLabel)
//        addSubview(begegnungenLabel)
//        addSubview(begegnungenImageView)
//
//        layoutMargins = UIEdgeInsets(top: 18, left: 70, bottom: 25, right: 22)
//
//        infoLabel.snp.makeConstraints { make in
//            make.leading.top.trailing.equalTo(layoutMargins)
//        }
//
//        begegnungenImageView.snp.makeConstraints { make in
//            make.left.bottom.equalTo(layoutMargins)
//        }
//
//        begegnungenImageView.ub_setContentPriorityRequired()
//
//        countLabel.snp.makeConstraints { make in
//            make.left.equalTo(begegnungenImageView.snp.right).offset(NSPadding.medium)
//            make.top.equalTo(infoLabel.snp.bottom).offset(NSPadding.medium)
//            make.bottom.equalTo(begegnungenLabel).offset(5.0)
//        }
//        iconImageView.snp.makeConstraints { make in
//            make.top.equalTo(layoutMargins)
//            make.leading.equalToSuperview().inset(31)
//            make.size.equalTo(24)
//        }
//
//        begegnungenLabel.snp.makeConstraints { make in
//            make.bottom.equalTo(layoutMargins)
//            make.left.equalTo(countLabel.snp.right).offset(5.0)
//            make.trailing.lessThanOrEqualTo(layoutMargins)
//        }
//    }
//
//    private func updateState(animated: Bool) {
//        countLabel.setNumber(number: handshakeCount, animated: animated)
//    }
// }
//
//// MARK: - Kontakt Gemeldet View
//
// class NSHandshakesModuleKontaktGemeldetView: UIView {
//    private let iconImageView = UIImageView()
//    private let stackView = UIStackView()
//    private let infoLabel = NSLabel(.text)
//    private let gemeldetLabel = NSLabel(.text)
//    private let gemeldetSpacer = UIView()
//
//    private let exposedInfoLabel = NSLabel(.text)
//    private let exposedSpacer = UIView()
//    private let exposedTelButton = NSButton(title: "exposed_info_tel_button_title".ub_localized, style: .secondary)
//
//    private let timestampLabel = NSLabel(.text)
//
//    var infectionStatus: InfectionStatus {
//        didSet {
//            updateState()
//        }
//    }
//
//    // MARK: - Initialization
//
//    init(infectionStatus status: InfectionStatus) {
//        infectionStatus = status
//        super.init(frame: .zero)
//
//        switch NSContentEnvironment.current {
//        case .health(symptoms: true):
//            infoLabel.text = "homescreen_handshakes_module_info_label".ub_localized
//            gemeldetLabel.text = "homescreen_handshakes_module_gemeldet_label".ub_localized
//        case .health(symptoms: false):
//            infoLabel.text = "homescreen_handshakes_module_info_label_nosymptoms".ub_localized
//            gemeldetLabel.text = "homescreen_handshakes_module_gemeldet_label".ub_localized
//        case .star:
//            infoLabel.text = "homescreen_handshakes_module_info_label_star".ub_localized
//            gemeldetLabel.text = "homescreen_handshakes_module_gemeldet_label_star".ub_localized
//        }
//
//        exposedInfoLabel.text = "exposed_info_support_text".ub_localized
//
//        setupLayout()
//        updateState()
//    }
//
//    required init?(coder _: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupLayout() {
//        layoutMargins = UIEdgeInsets(top: 13, left: 70, bottom: 21, right: 22)
//
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//
//        addSubview(iconImageView)
//        iconImageView.snp.makeConstraints { make in
//            make.top.equalTo(layoutMargins)
//            make.leading.equalToSuperview().inset(31)
//            make.size.equalTo(24)
//        }
//
//        // TODO: Fix insets
//        addSubview(stackView)
//        stackView.snp.makeConstraints { make in
//            make.edges.equalTo(layoutMargins)
//        }
//
//        gemeldetSpacer.snp.makeConstraints { make in
//            make.height.equalTo(NSPadding.medium)
//        }
//
//        exposedSpacer.snp.makeConstraints { make in
//            make.height.equalTo(NSPadding.medium)
//        }
//
//        stackView.addArrangedView(infoLabel)
//        stackView.addArrangedView(gemeldetLabel)
//        stackView.addArrangedView(gemeldetSpacer)
//        stackView.addArrangedView(exposedInfoLabel)
//        stackView.addArrangedView(exposedSpacer)
//        stackView.addArrangedView(exposedTelButton)
//
//        exposedTelButton.touchUpCallback = { [weak self] in
//            guard let strongSelf = self,
//                var phoneNumber = strongSelf.exposedTelButton.title
//            else { return }
//
//            phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+", with: "00")
//
//            if let url = URL(string: "tel://\(phoneNumber)") {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
//    }
//
//    private func updateState() {
//        if infectionStatus == .infected {
//            infoLabel.isHidden = true
//            gemeldetLabel.isHidden = true
//            gemeldetSpacer.isHidden = true
//            exposedInfoLabel.isHidden = true
//            exposedSpacer.isHidden = true
//            exposedTelButton.isHidden = true
//            iconImageView.image = nil
//        } else {
//            let isExposed = infectionStatus == .exposed
//            infoLabel.isHidden = isExposed
//            gemeldetLabel.isHidden = !isExposed
//            gemeldetSpacer.isHidden = !isExposed
//            exposedInfoLabel.isHidden = !isExposed
//            exposedSpacer.isHidden = !isExposed
//            exposedTelButton.isHidden = !isExposed
//            iconImageView.image = isExposed ? #imageLiteral(resourceName: "ic-info-on") : #imageLiteral(resourceName: "ic-info-off")
//        }
//    }
// }
