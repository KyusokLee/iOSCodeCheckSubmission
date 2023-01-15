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
    case repositorySearch(textString: String)
    case avatarURL(urlString: String)
}

protocol GitHubAPIClientProtocol {
    func send(type: GitHubAPIType, completion: @escaping ((Data?, Error?) -> Void))
    func cancelTask()
}

// requestをAPI側に送信する
struct GitHubAPIClient: GitHubAPIClientProtocol {
    func send(type: GitHubAPIType, completion: @escaping ((Data?, Error?) -> Void)) {
        // ここでGitHub APIのリクエストを組み立て
        // URLSessionを使って通信をする
        // 通信が終わったらcompletionを呼ぶ
        let request = buildUpRequest(type: type)
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }.resume()
    }
    
    func cancelTask() {
        var task: URLSessionTask?
        
        if let hasTask = task {
            hasTask.cancel()
        }
    }
}

// GitHub APIのrequestを立てる
// ここで、Typeを分けて、repositorySearchであるか、avatarURLであるかを指定
private extension GitHubAPIClient {
    func buildUpRequest(type: GitHubAPIType) -> URLRequest {
        switch type {
        case .repositorySearch(textString: let textString):
            let url = URL(string: "https://api.github.com/search/repositories?q=\(textString)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            return request
            
        case .avatarURL(urlString: let urlString):
            let url = URL(string: urlString)!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            return request
        }
    }
}
