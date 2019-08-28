//
//  GitHubTrend.swift
//  OctCats
//
//  Created by arabian9ts on 2019/08/28.
//  Copyright © 2019 arabian9ts. All rights reserved.
//

import Foundation

class GitHubTrend: Codable {
    var author:             String? = ""
    var name:               String? = ""
    var avatar:             String? = ""
    var url:                String? = ""
    var description:        String? = ""
    var language:           String? = ""
    var languageColor:      String? = ""
    var stars:              Int?    = 0
    var forks:              Int?    = 0
    var currentPeriodStars: Int?    = 0
    
    private enum CodingKeys: String, CodingKey {
        case author
        case name
        case avatar
        case url
        case description
        case language
        case languageColor
        case stars
        case forks
        case currentPeriodStars
    }
}
