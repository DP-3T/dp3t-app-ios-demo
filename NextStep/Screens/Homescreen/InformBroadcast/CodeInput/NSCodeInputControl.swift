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

    private let numberOfInputs = 6
    private var controls: [NSCodeSingleControl] = []
    private var currentControl: NSCodeSingleControl?

    private let stackView = UIStackView()

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()

        jumpToNextField()
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

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.top.bottom.centerX.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.left.greaterThanOrEqualToSuperview()
        }

        stackView.spacing = NSPadding.medium

        for i in 0 ..< numberOfInputs {
            let singleControl = NSCodeSingleControl()
            singleControl.parent = self

            controls.append(singleControl)

            stackView.addArrangedView(singleControl)

            if i == (numberOfInputs / 2 - 1) {
                let label = NSLabel(.title)
                label.text = "–"
                stackView.addArrangedView(label)
                label.ub_setContentPriorityRequired()
            }
        }
    }

    // MARK: - Control

    public func jumpToNextField() {
        if let c = currentControl, let i = controls.firstIndex(of: c) {
            if i + 1 < numberOfInputs {
                _ = c.resignFirstResponder()
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
                _ = c.resignFirstResponder()
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
        return currentControl?.resignFirstResponder() ?? false
    }

    // MARK: - Protocol

    private func checkSendAllowed() {
        for c in controls {
            if !c.codeIsSet() {
                controller?.changeSendPermission(to: false)
                return
            }
        }

        controller?.changeSendPermission(to: true)
    }
}

class NSCodeSingleControl: UIView, UITextFieldDelegate {
    public weak var parent: NSCodeControl?

    private let textView = UITextField()
    private let emptyCharacter = "\u{200B}"

    init() {
        super.init(frame: .zero)
        setup()
        textView.text = emptyCharacter
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Checks/Code

    public func codeIsSet() -> Bool {
        return (textView.text ?? "").replacingOccurrences(of: emptyCharacter, with: "").count > 0
    }

    public func code() -> String? {
        return textView.text?.replacingOccurrences(of: emptyCharacter, with: "")
    }

    // MARK: - First responder

    override func becomeFirstResponder() -> Bool {
        changeBorderStyle(isSelected: true)
        return textView.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        changeBorderStyle(isSelected: false)
        return textView.resignFirstResponder()
    }

    func reset() {
        textView.text = emptyCharacter
    }

    private func changeBorderStyle(isSelected: Bool) {
        backgroundColor = UIColor.ns_background_secondary

        if isSelected {
            layer.borderWidth = 2.0
            layer.borderColor = UIColor.ns_secondary.cgColor
        } else {
            layer.borderWidth = 1.0
            layer.borderColor = UIColor(ub_hexString: "#e5e5e5")?.cgColor
        }
    }

    // MARK: - Setup

    private func setup() {
        snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(44)
        }

        addSubview(textView)

        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        changeBorderStyle(isSelected: false)

        textView.font = NSLabelType.title.font
        textView.textAlignment = .center
        textView.textColor = .ns_text
        textView.autocapitalizationType = .allCharacters

        textView.addTarget(self, action: #selector(editingChanged(sender:)), for: .editingChanged)
        textView.delegate = self
    }

    // MARK: - Textfield Delegate

    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        return string != " "
    }

    @objc private func editingChanged(sender: UITextField) {
        if let text = sender.text, text.count >= 1 {
            sender.text = String(text.dropFirst(text.count - 1))
            parent?.jumpToNextField()
        } else if let text = sender.text, text.count == 0 {
            sender.text = emptyCharacter
            parent?.jumpToPreviousField()
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
