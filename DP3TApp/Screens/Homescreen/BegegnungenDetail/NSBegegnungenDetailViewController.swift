/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSBegegnungenDetailViewController: NSTitleViewScrollViewController {
    private let bluetoothControl: NSBluetoothSettingsControl

    private let appTitleView: NSAppTitleView

    // MARK: - Init

    init(initialState: UIStateModel.BegegnungenDetail) {
        bluetoothControl = NSBluetoothSettingsControl(initialState: initialState)
        appTitleView = NSAppTitleView(initialState: initialState.tracing)

        super.init()

        title = "handshakes_title_homescreen".ub_localized
        titleView = appTitleView

        UIStateManager.shared.addObserver(self, block: { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.updateState(state)
        })
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ns_backgroundSecondary
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

        bluetoothControl.viewToBeLayouted = view

        stackScrollView.addArrangedView(bluetoothControl)

        stackScrollView.addSpacerView(3 * NSPadding.large)

        stackScrollView.addArrangedView(NSOnboardingInfoView(icon: UIImage(named: "ic-tracing")!, text: "begegnung_detail_faq1_text".ub_localized, title: "begegnung_detail_faq1_title".ub_localized, leftRightInset: 0))

        stackScrollView.addSpacerView(2.0 * NSPadding.medium)

        stackScrollView.addArrangedView(NSOnboardingInfoView(icon: UIImage(named: "ic-verschluesselt")!, text: "begegnung_detail_faq2_text".ub_localized, title: "begegnung_detail_faq2_title".ub_localized, leftRightInset: 0))

        stackScrollView.addSpacerView(2.0 * NSPadding.medium)

        stackScrollView.addArrangedView(NSOnboardingInfoView(icon: UIImage(named: "ic-bt")!, text: "begegnungen_detail_faq3_text".ub_localized, title: "begegnungen_detail_faq3_title".ub_localized, leftRightInset: 0))

        stackScrollView.addSpacerView(3 * NSPadding.large)

        stackScrollView.addSpacerView(NSPadding.large)
    }

    private func updateState(_ state: UIStateModel) {
        appTitleView.uiState = state.homescreen.header
    }
}
