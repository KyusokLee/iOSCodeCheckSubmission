//
//  RepositoryJSONParser.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// JSONParsingのみを行う
// repositoryのデータをparsingして取得するように
// imageの場合は、parserを必要
protocol RepositoryJSONParserProtocol {
    func parse(data: Data) -> RepositoryModel?
}

struct RepositoryJSONParser: RepositoryJSONParserProtocol {
    func parse(data: Data) -> RepositoryModel? {
        guard let repositoryResult = try? JSONDecoder().decode(RepositoryModel.self, from: data) else {
            return nil
        }
        
        return repositoryResult
    }
}
