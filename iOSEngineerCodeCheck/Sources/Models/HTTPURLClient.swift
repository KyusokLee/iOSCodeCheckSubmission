//
//  HTTPURLAccess.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/02/04.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// APIではなく、ただのURLStringに関するClient Layer
protocol HTTPURLClientProtocol {
    func send(urlString: String, completion: @escaping ((Data?, URLResponse?, Error?) -> Void))
}

// HTTPURLへのrequest
struct HTTPURLClient: HTTPURLClientProtocol {
    func send(urlString: String, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
        // URLSessionを使って通信をする
        // 通信が終わったらcompletionを呼ぶ
        let request = buildUpRequest(with: urlString)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }.resume()
    }
    
}

// requestを立てる
private extension HTTPURLClient {
    func buildUpRequest(with urlString: String) -> URLRequest {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
}
