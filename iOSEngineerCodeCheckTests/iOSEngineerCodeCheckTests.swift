//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

// XCTest: Unit Testに関するものを提供するフレームワーク
// XCTestCase: Testクラス、Testメソッドなどを定義するクラス

// MARK: - TDDのメリット
// 1. ErrorやBugが発生しないコードを作成でき、Debuggingがしやすくなる
// 2. 追加的な要求事項がある場合、そのニーズに素早く対応・反映できる(コードの変更が容易)
// 3. プロダクトのメンテナンスが容易

// TDDを実現する方法として、Unit Testが挙げられる.
// MARK: - Unit Testの必要性
// 1. それぞれのモジュールを部分的に確認することができ、どのモジュールで問題が発生したか早く確認することが可能
// 2. 全体プログラムをビルドする代わりに、ユニット単位で確認しながら、確認できるので、時間節約が可能
// 注意点: テストコードを念頭に置かずにむやみにコードを作成(ロジックの分離をせじに)したならば、テストすることが難しい。

class iOSEngineerCodeCheckTests: XCTestCase {
    
    var parser: RepositoryJSONParser!
    var session: MockURLSession!
    

    override func setUpWithError() throws {
        // 初期化コードを作成するメソッド
        // クラスのそれぞれのテスト関数が呼び出され、各テストが全て同じ状態と条件で実行されるようにしてくれるメソッド
        
        super.setUp()
        parser = RepositoryJSONParser()
        session = MockURLSession()
        
    }

    override func tearDownWithError() throws {
        // 解除コードを作成するメソッド
        // setUpWithError()で設定した値たちを解除するとき使われる
        // それぞれのテストの実行が終わった後に、呼び出される間数
    }

    func testExample() throws {
        // テストケースを作成するメソッド
        // すなわち、testで始まるメソッドたちは、作成すべきtest caseになるメソッドである
        // テストnamingは、必ずtestから始まる
        // テストが正しく結果を生成しているかどうかを確認する間数
    }

    func testPerformanceExample() throws {
        // 性能をテストするためのメソッド
        // 時間を測定するコードを作成する関数である
        // 以下のmeasureブロックで性能を測定することになる
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
