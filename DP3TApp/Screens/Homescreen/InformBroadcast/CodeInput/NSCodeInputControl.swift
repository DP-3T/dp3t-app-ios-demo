/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import Foundation
import UIKit

protocol NSCodeControlProtocol {
    func changeSendPermission(to sendAllowed: Bool)
}

class NSCodeControl: UIView {
    public var controller: NSCodeControlProtocol?

    // MARK: - Input number

    private let numberOfInputs = 12
    private var controls: [NSCodeSingleControl] = []
    private var currentControl: NSCodeSingleControl?

    private let stackView = UIStackView()

    private var currentIndex = 0

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public functions

    public func code() -> String {
        var code = ""

        for control in controls {
            if let c = control.code() {
                code.append(contentsOf: c)
            }
        }

        return code
    }

    public func clearAndRestart() {
        for control in controls {
            control.clearInput()
        }

        currentControl = nil
        if !UIAccessibility.isVoiceOverRunning {
            jumpToNextField()
        }
    }

    // MARK: - Setup

    private func setup() {
        var elements = [Any]()
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        stackView.distribution = .fillEqually
        stackView.spacing = 1.0

        for i in 0 ..< numberOfInputs {
            let singleControl = NSCodeSingleControl(index: i)
            singleControl.parent = self

            controls.append(singleControl)
            stackView.addArrangedView(singleControl)
            elements.append(singleControl)
            if (i + 1) % 3 == 0, i + 1 != numberOfInputs {
                stackView.setCustomSpacing(NSPadding.small + 2.0, after: singleControl)
            }
        }

        accessibilityElements = elements
    }

    // MARK: - Control

    public func jumpToNextField() {
        if let c = currentControl, let i = controls.firstIndex(of: c) {
            if i + 1 < numberOfInputs {
                _ = controls[i + 1].becomeFirstResponder()
                currentControl = controls[i + 1]
            }
        } else {
            _ = controls[0].becomeFirstResponder()
            currentControl = controls[0]
        }

        checkSendAllowed()
    }

    public func jumpToPreviousField() {
        if let c = currentControl, let i = controls.firstIndex(of: c) {
            if i > 0 {
                _ = controls[i - 1].becomeFirstResponder()
                controls[i - 1].reset()
                currentControl = controls[i - 1]
            }
        } else {
            _ = controls[0].becomeFirstResponder()
            currentControl = controls[0]
        }

        checkSendAllowed()
    }

    public func changeControl(control: NSCodeSingleControl) {
        currentControl = control
    }

    override func resignFirstResponder() -> Bool {
        currentControl?.resignFirstResponder() ?? false
    }

    // MARK: - Protocol

    public func checkSendAllowed() {
        for c in controls {
            if !c.codeIsSet() {
                controller?.changeSendPermission(to: false)
                return
            }
        }

        controller?.changeSendPermission(to: true)
    }

    // MARK: - Copy & paste

    public func fill(text: String, startControl: NSCodeSingleControl) {
        var started = false

        var onlyDigits = text.filter { Int("\($0)") != nil }

        for c in controls {
            if c == startControl {
                started = true
            }

            if let first = onlyDigits.first, started {
                c.setDigit(digit: String(first))
                onlyDigits.removeFirst()
                _ = c.becomeFirstResponder()
            }
        }

        jumpToNextField()

        checkSendAllowed()
    }
}

class NSCodeSingleControl: UIView, UITextFieldDelegate {
    public weak var parent: NSCodeControl?

    private let textField = NSTextField()
    private let emptyCharacter = "\u{200B}"

    private var hadText: Bool = false

    init(index: Int) {
        super.init(frame: .zero)
        setup()
        textField.text = emptyCharacter
        textField.accessibilityTraits = .none
        isAccessibilityElement = true
        textField.accessibilityLabel = "accessibility_\(index + 1)nd".ub_localized
    }

    override func accessibilityElementDidBecomeFocused() {
        textField.becomeFirstResponder()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Checks/Code

    public func codeIsSet() -> Bool {
        (textField.text ?? "").replacingOccurrences(of: emptyCharacter, with: "").count > 0
    }

    public func code() -> String? {
        textField.text?.replacingOccurrences(of: emptyCharacter, with: "")
    }

    public func clearInput() {
        textField.resignFirstResponder()
        textField.text = emptyCharacter
    }

    // MARK: - Copy&paste

    public func fill(text: String) {
        parent?.fill(text: text, startControl: self)
    }

    public func setDigit(digit: String) {
        textField.text = digit
    }

    // MARK: - First responder

    override func becomeFirstResponder() -> Bool {
        changeBorderStyle(isSelected: true)
        return textField.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        changeBorderStyle(isSelected: false)
        return textField.resignFirstResponder()
    }

    func reset() {
        textField.text = emptyCharacter
        hadText = false
    }

    private func changeBorderStyle(isSelected: Bool) {
        backgroundColor = UIColor.ns_backgroundSecondary

        if isSelected {
            layer.borderWidth = 2.0
            layer.borderColor = UIColor.ns_purple.cgColor
        } else {
            layer.borderWidth = 1.0
            layer.borderColor = UIColor(ub_hexString: "#e5e5e5")?.cgColor
        }
    }

    // MARK: - Setup

    private func setup() {
        snp.makeConstraints { make in
            make.height.equalTo(36)
        }

        addSubview(textField)

        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: -2, bottom: 0, right: -2))
        }

        changeBorderStyle(isSelected: false)

        textField.font = NSLabelType.title.font
        textField.textAlignment = .center
        textField.textColor = .ns_text
        textField.keyboardType = .numberPad

        textField.addTarget(self, action: #selector(editingChanged(sender:)), for: .editingChanged)
        textField.delegate = self
        textField.singleControl = self
    }

    // MARK: - Textfield Delegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }

    @objc private func editingChanged(sender: UITextField) {
        if let text = sender.text, text.count >= 1 {
            sender.text = String(text.dropFirst(text.count - 1))
            hadText = true
            parent?.jumpToNextField()
        } else if let text = sender.text, text.count == 0 {
            sender.text = emptyCharacter
            if !hadText {
                parent?.jumpToPreviousField()
            } else {
                parent?.checkSendAllowed()
            }

            hadText = false
        }
    }

    func textFieldDidBeginEditing(_: UITextField) {
        parent?.changeControl(control: self)
        changeBorderStyle(isSelected: true)
    }

    func textFieldDidEndEditing(_: UITextField) {
        changeBorderStyle(isSelected: false)
    }
}

class NSTextField: UITextField {
    public weak var singleControl: NSCodeSingleControl?

    override func paste(_: Any?) {
        let pasteboard = UIPasteboard.general

        if let text = pasteboard.string {
            singleControl?.fill(text: text)
        }
    }

    override func canPerformAction(_ action: Selector, withSender _: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.paste)
    }
}
