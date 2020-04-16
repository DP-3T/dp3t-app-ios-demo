/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSModuleBaseView: UIControl {
    var touchUpCallback: (() -> Void)?

    var headerIcon: UIImage? {
        get {
            headerView.icon
        }
        set {
            headerView.icon = newValue
        }
    }

    var headerTitle: String? {
        get {
            headerView.title
        }
        set {
            headerView.title = newValue
        }
    }

    var bottomPadding: CGFloat = NSPadding.large {
        didSet { updateLayout() }
    }

    private let headerView = NSModuleHeaderView()
    internal let stackView = UIStackView()

    init() {
        super.init(frame: .zero)

        backgroundColor = .ns_background

        setupLayout()
        updateLayout()

        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTap() {
        touchUpCallback?()
    }

    private func setupLayout() {
        stackView.axis = .vertical
        stackView.isUserInteractionEnabled = false

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        ub_addShadow(radius: 4, opacity: 0.1, xOffset: 0, yOffset: -1)
    }

    func updateLayout() {
        stackView.clearSubviews()

        stackView.addArrangedView(headerView)

        sectionViews().forEach { stackView.addArrangedView($0) }

        stackView.addSpacerView(bottomPadding)
    }

    func setCustomSpacing(_ spacing: CGFloat, after view: UIView) {
        stackView.setCustomSpacing(spacing, after: view)
    }

    func sectionViews() -> [UIView] {
        return []
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .ns_background_highlighted : .ns_background
        }
    }
}
