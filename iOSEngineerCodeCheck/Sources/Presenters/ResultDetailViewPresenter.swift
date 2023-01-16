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
    func shouldShowNetworkErrorFeedback(with error: Error)
    func shouldShowResultFailFeedback()
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
        apiClient.send(type: .avatarURL(urlString: urlString)) { (data, error) in
            // jsonParserを利用してGitHub Repository結果をパースし、Viewに伝える
            guard error == nil else {
                self.view?.shouldShowNetworkErrorFeedback(with: error!)
                return
            }
            
            if let hasData = data {
                print("success to show image!")
                self.view?.shouldShowUserImageResult(with: hasData)
            } else {
                self.view?.shouldShowResultFailFeedback()
            }
        }
    }
}
