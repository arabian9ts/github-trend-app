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
    static let shared = TrendStore()
    var trendRepositories = PublishRelay<[GitHubRepository]>()
    private var repositoryMap = [String: [GitHubRepository]]()
    private let disposeBag = DisposeBag()

    internal required init(with dispatcher: Dispatcher = .shared) {
        dispatcher.register(actionHandler: { [unowned self] (action: TrendAction) in
            switch action {
            case let .getTrends(lang):
                if 0 < (self.repositoryMap[lang]?.count ?? 0) { return }
                print("fetch \(lang)")
                GitHubTrendAPI.shared.request(GitHubTrendRequest.GetTrend(lang: lang))
                    .subscribe(onSuccess: { (trends) in
                        if lang == "go" {
                            dump(trends)
                        }
                        self.trendRepositories.accept(trends)
                        self.repositoryMap[lang]? = trends
                    }, onError: { (err) in
                        print("error: \(err)")
                    })
                    .disposed(by: self.disposeBag)
            case .getTrendsStub:
                let stub = GitHubTrendAPI.shared.stub()
                self.trendRepositories.accept(stub)
            }})
            .disposed(by: disposeBag)
    }
}
