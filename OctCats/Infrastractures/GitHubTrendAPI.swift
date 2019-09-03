//
//  GitHubTrendAPI.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/28.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import Moya
import RxMoya
import RxSwift

class GitHubTrendAPI {
    static let shared = GitHubTrendAPI()
    private let provider = MoyaProvider<MultiTarget>()
    
    func request<R>(_ request: R) -> Single<R.Response> where R: GitHubTrendAPITargetType {
        let target = MultiTarget(request)
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(R.Response.self)
    }
    
    func stub() -> [GitHubRepository] {
        let path = Bundle.main.path(forResource: "Stubs/TrendStub", ofType: "json")!
        let data = FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        let decoder = JSONDecoder()
        let repos = try! decoder.decode([
            GitHubRepository].self, from: data)
        return repos
    }
}
