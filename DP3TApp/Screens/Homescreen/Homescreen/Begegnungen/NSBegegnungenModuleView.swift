/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import SnapKit
import UIKit

class NSBegegnungenModuleView: NSModuleBaseView {
    var uiState: UIStateModel.TracingState = .tracingActive {
        didSet { updateUI() }
    }

    private let tracingActiveView = NSInfoBoxView(title: "tracing_active_title".ub_localized, subText: "tracing_active_text".ub_localized, image: UIImage(named: "ic-check")!, illustration: UIImage(named: "illu-tracking-active")!, titleColor: .ns_blue, subtextColor: .ns_text, backgroundColor: .ns_blueBackground)

    private let tracingEndedView = NSInfoBoxView(title: "tracing_ended_title".ub_localized, subText: "tracing_ended_text".ub_localized, image: UIImage(named: "ic-stopp")!, illustration: UIImage(named: "illu-tracing-ended")!, titleColor: .ns_purple, subtextColor: .ns_text, backgroundColor: .ns_purpleBackground)

    private var tracingErrorView: NSTracingErrorView? {
        NSTracingErrorView.tracingErrorView(for: uiState)
    }

    override init() {
        super.init()

        headerTitle = "handshakes_title_homescreen".ub_localized

        updateUI()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sectionViews() -> [UIView] {
        if uiState == .tracingEnded {
            return [tracingEndedView]
        }

        if let errorView = tracingErrorView {
            return [errorView]
        } else {
            return [tracingActiveView]
        }
    }

    private func updateUI() {
        stackView.setNeedsLayout()
        updateLayout()
        headerView.showCaret = uiState != .tracingEnded
        isEnabled = uiState != .tracingEnded
        stackView.layoutIfNeeded()
    }
}
