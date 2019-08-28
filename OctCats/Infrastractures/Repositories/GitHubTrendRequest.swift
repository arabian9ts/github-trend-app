//
// Created by arabian9ts on 2019-08-28.
// Copyright (c) 2019 arabian9ts. All rights reserved.
//

import Moya

protocol GitHubTrendAPITargetType: TargetType {
    associatedtype Response: Codable
}

extension GitHubTrendAPITargetType {
    typealias Response = [GitHubTrend]
    var baseURL: URL { return URL(string: "https://github-trending-api.now.sh")! }
    var headers: [String : String]? { return nil }
    var task: Task { return .requestPlain }
    var parameters: [String: Any]? { return nil }
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "Stubs/TrendStub", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
}

enum GitHubTrendRequest {
    struct GetTrend: GitHubTrendAPITargetType {
        var method: Method { return .get }
        var path: String { return "/" }
        var parameters: [String : Any]? { return ["since" : since, "lang" : lang ] }
        var lang: String
        var since: String

        init(lang: String) {
            self.lang = "Swift"
            self.since = "today"
        }
    }
}
