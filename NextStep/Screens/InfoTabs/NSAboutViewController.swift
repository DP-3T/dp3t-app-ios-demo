/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSAboutViewController: NSWebViewController {
    // MARK: - Init

    init() {
        super.init(site: "about")

        title = "tab_theapp_title".ub_localized
        tabBarItem.image = UIImage(named: "ic-app")
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
