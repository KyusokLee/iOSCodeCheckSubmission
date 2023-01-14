//
//  ResultDetailViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol ResultView: AnyObject {
    func shouldShowResult(with repository: RepositoryModel)
    func shouldShowNetworkErrorFeedback()
    func shouldShowRecognitionFailFeedback()
}

final class ResultDetailViewPresenter {
    private let jsonParser: RepositoryJSONParserProtocol
    private let apiClient: GitHubAPIClientProtocol
    private weak var view: ResultView?
    
    init(jsonParser: RepositoryJSONParserProtocol,
         apiClient: GitHubAPIClientProtocol,
         view: ResultView
    ) {
        self.jsonParser = jsonParser
        self.apiClient = apiClient
        // イニシャライザでViewを受け取る
        self.view = view
    }
    
    // parseModelはいらないかも -> imageとかじゃなくapi requestしてそのままparseすればいいから
    func loadRepository(from searchText: String) {
        apiClient.send(textString: searchText) { (data, error) in
            // jsonParserを利用してGitHub Repository結果をパースし、Viewに伝える
            guard error == nil,
                  let data = data else {
                self.view?.shouldShowNetworkErrorFeedback()
                return
            }
            
            if let repoResult = self.jsonParser.parse(data: data) {
                self.view?.shouldShowResult(with: repoResult)
            } else {
                self.view?.shouldShowRecognitionFailFeedback()
            }
        }
    }
}
