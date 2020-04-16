/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSMeldungView: NSModuleBaseView {
    var uiState: NSUIStateModel.Homescreen.Meldungen
        = .init(meldung: .noMeldung, pushProblem: false) {
        didSet { updateLayout() }
    }

    // section views
    private let noMeldungenView = NSBluetoothSettingsDetailView(title: "meldungen_no_meldungen_title".ub_localized, subText: "meldungen_no_meldungen_text".ub_localized, image: UIImage(named: "ic-check")!, titleColor: .ns_secondary, subtextColor: .ns_text, backgroundColor: UIColor(ub_hexString: "#d3f2ee")!)

    private let meldungenView = NSBluetoothSettingsDetailView(title: "meldungen_meldung_title".ub_localized, subText: "meldungen_meldung_text".ub_localized, image: UIImage(named: "ic-info")!, titleColor: .white, subtextColor: .white, backgroundColor: .ns_primary, additionalText: "meldungen_meldung_more_button".ub_localized)

    private let infectedView = NSBluetoothSettingsDetailView(title: "meldungen_infected_title".ub_localized, subText: "meldungen_infected_text".ub_localized, image: UIImage(named: "ic-info")!, titleColor: .white, subtextColor: .white, backgroundColor: .ns_primary, additionalText: "meldungen_meldung_more_button".ub_localized)

    private let noPushView = NSBluetoothSettingsDetailView(title: "push_deactivated_title".ub_localized, subText: "push_deactivated_text".ub_localized, image: UIImage(named: "ic-cross")!, titleColor: .ns_error, subtextColor: .ns_error)

    override init() {
        super.init()

        headerIcon = UIImage(named: "ic-meldungen")!
        headerTitle = "reports_title_homescreen".ub_localized

        updateLayout()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sectionViews() -> [UIView] {
        var views = [UIView]()

        switch uiState.meldung {
        case .noMeldung:
            views.append(noMeldungenView)
            if uiState.pushProblem {
                views.append(noPushView)
            }
        case .exposed:
            views.append(meldungenView)
        case .infected:
            views.append(infectedView)
        }

        return views
    }

    override func updateLayout() {
        super.updateLayout()

        setCustomSpacing(NSPadding.medium, after: noMeldungenView)
        setCustomSpacing(NSPadding.medium, after: meldungenView)
        setCustomSpacing(NSPadding.medium, after: infectedView)
    }
}
