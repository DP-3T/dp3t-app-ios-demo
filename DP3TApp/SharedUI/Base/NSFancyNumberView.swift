/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSFancyNumberView: UIView {
    private var number: Int = 0

    private var views: [NSAllNumbersView] = []
    private let stackView = UIStackView()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -

    func setNumber(number: Int, animated: Bool) {
        let numberOfDigits = "\(number)".count

        let newViews = numberOfDigits - views.count

        if newViews > 0 {
            for _ in 0 ..< newViews {
                let v = NSAllNumbersView()
                stackView.insertArrangedSubview(v, at: 0)
                views.insert(v, at: 0)
            }
        } else if newViews < 0 {
            for _ in 0 ..< -newViews {
                let v = views.popLast()!
                stackView.removeArrangedSubview(v)
                v.removeFromSuperview()
            }
        }

        let digits = "\(number)".compactMap { Int("\($0)") }

        var index = 0
        for v in views {
            v.setNumber(number: digits[index], animated: animated)
            index = index + 1
        }

        if animated {
            UIView.animate(withDuration: 0.25) {
                self.superview?.layoutIfNeeded()
            }
        }
    }

    func setup() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

class NSAllNumbersView: UIView {
    private let stackScrollView = NSStackScrollView(axis: .vertical, spacing: 0)

    private var currentNumber: Int = 0

    init() {
        super.init(frame: .zero)

        setup()
        setNumber(number: currentNumber, animated: false)

        isUserInteractionEnabled = false
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setNumber(number: Int, animated: Bool) {
        currentNumber = number
        let size: CGFloat = CGFloat(stackScrollView.scrollView.contentSize.height / 10.0)
        stackScrollView.scrollView.setContentOffset(CGPoint(x: CGFloat(0.0), y: CGFloat(number) * size), animated: animated)
    }

    // MARK: - Setup

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setup() {
        addSubview(stackScrollView)
        stackScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        var size: CGSize = .zero

        for i in 0 ... 9 {
            let label = NSLabel(.title, textColor: .ns_green, textAlignment: .center)
            label.text = "\(i)"
            stackScrollView.addArrangedView(label)

            size = label.intrinsicContentSize
        }

        layoutIfNeeded()

        snp.makeConstraints { make in
            make.height.equalTo(size.height)
            make.width.equalTo(size.width)
        }
    }
}
