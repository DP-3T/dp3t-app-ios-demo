/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSAnimatedGraphLayer: CALayer {
    var tintColor: CGColor {
        switch type {
        case .header: return UIColor.white.cgColor
        case .loading: return UIColor.ns_text_secondary.cgColor
        }
    }

    var nodeRadius: CGFloat {
        switch type {
        case .header: return 5
        case .loading: return 8
        }
    }

    static var lineWidth: CGFloat = 2

    var timeInterval: TimeInterval {
        switch type {
        case .header: return 1.5
        case .loading: return 0.5
        }
    }

    static var range: CGFloat = 7

    private var nodeCenters: [CGPoint] = []
    private var edges: [(Int, Int)] = []
    private var nodeLayers: [NSAnimatedGraphNodeLayer] = []
    private var edgeLayers: [NSAnimatedGraphEdgeLayer] = []

    private var timer: Timer?

    private let type: NSAnimatedGraphView.GraphType

    init(nodeCenters: [CGPoint], edges: [(Int, Int)], type: NSAnimatedGraphView.GraphType) {
        self.type = type
        self.nodeCenters = nodeCenters
        self.edges = edges
        super.init()
        draw()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        timer?.invalidate()
        timer = nil
    }

    private func draw() {
        nodeLayers.forEach { $0.removeFromSuperlayer() }
        edgeLayers.forEach { $0.removeFromSuperlayer() }

        let scaledCenters = nodeCentersInCurrentBounds()

        // draw nodes
        nodeLayers = []
        for center in scaledCenters {
            let node = NSAnimatedGraphNodeLayer(at: center, radius: nodeRadius, color: tintColor)
            nodeLayers.append(node)
            addSublayer(node)
        }

        // draw edges
        edgeLayers = []
        for (start, end) in edges {
            let edgeLayer = NSAnimatedGraphEdgeLayer(start: scaledCenters[start], end: scaledCenters[end], color: tintColor)
            edgeLayers.append(edgeLayer)
            addSublayer(edgeLayer)
        }
    }

    private func nodeCentersInCurrentBounds() -> [CGPoint] {
        nodeCenters.map { center in
            CGPoint(
                x: bounds.width * center.x,
                y: bounds.height * center.y
            )
        }
    }

    override func layoutSublayers() {
        super.layoutSublayers()
        draw()
    }

    @objc
    func startAnimating() {
        guard timer == nil else { return }

        timer?.invalidate()

        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(step), userInfo: nil, repeats: true)

        timer?.fire()

        RunLoop.main.add(timer!, forMode: .common)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.02) {
            self.step()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(pauseAnimating), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc
    func pauseAnimating() {
        timer?.invalidate()
        timer = nil

        NotificationCenter.default.addObserver(self, selector: #selector(startAnimating), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc private func step() {
        let newPositions = zip(nodeCenters, nodeLayers).map { (arg) -> CGPoint in
            let (center, node) = arg
            let rect = node.bounds.inset(by: UIEdgeInsets(top: -Self.range, left: -NSAnimatedGraphLayer.self.range, bottom: -Self.range, right: -Self.range))

            let randomPoint = CGPoint.makeRandom(in: rect)
            return CGPoint(x: center.x + randomPoint.x, y: center.y + randomPoint.y)
        }

        for (position, node) in zip(newPositions, nodeLayers) {
            node.move(to: position, duration: timeInterval)
        }

        let newPoints = zip(nodeCentersInCurrentBounds(), newPositions).map {
            CGPoint(x: $0.x + $1.x, y: $0.y + $1.y)
        }

        for (edge, layer) in zip(edges, edgeLayers) {
            layer.move(from: newPoints[edge.0], to: newPoints[edge.1], duration: timeInterval)
        }
    }

    func stopAnimating() {
        timer?.invalidate()
        timer = nil
    }
}

private class NSAnimatedGraphNodeLayer: CAShapeLayer {
    init(at center: CGPoint, radius: CGFloat, color: CGColor) {
        super.init()
        fillColor = color
        strokeColor = UIColor.clear.cgColor

        let origin = CGPoint(x: center.x - radius, y: center.y - radius)
        let size = CGSize(width: 2 * radius, height: 2 * radius)

        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: size)).cgPath
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func move(to newPosition: CGPoint, duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = position
        animation.toValue = newPosition
        animation.duration = duration
        position = newPosition
        add(animation, forKey: nil)
    }
}

private class NSAnimatedGraphEdgeLayer: CAShapeLayer {
    init(start: CGPoint, end: CGPoint, color: CGColor) {
        super.init()

        strokeColor = color
        lineWidth = NSAnimatedGraphLayer.lineWidth
        path = makeLine(from: start, to: end)
    }

    private func makeLine(from start: CGPoint, to end: CGPoint) -> CGPath {
        let line = UIBezierPath()
        line.move(to: start)
        line.addLine(to: end)
        return line.cgPath
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func move(from start: CGPoint, to end: CGPoint, duration: TimeInterval) {
        let newPath = makeLine(from: start, to: end)

        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = newPath
        animation.duration = duration
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        add(animation, forKey: nil)
    }
}

private extension CGPoint {
    static func makeRandom(in rect: CGRect) -> CGPoint {
        CGPoint(
            x: Int(arc4random() % UInt32(rect.width)) - Int(rect.width / 2),
            y: Int(arc4random() % UInt32(rect.height)) - Int(rect.height / 2)
        )
    }
}
