//
// Created by arabian9ts on 2019-08-28.
// Copyright (c) 2019 arabian9ts. All rights reserved.
//

import Moya

protocol GitHubTrendAPITargetType: TargetType {
    associatedtype Response: Codable
}

extension GitHubTrendAPITargetType {
    typealias Response = [GitHubRepository]
    var baseURL: URL { return URL(string: "https://github-trending-api.now.sh")! }
    var headers: [String: String]? { return nil }
    var task: Task { return .requestPlain }
}

enum GitHubTrendRequest {
    struct GetTrend: GitHubTrendAPITargetType {
        var method: Method { return .get }
        var path: String { return "/" }
        var parameters: [String: Any] { return ["since": since, "language": lang] }
        var task: Task {
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
        var lang: String
        var since: String

        init(lang: String) {
            self.lang = lang
            self.since = "today"
        }
        
        var sampleData: Data {
            let path = Bundle.main.path(forResource: "Stubs/TrendStub", ofType: "json")!
            return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
        }
    }
}
