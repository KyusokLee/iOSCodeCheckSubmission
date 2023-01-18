//
//  HomeSearchResultPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// ResultDetailViewに関するPresenter
protocol HomeView: AnyObject {
    func shouldShowResult(with repository: RepositoryModel)
    func shouldShowApiErrorFeedback(with response: HTTPURLResponse, errorType: ErrorType)
    func shouldShowNetworkErrorFeedback(with error: Error, errorType: ErrorType)
    func shouldShowResultFailFeedback(errorType: ErrorType)
}

final class HomeViewPresenter {
    private let jsonParser: RepositoryJSONParserProtocol
    private let apiClient: GitHubAPIClientProtocol
    private weak var view: HomeView?
    
    // イニシャライザでViewを受け取る
    init(jsonParser: RepositoryJSONParserProtocol,
         apiClient: GitHubAPIClientProtocol,
         view: HomeView
    ) {
        self.jsonParser = jsonParser
        self.apiClient = apiClient
        self.view = view
    }
    
    // parseModelはいらないかも -> imageとかじゃなくapi requestしてそのままparseすればいいから
    func loadRepository(from textString: String) {
        apiClient.send(type: .repositorySearch(textString: textString)) { (data, response, error) in
            // jsonParserを利用してGitHub Repository結果をパースし、Viewに伝える
            guard error == nil, let hasData = data else {
                self.view?.shouldShowNetworkErrorFeedback(with: error!, errorType: .networkError)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.isClientError() {
                    self.view?.shouldShowApiErrorFeedback(with: httpResponse, errorType: .apiClientError)
                    return
                } else if httpResponse.isServerError() {
                    self.view?.shouldShowApiErrorFeedback(with: httpResponse, errorType: .apiServerError)
                }
            }
            
            if let repositoryResult = self.jsonParser.parse(data: hasData) {
                self.view?.shouldShowResult(with: repositoryResult)
            } else {
                self.view?.shouldShowResultFailFeedback(errorType: .parseError)
            }
        }
    }
}
