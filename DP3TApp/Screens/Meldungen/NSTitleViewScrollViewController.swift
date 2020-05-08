/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSTitleView: UIView {
    public weak var viewController: NSTitleViewScrollViewController?

    public func updateConstraintsForAnimation() {}

    public func startInitialAnimation() {}

    @objc public func scrollViewDidScroll(_: UIScrollView) {}
}

class NSTitleViewScrollViewController: NSViewController {
    // MARK: - Views

    public let stackScrollView = NSStackScrollView()

    public var titleView: NSTitleView? {
        didSet { titleView?.viewController = self }
    }

    private let spacerView = UIView()

    public var titleHeight: CGFloat {
        return 210
    }

    public var startPositionScrollView: CGFloat {
        return 180
    }

    public var useFullScreenHeaderAnimation: Bool {
        return false
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupLogic()
    }

    // MARK: - Logic

    private func setupLogic() {
        stackScrollView.scrollView.delegate = self
    }

    // MARK: - API

    public func startHeaderAnimation() {
        guard let tv = titleView else { return }

        updateClosedConstraints()
        tv.updateConstraintsForAnimation()

        UIView.animate(withDuration: 0.55, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
            tv.startInitialAnimation()
        }, completion: nil)
    }

    // MARK: - Setup

    private func setupLayout() {
        guard let tv = titleView else { return }

        view.addSubview(tv)

        tv.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()

            if !useFullScreenHeaderAnimation {
                make.height.equalTo(self.titleHeight)
            } else {
                make.height.equalToSuperview()
            }
        }

        stackScrollView.stackView.isLayoutMarginsRelativeArrangement = true
        stackScrollView.stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        view.addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackScrollView.addArrangedView(spacerView)

        spacerView.snp.makeConstraints { make in
            make.height.equalTo(self.view)
        }

        if !useFullScreenHeaderAnimation {
            updateClosedConstraints()
            tv.updateConstraintsForAnimation()
            tv.startInitialAnimation()
        }
    }

    private func updateClosedConstraints() {
        guard let tv = titleView else { return }

        tv.snp.remakeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(self.titleHeight)
        }

        spacerView.snp.remakeConstraints { make in
            make.height.equalTo(self.startPositionScrollView)
        }
    }
}

extension NSTitleViewScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sp = startPositionScrollView

        let v = (sp - scrollView.contentOffset.y) / sp
        let p = max(0.0, min(1.0, v))

        titleView?.transform = CGAffineTransform(translationX: 0, y: min(0.0, -0.4 * scrollView.contentOffset.y))

        titleView?.alpha = pow(p, 0.8)

        titleView?.scrollViewDidScroll(scrollView)
    }
}
