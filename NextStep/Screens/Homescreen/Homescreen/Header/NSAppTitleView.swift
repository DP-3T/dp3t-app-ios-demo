/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSAppTitleView: UIView {
    // MARK: - Init

    var uiState: NSUIStateModel.Homescreen.Header = .normal {
        didSet {
            if uiState != oldValue {
                updateState(animated: true)
            }
        }
    }

    let highlightView = UIView()

    // Safe-area aware container
    let contentView = UIView()

    // Content
    let circle = UIImageView(image: UIImage(named: "header-circle"))

    let iconContainer = UIView()
    let checkmark = NSCheckBoxControl(isChecked: true, noBorder: true)
    let info = UIImageView(image: UIImage(named: "header-info"))
    let warning = UIImageView(image: UIImage(named: "header-warning"))

    init() {
        super.init(frame: .zero)
        setup()
        animate()
        startSpawn()
        updateState(animated: false)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(highlightView)
        highlightView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(NSPadding.large)
        }

        contentView.addSubview(circle)
        circle.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        contentView.addSubview(iconContainer)
        iconContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        iconContainer.backgroundColor = .clear

        checkmark.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        iconContainer.addSubview(checkmark)
        checkmark.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        iconContainer.addSubview(info)
        info.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        iconContainer.addSubview(warning)
        warning.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func animate() {
        let initialDelay = 1.0

        circle.alpha = 0
        circle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        iconContainer.alpha = 0
        iconContainer.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        UIView.animate(withDuration: 0.3, delay: 0.0 + initialDelay, options: [], animations: {
            self.circle.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.0 + initialDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.circle.transform = .identity
        }, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0.3 + initialDelay, options: [], animations: {
            self.iconContainer.alpha = 1
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.3 + initialDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.iconContainer.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    }

    private var timer: Timer?
    private var slowTimer: Timer?
    private func startSpawn() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(spawnArcs), userInfo: nil, repeats: true)
        slowTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hightlight), userInfo: nil, repeats: true)
    }

    private var isOverscrolled = false

    @objc
    private func hightlight() {
        if uiState == .error {
            return // no highlight in error state
        }

        UIView.animate(withDuration: 2.5, animations: {
            self.highlightView.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        }) { _ in
            UIView.animate(withDuration: 2.5) {
                self.highlightView.backgroundColor = .clear
            }
        }
    }

    @objc
    private func spawnArcs(force: Bool = false) {
        if uiState == .error {
            return // no arcs in error state
        }

        guard Float.random(in: 0 ... 1) > 0.3 || force else {
            return // drop random events
        }

        let left = NSHeaderArcView(angle: .left)
        let right = NSHeaderArcView(angle: .right)

        [left, right].forEach {
            arc in
            arc.alpha = 0
            arc.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            contentView.addSubview(arc)

            arc.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }

            UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
                arc.alpha = 1
            }) { _ in
                UIView.animate(withDuration: 1.5, delay: 0.4, options: [.beginFromCurrentState], animations: {
                    arc.alpha = 0
                }, completion: nil)
            }

            UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveLinear], animations: {
                arc.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }) { _ in
                arc.removeFromSuperview()
            }
        }
    }

    private func updateState(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState], animations: {
                self.updateState(animated: false)
            }, completion: nil)
            return
        }

        switch uiState {
        case .normal:
            backgroundColor = .ns_secondary
            checkmark.isHidden = false
            info.isHidden = true
            warning.isHidden = true
        case .error:
            backgroundColor = .ns_error
            checkmark.isHidden = true
            info.isHidden = true
            warning.isHidden = false
        case .warning:
            backgroundColor = .ns_primary
            checkmark.isHidden = true
            info.isHidden = false
            warning.isHidden = true
        }
    }
}

extension NSAppTitleView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top
        let overscrolled = offset < -10
        if overscrolled != isOverscrolled {
            isOverscrolled = overscrolled

            if overscrolled {
                for delay in stride(from: 0, to: 1.0, by: 0.5) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        self.spawnArcs(force: true)
                    }
                }
            }
        }

        let inNegativeFactor = max(0, min(1, -offset / 10.0))
        let inPositiveFactor = max(0, min(1, offset / 70.0))

        let s = 1.0 + inNegativeFactor * 0.5
        iconContainer.transform = CGAffineTransform(scaleX: s, y: s)

        let a = 1.0 - inPositiveFactor
        let t1 = inPositiveFactor * 25.0
        let t2 = inPositiveFactor * -50.0
        contentView.alpha = a
        contentView.transform = CGAffineTransform(translationX: 0, y: t1)
        transform = CGAffineTransform(translationX: 0, y: t2)
    }
}
