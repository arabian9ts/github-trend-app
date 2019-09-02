//
//  TrendStore.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/31.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import RxSwift
import RxCocoa

class TrendStore: Store {
    var trendRepositories = BehaviorRelay<[GitHubRepository]>(value: [GitHubRepository(), GitHubRepository(), GitHubRepository(), GitHubRepository(), GitHubRepository()])
    private let disposeBag = DisposeBag()
    
    required init(with dispatcher: Dispatcher = .shared) {
        dispatcher.register(actionHandler: { [unowned self] (action: TrendAction) in
            switch action {
            case let .getTrends(lang):
                GitHubTrendAPI.shared.request(GitHubTrendRequest.GetTrend(lang: lang))
                    .subscribe(onSuccess: { (trends) in
                        dump(trends)
                        self.trendRepositories.accept(trends)
                    }, onError: { (err) in
                        print("error: \(err)")
                    })
                    .disposed(by: self.disposeBag)
            }})
            .disposed(by: disposeBag)
    }
}
