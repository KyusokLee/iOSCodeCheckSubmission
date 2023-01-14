//
//  RepositoryJSONParser.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// JSONParsingのみを行う
protocol RepositoryJSONParserProtocol {
    func parse(data: Data) -> RepositoryModel?
}

struct RepositoryJSONParser: RepositoryJSONParserProtocol {
    func parse(data: Data) -> RepositoryModel? {
        let decoder = JSONDecoder()
        
        guard let resultResponse = try? decoder.decode(RepositoryModel.self, from: data) else {
            return nil
        }
        
        return resultResponse
    }
}
