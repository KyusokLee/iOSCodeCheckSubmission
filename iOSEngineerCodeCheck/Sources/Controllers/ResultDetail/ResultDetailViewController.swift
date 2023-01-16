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
        
        setNavigationBar(from: repository)
    }
    
    func setNavigationBar(from repository: Repository) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(rgb: 0x64B5F6).withAlphaComponent(0.7)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.backButtonTitle = "Back"
        self.navigationController?.navigationBar.tintColor = UIColor(rgb: 0x115293)
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = repository.owner.userName ?? "User Name"

//        navigationController?.title = repository.owner.userName ?? "User Name"
        setUpUI(from: repository)
    }
    
    func setUpUI(from repository: Repository) {
        repositoryTitleLabel.text = repository.title
        repositoryLanguageLabel.text = "Written in \(repository.language ?? "")"
        repositoryStarsCountLabel.text = "\(String(describing: repository.stargazersCount)) stars"
        repositoryWatchersCountLabel.text = "\(String(describing: repository.wachersCount)) watchers"
        repositoryForksCountLabel.text = "\(String(describing: repository.forksCount)) forks"
        repositoryIssuesCountLabel.text = "\(String(describing: repository.openIssuesCount)) open issues"
    }
}

// MARK: - ResultDetailViewのImage
extension ResultDetailViewController: ResultDetailView {
    func shouldShowUserImageResult(with imageData: Data) {
        print("success to show")
        let image = UIImage(data: imageData) ?? UIImage(data: Data())
        repositoryImageView.image = image
    }
    
    func shouldShowNetworkErrorFeedback(with error: Error) {
        // Network Errorを知らせるviewを表示
        print("Netword Error: \(error.localizedDescription)")
    }
    
    func shouldShowResultFailFeedback() {
        // Imageを正しくfetchするのに失敗
        print("Imageを正しく取得できませんでした")
    }
    
    
}
