/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSVerhaltenViewController: NSWebViewController {
    init() {
        super.init(site: "behaviour")

        title = "tab_verhalten_title".ub_localized
        tabBarItem.image = UIImage(named: "ic-verhalten")
    }
}
