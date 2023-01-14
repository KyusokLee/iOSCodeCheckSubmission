//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// Repositoryから取りたい値だけをModelとして設定
// itemsの中にRepositoryのデータが入っている構造
// itemsの中のownerの中に特定したuserのデータが格納されている

struct RepositoryModel: Codable {
    let items: [Repository]
}

struct Repository: Codable {
    var user: User
    var title: String?
    var language: String?
    var stargazersCount: Int?
    var wachersCount: Int?
    var forksCount: Int?
    var openIssuesCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case user = "owner"
        case title = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case wachersCount = "wachers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

// imageがString型のurlとして格納されている
struct User: Codable {
    var id: Int?
    var avatarURL: String?
    
    enum codingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
    }
}