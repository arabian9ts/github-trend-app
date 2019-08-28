//
//  ViewController.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/28.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import Moya
import RxSwift
import UIKit

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GitHubTrendAPI.shared.request(GitHubTrendRequest.GetTrend(lang: "Swift"))
        .subscribe(onSuccess: { (trends) in
            dump(trends)
        }, onError: { (err) in
            print("error: \(err)")
        })
        .disposed(by: disposeBag)
    }


}

