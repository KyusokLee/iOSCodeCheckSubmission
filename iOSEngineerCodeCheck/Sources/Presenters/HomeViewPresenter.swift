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
    func shouldShowNetworkErrorFeedback(with error: Error)
    func shouldShowResultFailFeedback()
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
        apiClient.send(type: .repositorySearch(textString: textString)) { (data, error) in
            // jsonParserを利用してGitHub Repository結果をパースし、Viewに伝える
            guard error == nil, let hasData = data else {
                self.view?.shouldShowNetworkErrorFeedback(with: error!)
                return
            }
            
            if let repositoryResult = self.jsonParser.parse(data: hasData) {
                self.view?.shouldShowResult(with: repositoryResult)
            } else {
                self.view?.shouldShowResultFailFeedback()
            }
        }
    }
}
