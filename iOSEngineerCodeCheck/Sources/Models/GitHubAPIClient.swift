//
//  GitHubAPIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// 状況によって、必要なものを追加して作ることができる
enum GitHubAPIType {
    case repositoryURL(urlString: String)
    case avatarURL(urlString: String)
}

protocol GitHubAPIClientProtocol {
    func send(textString: String, completion: @escaping ((Data?, Error?) -> Void))
}

// requestをAPI側に送信する
struct GitHubAPIClient: GitHubAPIClientProtocol {
    func send(textString: String, completion: @escaping ((Data?, Error?) -> Void)) {
        // ここでGitHub APIのリクエストを組み立て
        // URLSessionを使って通信をする
        // 通信が終わったらcompletionを呼ぶ
        let request = buildUpRequest(with: textString)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }.resume()
    }
}

// GitHub APIのrequestを立てる
private extension GitHubAPIClient {
    func buildUpRequest(with base64String: String) -> URLRequest {
        
        
        
        let word = ""
        let url = URL(string: "https://api.github.com/search/repositories?q=\(word)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
