//
//  TopViewController.swift
//  OctCats
//
//  Created by arabian9ts on 2019/09/12.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import UIKit
import SnapKit

class TopViewController: UIViewController {
    
    private var pageViewController: TrendPageViewController = {
        let pageVC = TrendPageViewController(transitionStyle: .scroll,
                                             navigationOrientation: .horizontal,
                                             options: nil)
        return pageVC
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPageView()
    }
    
    private func setupPageView() {
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view)
            make.bottom.equalTo(view.snp.bottom)
            make.right.equalTo(view)
        }
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
}
