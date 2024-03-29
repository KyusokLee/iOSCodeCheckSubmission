//
//  GitHubAPIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: avatarURLは、GitHubAPIではなく、ただのHTTP URLへのアクセスを用いるため、ここで書くのは違和感がある！
// TODO: Userだけを検索するなどの機能を実装したい
enum GitHubAPIType {
    case repositorySearch(textString: String)
    // TODO: userだけを探す機能もあるといいかも
}

protocol GitHubAPIClientProtocol {
    func send(type: GitHubAPIType, completion: @escaping ((Data?, URLResponse?, Error?) -> Void))
}

// requestをAPI側に送信する
struct GitHubAPIClient: GitHubAPIClientProtocol {
    func send(type: GitHubAPIType, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        // ここでGitHub APIのリクエストを組み立て
        // URLSessionを使って通信をする
        // 通信が終わったらcompletionを呼ぶ
        let request = buildUpRequest(type: type)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }.resume()
    }
    
}

// MARK: - requestを立てる
private extension GitHubAPIClient {
    func buildUpRequest(type: GitHubAPIType) -> URLRequest {
        switch type {
        case .repositorySearch(textString: let textString):
            var urlString = "https://api.github.com/search/repositories?q=\(textString)"
            
            // 英語以外の言語(日本語、韓国語など)の対応
            // descriptionにその打ち込んだ単語があるなら、ヒットできるAPIの仕組みとなっている
            if let safeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                urlString = safeString
            }
            
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            
            return request
            // caseを設けて他の機能を実装することも可能
        }
    }
}
