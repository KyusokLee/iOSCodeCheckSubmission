//
//  ResultDetailViewPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// ResultDetailViewに関するPresenter
protocol ResultDetailView: AnyObject {
    func shouldShowUserImageResult(with imageData: Data)
    func shouldShowNetworkErrorFeedback(with error: Error, errorType: ErrorType)
    func shouldShowResultFailFeedback(errorType: ErrorType)
}

final class ResultDetailViewPresenter {
    private let httpURLClient: HTTPURLClientProtocol
    private weak var view: ResultDetailView?
    
    init(httpURLClient: HTTPURLClientProtocol,
         view: ResultDetailView
    ) {
        self.httpURLClient = httpURLClient
        // イニシャライザでViewを受け取る
        self.view = view
    }
        
    // avatarURLからimageをloadするように
    // imageはparsing処理がいらない
    func loadImage(from urlString: String) {
        httpURLClient.send(urlString: urlString) { (data, _, error) in
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
