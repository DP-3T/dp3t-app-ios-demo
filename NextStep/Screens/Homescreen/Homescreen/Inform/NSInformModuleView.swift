/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInformModuleView: NSModuleBaseView {
    enum ModuleState {
        case inactive
        case gemeldet(lastMeldungTime: Date?)
    }

    var informState: ModuleState = .inactive {
        didSet {
            informCTAView.lastMeldung = informState
            updateLayout()
        }
    }

    var informCallback: (() -> Void)? {
        didSet { informCTAView.informCallback = informCallback }
    }

    let informMeldungView = NSInformModuleMeldungView()
    private lazy var informCTAView = NSInformModuleCTAView(lastMeldung: informState)

    override init() {
        super.init()

        if NSContentEnvironment.current.isGenericTracer {
            headerTitle = "inform_title_homescreen_star".ub_localized
        } else {
            headerTitle = "inform_title_homescreen".ub_localized
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sectionViews() -> [UIView] {
        switch informState {
        case let .gemeldet(lastMeldungTime: .some(date)):
            informMeldungView.timestamp = date
            return [informMeldungView]
        case .gemeldet(lastMeldungTime: .none):
            informMeldungView.timestamp = nil
            return [informMeldungView]
        case .inactive:
            return [informCTAView]
        }
    }
}

private class NSInformModuleCTAView: UIView {
    private let infoLabel = NSLabel(.text)
    private let informButton = NSButton(title: "", style: .secondary)
    private let lastMeldungLabel = NSLabel(.text)

    var lastMeldung: NSInformModuleView.ModuleState {
        didSet { update() }
    }

    var informCallback: (() -> Void)?

    init(lastMeldung: NSInformModuleView.ModuleState) {
        self.lastMeldung = lastMeldung
        super.init(frame: .zero)

        setupLayout()
        update()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(NSPadding.medium)
        }

        switch (NSContentEnvironment.current.hasSymptomInputs, NSContentEnvironment.current.isGenericTracer) {
        case (true, false):
            infoLabel.text = "inform_text_homescreen".ub_localized
        case (false, false):
            infoLabel.text = "inform_text_homescreen_nosymptoms".ub_localized
        case (_, true):
            infoLabel.text = "inform_text_homescreen_star".ub_localized
        }

        informButton.touchUpCallback = {
            self.informCallback?()
        }

        stackView.addArrangedView(infoLabel)
        stackView.addSpacerView(40)
        stackView.addArrangedView(informButton)
        stackView.addSpacerView(NSPadding.large)
        stackView.addArrangedView(lastMeldungLabel)
        stackView.addSpacerView(NSPadding.medium)

        [infoLabel, lastMeldungLabel].forEach {
            $0.snp.makeConstraints { make in
                make.leading.trailing.equalTo(self).inset(NSPadding.medium)
            }
        }
    }

    private func update() {
        switch lastMeldung {
        case .inactive:
            lastMeldungLabel.isHidden = true

            informButton.style = .secondary
            informButton.setTitle("inform_button_title".ub_localized, for: .normal)

        case .gemeldet(lastMeldungTime: .none):
            lastMeldungLabel.isHidden = true

            informButton.style = .secondaryOutline
            informButton.setTitle("inform_button_title_again".ub_localized, for: .normal)

        case let .gemeldet(lastMeldungTime: .some(date)):
            lastMeldungLabel.text = "inform_last_meldung_text".ub_localized.replacingOccurrences(of: "{date}", with: NSDateFormatter.getDateTimeString(from: date))
            lastMeldungLabel.isHidden = false

            informButton.style = .secondaryOutline
            informButton.setTitle("inform_button_title_again".ub_localized, for: .normal)
        }
    }
}

class NSInformModuleMeldungView: UIView {
    private let timestampLabel = NSLabel(.text)
    private let iconImageView = UIImageView(image: #imageLiteral(resourceName: "ic-info-on"))
    private let stackView = UIStackView()
    private let gemeldetLabel = NSLabel(.text)
    private let gemeldetSpacer = UIView()
    let whatToDoButton = NSButton(title: "what_to_do_button".ub_localized, style: .secondary)

    var timestamp: Date? {
        didSet {
            if let t = timestamp {
                timestampLabel.text = "inform_meldung_time".ub_localized.replacingOccurrences(of: "{date}", with: NSDateFormatter.getDateTimeString(from: t))
            } else {
                timestampLabel.text = nil
            }
        }
    }

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)

        if NSContentEnvironment.current.isGenericTracer {
            gemeldetLabel.text = "homescreen_inform_module_gemeldet_label_star".ub_localized
        } else {
            gemeldetLabel.text = "homescreen_inform_module_gemeldet_label".ub_localized
        }

        setupLayout()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        stackView.axis = .vertical
        stackView.alignment = .leading

        addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(NSPadding.medium + NSPadding.small)
            make.leading.trailing.equalToSuperview().inset(NSPadding.medium)
        }

        addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(timestampLabel.snp.bottom).offset(NSPadding.medium + NSPadding.small)
            make.leading.equalToSuperview().inset(NSPadding.medium)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.trailing.bottom.equalToSuperview().inset(NSPadding.medium)
        }

        stackView.addArrangedView(gemeldetLabel)
        stackView.addSpacerView(NSPadding.large + NSPadding.small)
        stackView.addArrangedView(whatToDoButton)
        stackView.addSpacerView(NSPadding.large)

        whatToDoButton.snp.makeConstraints { make in
            make.width.equalTo(180)
        }
    }
}
