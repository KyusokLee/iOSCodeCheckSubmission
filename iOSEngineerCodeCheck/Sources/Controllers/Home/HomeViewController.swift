//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

// TODO: SearchBarでtextを打ち、検索ボタンを押さなくてもリポジトリのリストが表示されるように

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var repositories: RepositoryModel?
    private(set) var presenter: HomeViewPresenter!
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // 初期設定として、loadingをfalseに
        view.isLoading = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(loadingView)
        setSearchBar()
        setNavigationBar()
        setTableView()
        configure()
        setLoadingViewConstraints()
    }
    
    func setTableView() {
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchResultTableView.keyboardDismissMode = .onDrag
        registerNib()
    }
    
    func setSearchBar() {
        searchBar.placeholder = "GitHubのリポジトリを検索"
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.delegate = self
    }
    
    func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        //configureWithOpagueBackgroundで前の設定をリセットし、不透明の色としてNavigationBarの外見をセット可能
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(rgb: 0x64B5F6).withAlphaComponent(0.7)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        self.navigationItem.backButtonTitle = "Back"
        self.navigationController?.navigationBar.tintColor = UIColor(rgb: 0x115293)
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Home"
    }

    func registerNib() {
        self.searchResultTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    func setLoadingViewConstraints() {
        NSLayoutConstraint.activate([
            self.loadingView.leftAnchor.constraint(equalTo: self.searchResultTableView.leftAnchor),
            self.loadingView.rightAnchor.constraint(equalTo: self.searchResultTableView.rightAnchor),
            self.loadingView.bottomAnchor.constraint(equalTo: self.searchResultTableView.bottomAnchor),
            self.loadingView.topAnchor.constraint(equalTo: self.searchResultTableView.topAnchor)
        ])
    }
    
    func showErrorAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let check = UIAlertAction(title: "確認", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alertController.addAction(check)
        return alertController
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell {
            if let hasRepository = repositories?.items[indexPath.row] {
                cell.configure(repository: hasRepository)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let hasRepository = repositories?.items[indexPath.row] {
            let resultDetailViewController = ResultDetailViewController.instantiate(with: hasRepository)
            if let hasURL = hasRepository.owner.avatarURL {
                resultDetailViewController.presenter.loadImage(from: hasURL)
            }
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(resultDetailViewController, animated: true)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        if let hasText = text {
            // 空白があるときのErrorを防ぐ
            let trimmedText = hasText.trimmingCharacters(in: .whitespaces)
            self.loadingView.isLoading = true
            presenter.loadRepository(from: trimmedText)
        }
        searchBar.setShowsCancelButton(false, animated: true)
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        // ✍️キーボード下ろす
        self.view.endEditing(true)
    }
}

// MARK: - Presenterのインタフェースを実装し、画面に結果を表示
extension HomeViewController {
    func configure() {
        // presenterをconfigureさせ、以降のapi callもupdateできるように
        presenter = HomeViewPresenter(
            jsonParser: RepositoryJSONParser(),
            apiClient: GitHubAPIClient(),
            view: self
        )
    }
}

// MARK: - Searchをすると、アップデートされるHomeView
extension HomeViewController: HomeView {
    func shouldShowResult(with repository: RepositoryModel) {
        self.repositories = repository
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.searchResultTableView.reloadData()
        }
    }
    
    func shouldShowApiErrorFeedback(with response: HTTPURLResponse, errorType: ErrorType) {
        print("Status Code: \(response.statusCode)")
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.present(self.showErrorAlert(title: errorType.alertTitle, message: errorType.alertMessage), animated: true)
        }
    }
    
    func shouldShowNetworkErrorFeedback(with error: Error, errorType: ErrorType) {
        // Debugのため
        print("Network Error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.present(self.showErrorAlert(title: errorType.alertTitle, message: errorType.alertMessage), animated: true)
        }
    }
    
    func shouldShowResultFailFeedback(errorType: ErrorType) {
        print("Parsing Error: fail to show result")
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.present(self.showErrorAlert(title: errorType.alertTitle, message: errorType.alertMessage), animated: true)
        }
    }
}
