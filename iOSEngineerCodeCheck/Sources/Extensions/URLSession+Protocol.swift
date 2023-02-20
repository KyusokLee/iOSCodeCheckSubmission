//
//  URLSession+Protocol.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/02/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
    func dataTaskWithUrl(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}
typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

extension URLSession: URLSessionProtocol {
    func dataTaskWithUrl(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        self.dataTask(with: url, completionHandler: completionHandler)
    }
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
