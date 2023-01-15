//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

// TODO: instantiateのとき、imageを先にロードしてから、入るようにしたい

class ResultDetailViewController: UIViewController {
    
    @IBOutlet weak var repositoryImageView: UIImageView!
    @IBOutlet weak var repositoryTitleLabel: UILabel!
    @IBOutlet weak var repositoryLanguageLabel: UILabel!
    @IBOutlet weak var repositoryStarsCountLabel: UILabel!
    @IBOutlet weak var repositoryWatchersCountLabel: UILabel!
    @IBOutlet weak var repositoryForksCountLabel: UILabel!
    @IBOutlet weak var repositoryIssuesCountLabel: UILabel!
    private(set) var presenter: ResultDetailViewPresenter!
    
    var repositoryData: Repository?
    
    static func instantiate(with repository: Repository) -> ResultDetailViewController {
        guard let controller = UIStoryboard(name: "ResultDetail", bundle: nil).instantiateViewController(withIdentifier: "ResultDetailViewController") as? ResultDetailViewController else {
            fatalError("ResultDetailViewController could not be found.")
        }
        
        controller.loadViewIfNeeded()
        controller.configure(with: repository)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Presenterのインタフェースを実装し、画面に結果を表示
extension ResultDetailViewController {
    func configure(with repository: Repository) {
        presenter = ResultDetailViewPresenter(
            apiClient: GitHubAPIClient(),
            view: self
        )
        
        setUpNavigationBar(from: repository)
    }
    
    func setUpNavigationBar(from repository: Repository) {
        navigationController?.title = repository.user.userName ?? "User Name"
        setUpUI(from: repository)
    }
    
    // ⚠️network　errorによるunfetchはまだ定義してない
    func setUpUI(from repository: Repository) {
        let unfetchedMessage = "読み取れませんでした"
        
        repositoryTitleLabel.text = repository.title ?? unfetchedMessage
        repositoryLanguageLabel.text = "Written in " + (repository.language ?? unfetchedMessage)
        repositoryStarsCountLabel.text = "\(String(describing: repository.stargazersCount)) stars"
        repositoryWatchersCountLabel.text = "\(repository.wachersCount ?? 0) watchers"
        repositoryForksCountLabel.text = "\(repository.forksCount ?? 0) forks"
        repositoryIssuesCountLabel.text = "\(repository.openIssuesCount ?? 0) open issues"
    }
}

// MARK: - ResultDetailViewのImage
extension ResultDetailViewController: ResultDetailView {
    func shouldShowUserImageResult(with imageData: Data) {
        print("success to show")
        let image = UIImage(data: imageData) ?? UIImage(data: Data())
        repositoryImageView.image = image
    }
    
    func shouldShowNetworkErrorFeedback() {
        // Network Errorを知らせるviewを表示
        print("Network Error")
    }
    
    func shouldShowResultFailFeedback() {
        // Imageを正しくfetchするのに失敗
        print("Imageを正しく取得できませんでした")
    }
    
    
}
