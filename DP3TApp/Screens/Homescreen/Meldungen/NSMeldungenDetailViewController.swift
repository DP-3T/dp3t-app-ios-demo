/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSMeldungenDetailViewController: NSViewController {
    private let noMeldungenViewController = NSMeldungenDetailNoMeldungenViewController()

    private let positiveTestedViewController = NSMeldungenDetailPositiveTestedViewController()

    private let meldungenViewController = NSMeldungDetailMeldungenViewController()

    // MARK: - Init

    override init() {
        super.init()
        title = "reports_title_homescreen".ub_localized
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ns_backgroundSecondary

        UIStateManager.shared.addObserver(self) { [weak self] state in
            guard let strongSelf = self else { return }
            strongSelf.setup(state.meldungenDetail)
        }

        setupViewControllers()
    }

    // MARK: - Setup

    private func setupViewControllers() {
        // No Meldungen
        addChild(noMeldungenViewController)
        view.addSubview(noMeldungenViewController.view)
        noMeldungenViewController.didMove(toParent: self)

        noMeldungenViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Positive Tested
        addChild(positiveTestedViewController)
        view.addSubview(positiveTestedViewController.view)
        positiveTestedViewController.didMove(toParent: self)
        positiveTestedViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Meldungen View Controller
        addChild(meldungenViewController)
        view.addSubview(meldungenViewController.view)
        meldungenViewController.didMove(toParent: self)

        meldungenViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setup(_ state: UIStateModel.MeldungenDetail) {
        meldungenViewController.showMeldungWithAnimation = state.showMeldungWithAnimation

        noMeldungenViewController.view.isHidden = true
        positiveTestedViewController.view.isHidden = true
        meldungenViewController.view.isHidden = true

        switch state.meldung {
        case .exposed:
            meldungenViewController.view.isHidden = false
            meldungenViewController.meldungen = state.meldungen
            meldungenViewController.phoneCallState = state.phoneCallState
        case .infected:
            positiveTestedViewController.view.isHidden = false
        case .noMeldung:
            noMeldungenViewController.view.isHidden = false
        }
    }
}
