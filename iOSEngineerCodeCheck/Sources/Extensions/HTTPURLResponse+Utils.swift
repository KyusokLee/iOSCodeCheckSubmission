//
//  HTTPURLResponse+Utils.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/17.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    func isResponseAvailable() -> Bool {
        return (200...299).contains(self.statusCode)
    }
    
    // ⚠️422はParse Errorである(?)ため、shouldShowResultFailFeedbackで処理する
    func isClientError() -> Bool {
        return (400...499).filter { $0 != 422 }.contains(self.statusCode)
    }
    
    func isServerError() -> Bool {
        return (500...599).contains(self.statusCode)
    }
}
