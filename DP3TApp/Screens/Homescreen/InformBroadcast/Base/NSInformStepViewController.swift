/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInformStepViewController: NSViewController {
    override init() {
        super.init()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "cancel".ub_localized, style: .done, target: self, action: #selector(cancelStep))
    }

    @objc func cancelStep(_: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
