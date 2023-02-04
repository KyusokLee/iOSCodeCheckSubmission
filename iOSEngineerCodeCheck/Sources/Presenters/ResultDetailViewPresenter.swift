//
//  ResultDetailViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// ResultDetailViewに関するPresenter
// ResultDetailViewでは、もう一度DataをJson Parsingする必要はない
protocol ResultDetailView: AnyObject {
    func shouldShowUserImageResult(with imageData: Data)
    func shouldShowNetworkErrorFeedback(with error: Error, errorType: ErrorType)
    func shouldShowResultFailFeedback(errorType: ErrorType)
}

final class ResultDetailViewPresenter {
    private let apiClient: GitHubAPIClientProtocol
    private weak var view: ResultDetailView?
    
    init(apiClient: GitHubAPIClientProtocol,
         view: ResultDetailView
    ) {
        self.apiClient = apiClient
        // イニシャライザでViewを受け取る
        self.view = view
    }
        
    // avatarURLからimageをloadするように
    // imageはparsing処理がいらない
    func loadImage(from urlString: String) {
        apiClient.send(type: .avatarURL(urlString: urlString)) { (data, _, error) in
            // jsonParserを利用してGitHub Repository結果をパースし、Viewに伝える
            guard error == nil else {
                self.view?.shouldShowNetworkErrorFeedback(with: error!, errorType: .networkError)
                return
            }
            
            if let imageData = data {
                self.view?.shouldShowUserImageResult(with: imageData)
            } else {
                self.view?.shouldShowResultFailFeedback(errorType: .loadDataError)
            }
        }
    }
}
