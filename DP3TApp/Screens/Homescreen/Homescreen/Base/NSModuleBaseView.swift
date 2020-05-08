/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSModuleBaseView: UIControl {
    var touchUpCallback: (() -> Void)?

    var headerTitle: String? {
        get {
            headerView.title
        }
        set {
            headerView.title = newValue
            stackView.accessibilityLabel = newValue
        }
    }

    let headerView = NSModuleHeaderView()
    internal let stackView = NSClickthroughStackView()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .ns_background

        setupLayout()
        setupAccessibility()
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
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: NSPadding.medium, bottom: NSPadding.medium, right: NSPadding.medium)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        ub_addShadow(radius: 4, opacity: 0.1, xOffset: 0, yOffset: -1)
    }

    func updateLayout() {
        stackView.clearSubviews()

        stackView.addArrangedView(headerView)

        let sections = sectionViews()

        sections.forEach { stackView.addArrangedView($0) }

        updateAccessibility(with: sections)
    }

    func setCustomSpacing(_ spacing: CGFloat, after view: UIView) {
        stackView.setCustomSpacing(spacing, after: view)
    }

    func sectionViews() -> [UIView] {
        []
    }

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .ns_background_highlighted : .ns_background
        }
    }
}

// MARK: - Accessibility

extension NSModuleBaseView {
    func setupAccessibility() {
        isAccessibilityElement = false
        accessibilityElementsHidden = false
        stackView.isAccessibilityElement = true
        stackView.accessibilityTraits = [.button]
    }

    func updateAccessibility(with sectionViews: [UIView]) {
        accessibilityElements = [stackView] + sectionViews
        UIAccessibility.post(notification: .screenChanged, argument: nil)
    }
}
