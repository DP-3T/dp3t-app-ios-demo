/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

class NSSplashViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ns_background

        let title = NSLabel(.title, textAlignment: .center)
        title.text = "app_name".ub_localized

        let subtitle = NSLabel(.textLight, textAlignment: .center)
        subtitle.text = "app_subtitle".ub_localized

        let imgView = UIImageView(image: UIImage())

        view.addSubview(title)
        view.addSubview(subtitle)
        view.addSubview(imgView)

        imgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(NSPadding.large).priority(.low)
            make.bottom.lessThanOrEqualTo(self.view.snp.bottom).inset(NSPadding.large)
        }

        imgView.ub_setContentPriorityRequired()

        title.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(NSPadding.large)
            make.centerY.equalToSuperview().offset(2 * NSPadding.large)
        }

        subtitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(NSPadding.large)
            make.top.equalTo(title.snp.bottom).offset(NSPadding.medium)
        }
    }
}
