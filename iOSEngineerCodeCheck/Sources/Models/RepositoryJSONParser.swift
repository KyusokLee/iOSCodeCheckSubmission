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
        let decoder = JSONDecoder()
        // codingKeysを別途に設けずに、decoder.keyDecodingStrategy = .convertFromSnakeCaseを用いてJSONのconvertがしやすい
        // ただし、 _以外の名前はマッチしないといけない
        // 例) JSON上のキーがuserなのに、コード上ではownerという変数として使いたい場合
        guard let repositoryResult = try? decoder.decode(RepositoryModel.self, from: data) else {
            return nil
        }
        
        return repositoryResult
    }
}
