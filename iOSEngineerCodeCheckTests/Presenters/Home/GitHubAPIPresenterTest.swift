//
//  GitHubAPIPresenterTest.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Kyus'lee on 2023/02/21.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import XCTest
@testable import iOSEngineerCodeCheck

// ここでは、実際使うAPIのtestを行う
// XCTFail -> 必ず失敗するエラーを生成
// XCTAssertTrue() -> 与えたパラメータの表現がTrueであることを表す
// XCTAssertFalse() -> 与えたパラメータの表現がfalseであることを表す
// XCTAssertNil() -> 与えたパラメータの表現がnilであることを指す
// XCTUnwrap -> 与えたパラメータの表現がnilでないことを表し、unwrapped valueを返す

final class GitHubAPIPresenterTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testレポジトリのロードをしなければレポジトリのロードがされないこと() {
        let view = MockSuccessView()
        XCTAssertFalse(view.isCalledShouldShowResult)
        XCTAssertFalse(view.isCalledShouldShowNetworkErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowResultFailFeedback)
        XCTAssertFalse(view.isCalledShouldShowAPIErrorFeedback)
    }
    
    func testAPIとパースが成功した場合レポジトリのロードが成功していること() {
        let view = MockSuccessView()
        let jsonParser = StubSuccessRepositoryJSONParser()
        let apiClient = StubSuccessAPIClient()
        
        let presenter = HomeViewPresenter(
            jsonParser: jsonParser,
            apiClient: apiClient,
            view: view
        )
        
        presenter.loadRepository(from: "")
        XCTAssertTrue(view.isCalledShouldShowResult)
        XCTAssertFalse(view.isCalledShouldShowNetworkErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowAPIErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowResultFailFeedback)
    }

    func testネットワークエラーによるAPI通信失敗() {
        let view = MockSuccessView()
        let jsonParser = StubSuccessRepositoryJSONParser()
        let apiClient = StubFailureNetwork()
        
        let presenter = HomeViewPresenter(
            jsonParser: jsonParser,
            apiClient: apiClient,
            view: view
        )
        
        presenter.loadRepository(from: "")
        XCTAssertFalse(view.isCalledShouldShowResult)
        XCTAssertTrue(view.isCalledShouldShowNetworkErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowAPIErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowResultFailFeedback)
    }
    
    // MARK: - 意図した通りのClientとServer側のAPIにエラーがあるというtestをしたかったが、全部networkErrorになってしまった
    func testClient側のエラーによるAPI通信失敗() {
        let view = MockSuccessView()
        let jsonParser = StubSuccessRepositoryJSONParser()
        let apiClient = StubClientFailureOfAPIClient()
        
        let presenter = HomeViewPresenter(
            jsonParser: jsonParser,
            apiClient: apiClient,
            view: view
        )
        
        presenter.loadRepository(from: "")
        XCTAssertFalse(view.isCalledShouldShowResult)
        XCTAssertTrue(view.isCalledShouldShowNetworkErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowAPIErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowResultFailFeedback)
    }
    
    func testServer側のエラーによるAPI通信失敗() {
        let view = MockSuccessView()
        let jsonParser = StubSuccessRepositoryJSONParser()
        let apiClient = StubServerFailureOfAPIClient()
        
        let presenter = HomeViewPresenter(
            jsonParser: jsonParser,
            apiClient: apiClient,
            view: view
        )
        
        presenter.loadRepository(from: "")
        XCTAssertFalse(view.isCalledShouldShowResult)
        XCTAssertTrue(view.isCalledShouldShowNetworkErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowAPIErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowResultFailFeedback)
    }
    
    func testAPI通信は成功したがJSONのパースに失敗した場合() {
        let view = MockSuccessView()
        let jsonParser = StubFailureRepositoryJSONParser()
        let apiClient = StubSuccessAPIClient()
        
        let presenter = HomeViewPresenter(
            jsonParser: jsonParser,
            apiClient: apiClient,
            view: view
        )
        
        presenter.loadRepository(from: "")
        XCTAssertFalse(view.isCalledShouldShowResult)
        XCTAssertFalse(view.isCalledShouldShowNetworkErrorFeedback)
        XCTAssertFalse(view.isCalledShouldShowAPIErrorFeedback)
        XCTAssertTrue(view.isCalledShouldShowResultFailFeedback)
    }
    
    
    
}

private extension GitHubAPIPresenterTest {
    final class MockSuccessView: HomeView {
        // 外部では読み込みだけを可能とさせたいから、private(set) varにした
        private(set) var isCalledShouldShowResult = false
        private(set) var isCalledShouldShowAPIErrorFeedback = false
        private(set) var isCalledShouldShowNetworkErrorFeedback = false
        private(set) var isCalledShouldShowResultFailFeedback = false
        
        func shouldShowResult(with repository: RepositoryModel) {
            isCalledShouldShowResult = true
        }
        
        func shouldShowAPIErrorFeedback(with response: HTTPURLResponse, errorType: ErrorType) {
            isCalledShouldShowAPIErrorFeedback = true
        }
        
        func shouldShowNetworkErrorFeedback(errorType: ErrorType) {
            isCalledShouldShowNetworkErrorFeedback = true
        }
        
        func shouldShowResultFailFeedback(errorType: ErrorType) {
            isCalledShouldShowResultFailFeedback = true
        }
    }
    
    final class StubSuccessRepositoryJSONParser: RepositoryJSONParserProtocol {
        
        func parse(data: Data) -> RepositoryModel? {
            return RepositoryModel(
                totalCount: 1,
                items: [
                    Repository(
                        owner: User(
                            userName: "Kyle",
                            id: 12345678,
                            avatarURL: "TestURL"
                        ),
                        description: "This is Test",
                        title: "テスト",
                        language: "Korean",
                        stargazersCount: 1,
                        wachersCount: 22,
                        forksCount: 333,
                        openIssuesCount: 7777
                    )
                ]
            )
        }
    }
    
    final class StubFailureRepositoryJSONParser: RepositoryJSONParserProtocol {
        // 検索にHitするものがなくても、totalCountは0を returnする
        // よって、nilであれば、RepositoryのParsingに失敗したということを想定する
        func parse(data: Data) -> RepositoryModel? {
            return nil
        }
    }
    
    final class StubSuccessAPIClient: GitHubAPIClientProtocol {
        func send(type: GitHubAPIType, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
            completion(Data(capacity: 1), HTTPURLResponse(), nil)
        }
    }
    
    // Network Errorは、HTTPURLResponseではないから、HTTPURLResponse()はそのまま返すようにした
    final class StubFailureNetwork: GitHubAPIClientProtocol {
        func send(type: GitHubAPIType, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
            completion(nil, HTTPURLResponse(), ErrorType.networkError as? Error)
        }
    }
    
    // Client側とServer側に分けたい
    final class StubClientFailureOfAPIClient: GitHubAPIClientProtocol {
        func send(type: GitHubAPIType, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
            let baseURLString = "https://api.github.com/search/repositories?q=test"
            let clientFailureResponse = HTTPURLResponse(
                url: URL(string: baseURLString)!,
                statusCode: 404,
                httpVersion: "2",
                headerFields: nil
            )
            completion(nil, clientFailureResponse, ErrorType.apiClientError as? Error)
        }
    }
    
    final class StubServerFailureOfAPIClient: GitHubAPIClientProtocol {
        func send(type: GitHubAPIType, completion: @escaping ((Data?, URLResponse?, Error?) -> Void)) {
            let baseURLString = "https://api.github.com/search/repositories?q=test"
            let serverFailureResponse = HTTPURLResponse(
                url: URL(string: baseURLString)!,
                statusCode: 501,
                httpVersion: "2",
                headerFields: nil
            )
            completion(nil, serverFailureResponse, ErrorType.apiServerError as? Error)
        }
    }
}
