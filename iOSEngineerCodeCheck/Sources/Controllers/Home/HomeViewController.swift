//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

// TODO: SearchBarでtextを打ち、検索ボタンを押さなくてもリポジトリのリストが表示されるように
// MARK: ✍️がついているところは、私が書いたコード
// MARK: ⚠️途中の段階ってこと

class HomeViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    private(set) var presenter: HomeViewPresenter!
    var repositories: RepositoryModel?
    
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isLoading = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        setNavigationBar()
        setTableView()
        configure()
        
        self.view.addSubview(loadingView)
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
    
    func showLoadingStatusAlert() -> UIAlertController {
        let loadingStatusAlertController = UIAlertController(title: "", message: "ネットワークに繋がっていません", preferredStyle: .alert)
        let check = UIAlertAction(title: "確認", style: .destructive) { _ in
            print("error")
        }
              
        let cancel = UIAlertAction(title: "キャンセル", style: .default)
        loadingStatusAlertController.addAction(cancel)
        loadingStatusAlertController.addAction(check)
        
        return loadingStatusAlertController
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
        // ✍️
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text
        
        if let hasText = text {
            print(hasText)
           // presenter.cancelLoad()
           // presenter.loadRepository(from: hasText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        
        if let hasText = text {
            self.loadingView.isLoading = true
            presenter.loadRepository(from: hasText)
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
        print("success")
        // データを正常に持ってくることを確認
        self.repositories = repository
        print(repository)
        print(repository.items.count)
        
        DispatchQueue.main.async {
            self.loadingView.isLoading = false
            self.searchResultTableView.reloadData()
        }
    }
    
    func shouldShowNetworkErrorFeedback(with error: Error) {
        print("Network Error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.present(self.showLoadingStatusAlert(), animated: true)
        }
    }
    
    func shouldShowResultFailFeedback() {
        print("Parsing Error: fail to show result")
    }
}
