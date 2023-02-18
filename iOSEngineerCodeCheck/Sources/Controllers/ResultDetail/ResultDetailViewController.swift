//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

// TODO: instantiateのとき、imageを先にロードしてから、入るようにしたい
// MARK: 横になっているときのlayoutの設定が必要！
// -> nibファイルからconstraintsをshift押しながら全部選択し、constraintのinstalledを既存のものから
// width: any, height: Regular(縦)を活性化させた上で、横モードのlayoutを改めて設定しておく
// 横モード: width: any, height: Compact(横)
// widthをanyにする理由は、デバイスによって適用されないものもあるので、widthをanyにするのが好ましい

// TODO: ScrollViewの導入
// 既に、IBOutletのUIを配置したのであれば、コードベースではなく、storyboardベースの方が効率的かもしれない！

final class ResultDetailViewController: UIViewController {
    
    @IBOutlet weak var repositoryImageView: UIImageView!
    @IBOutlet weak var repositoryTitleLabel: UILabel! {
        didSet {
            // repository名が長くなると、切れてしまう問題を防ぐため
            // 完全に対処できるわけではない　-> すごい小さくなると、ユーザの目にすぐ入らないため、正しいUIではないと考えた
            repositoryTitleLabel.adjustsFontSizeToFitWidth = true
            // font sizeの最小値を設定しないと、無限に縮小されてします。（defaultが0であるため）
            repositoryTitleLabel.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet weak var repositoryLanguageLabel: UILabel!
    @IBOutlet weak var repositoryStarsCountLabel: UILabel!
    @IBOutlet weak var repositoryWatchersCountLabel: UILabel!
    @IBOutlet weak var repositoryForksCountLabel: UILabel!
    @IBOutlet weak var repositoryIssuesCountLabel: UILabel!
    
    // MARK: Scroll Viewの実装
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        
        return scrollView
    }()
    
    private(set) var presenter: ResultDetailViewPresenter!
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // 初期設定として、loadingをtrueに
        view.isLoading = true
        return view
    }()
    
    static func instantiate(with repository: Repository) -> ResultDetailViewController {
        guard let controller = UIStoryboard(name: "ResultDetail", bundle: nil).instantiateViewController(
            withIdentifier: "ResultDetailViewController"
        ) as? ResultDetailViewController else {
            fatalError("ResultDetailViewController could not be found.")
        }
        
        controller.loadViewIfNeeded()
        controller.configure(with: repository)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        setScrollViewConstraints()
        self.view.addSubview(loadingView)
        setLoadingViewConstraints()
    }
    
    func setLoadingViewConstraints() {
        NSLayoutConstraint.activate([
            self.loadingView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.loadingView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.loadingView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ])
    }
    
    func setScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // safeLayoutGuideでConstraintsをセットすると、SafeLayoutの外側はscrollされない
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func showsErrorAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let check = UIAlertAction(title: "確認", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alertController.addAction(check)
        return alertController
    }
}

// MARK: - Presenterのインタフェースを実装し、画面に結果を表示
extension ResultDetailViewController {
    func configure(with repository: Repository) {
        presenter = ResultDetailViewPresenter(
            httpURLClient: HTTPURLClient(),
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

        setUpUI(from: repository)
    }
    
    func setUpUI(from repository: Repository) {
        repositoryTitleLabel.text = repository.title ?? ""
        repositoryLanguageLabel.text = repository.language == nil ? "No Language" : "Written in \(repository.language ?? "")"
        repositoryStarsCountLabel.text = "\(repository.stargazersCount ?? 0) stars"
        repositoryWatchersCountLabel.text = "\(repository.wachersCount ?? 0) watchers"
        repositoryForksCountLabel.text = "\(repository.forksCount ?? 0) forks"
        repositoryIssuesCountLabel.text = "\(repository.openIssuesCount ?? 0) open issues"
    }
}

// MARK: - ResultDetailViewのImage
extension ResultDetailViewController: ResultDetailView {
    func shouldShowUserImageResult(with imageData: Data) {
        let image = UIImage(data: imageData) ?? UIImage(data: Data())
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.repositoryImageView.image = image
        }
    }
    
    func shouldShowNetworkErrorFeedback(with error: Error, errorType: ErrorType) {
        // Network Errorを知らせるviewを表示
        print("Network Error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.present(
                self.showsErrorAlert(title: errorType.alertTitle, message: errorType.alertMessage),
                animated: true
            )
        }
    }
    
    func shouldShowResultFailFeedback(errorType: ErrorType) {
        // Imageを正しくfetchするのに失敗
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.present(
                self.showsErrorAlert(title: errorType.alertTitle, message: errorType.alertMessage),
                animated: true
            )
        }
    }
}
