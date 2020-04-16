/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSInfoViewController: NSWebViewController {
    // MARK: - Init

    init() {
        super.init(site: "info")

        title = "tab_prinzip_title".ub_localized
        tabBarItem.image = UIImage(named: "ic-prinzip")
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
