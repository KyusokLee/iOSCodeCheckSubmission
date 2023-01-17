//
//  ErrorType.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/17.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// ⚠️途中の段階
enum ErrorType {
    case apiClientError
    case apiServerError
    case networkError
    case parseError
    case loadDataError
}

extension ErrorType {
    var alertTitle: String {
        switch self {
        case .apiClientError:
            return "APIサービスエラー"
        case .apiServerError:
            return "APIサーバーエラー"
        case .networkError:
            return "ネットワークエラー"
        case .parseError:
            return "パースエラー"
        case .loadDataError:
            return "データ取得エラー"
        }
    }
    
    var alertMessage: String {
        switch self {
        case .apiClientError:
            return "APIサービスにエラーが起きました。\nしばらく時間が経ってから、もう一度お試しください。"
        case .apiServerError:
            return "サーバーにエラーが起きました。\nもう一度、お試しください。"
        case .networkError:
            return "ネットワークに繋がっていません。\nもう一度、確認してください。"
        case .parseError:
            return "データを正しく表示できませんでした。\nもう一度、お試しください。"
        case .loadDataError:
            return "イメージを正しく取得できませんでした。\nしばらく時間が経ってから、もう一度お試しください。"
        }
    }
}
