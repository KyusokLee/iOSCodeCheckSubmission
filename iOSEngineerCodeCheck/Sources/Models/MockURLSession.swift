//
//  MockURLSession.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/02/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// Test確認のためのMockURLSession

class MockURLSession: URLSessionProtocol {
    private (set) var lastURL: URL?
    private (set) var nextDataTask: MockURLSessionDataTask!
    
    func dataTaskWithUrl(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = url
        nextDataTask = MockURLSessionDataTask()
        return nextDataTask
    }
    
}
 
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
