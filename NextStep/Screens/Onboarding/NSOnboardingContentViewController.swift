/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSOnboardingContentViewController: NSViewController {
    internal let stackScrollView = NSStackScrollView(alignment: .center)

    private let defaultAnimationOffset: CGFloat = 150
    private let imageAnimationOffset: CGFloat = 400

    // on iPhone
    public let useLessSpacing = UIScreen.main.bounds.width < 375
    public let useSmallerImages = UIScreen.main.bounds.height < 750

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        setupStackScrollView()
    }

    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        stackScrollView.scrollView.contentInset = UIEdgeInsets(top: NSPadding.large + view.layoutMargins.top, left: 0, bottom: 0, right: 0)
    }

    private func setupStackScrollView() {
        stackScrollView.scrollView.alwaysBounceVertical = false

        view.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        stackScrollView.stackView.snp.remakeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().inset((self.useLessSpacing ? 1.0 : 2.0) * NSPadding.large)
        }
    }

    internal func addArrangedView(_ view: UIView, spacing: CGFloat? = nil, index: Int? = nil) {
        let wrapperView = UIView()
        wrapperView.addSubview(view)
        view.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(.high)
        }

        view.alpha = 0

        if let idx = index {
            stackScrollView.addArrangedView(wrapperView, index: idx)
        } else {
            stackScrollView.addArrangedView(wrapperView)
        }
        if let s = spacing {
            stackScrollView.stackView.setCustomSpacing(s, after: wrapperView)
        }
    }

    func fadeAnimation(fromFactor: CGFloat, toFactor: CGFloat, delay: TimeInterval, completion: ((Bool) -> Void)?) {
        for (idx, wrapperView) in stackScrollView.stackView.arrangedSubviews.enumerated() {
            if wrapperView.subviews.count == 0 {
                print("Error: stack contains subview that were not added with addArrangedView(:,height:)")
                continue
            }

            let v = wrapperView.subviews[0]

            setViewState(view: v, factor: fromFactor)
            UIView.animate(withDuration: 0.5, delay: delay + Double(idx) * 0.05, options: [.beginFromCurrentState], animations: {
                self.setViewState(view: v, factor: toFactor)
            }, completion: (idx == stackScrollView.stackView.arrangedSubviews.count - 1) ? completion : nil)
        }

        if stackScrollView.stackView.arrangedSubviews.count == 0 {
            completion?(true)
        }
    }

    private func setViewState(view: UIView, factor: CGFloat) {
        if view is UIImageView || view is UIButton {
            view.transform = CGAffineTransform(translationX: imageAnimationOffset * factor, y: 0)
            view.alpha = 1
        } else {
            view.transform = CGAffineTransform(translationX: defaultAnimationOffset * factor, y: 0)
            view.alpha = (1.0 - abs(factor))
        }
    }
}
