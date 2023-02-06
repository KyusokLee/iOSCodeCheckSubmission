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
    var owner: User
    var description: String?
    var title: String?
    var language: String?
    var stargazersCount: Int?
    var wachersCount: Int?
    var forksCount: Int?
    var openIssuesCount: Int?

    enum CodingKeys: String, CodingKey {
        case owner
        case description
        case title = "full_name"
        case language
        case stargazersCount = "stargazers_count"
        case wachersCount = "wachers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

struct User: Codable {
    var userName: String?
    var id: Int?
    var avatarURL: String?

    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case id
        case avatarURL = "avatar_url"
    }
}
