/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInformViewController: NSInformStepViewController {
    static func present(from rootViewController: UIViewController) {
        let informVC: UIViewController

        informVC = NSSendViewController()

        let navCon = NSNavigationController(rootViewController: informVC)
        rootViewController.present(navCon, animated: true, completion: nil)
    }
}
