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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        setNavigationBar()
        setTableView()
        configure()
    }
    
    func setTableView() {
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        registerNib()
    }
    
    func setSearchBar() {
        searchBar.placeholder = "GitHubのリポジトリを検索"
        searchBar.delegate = self
    }
    
    // ⚠️ まだ、途中の段階
    func setNavigationBar() {
        navigationController?.title = "Home"
    }

    func registerNib() {
        self.searchResultTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(repositories?.items.count ?? 0)
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
            
            if let hasURL = hasRepository.user.avatarURL {
                resultDetailViewController.presenter.loadImage(from: hasURL)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(resultDetailViewController, animated: true)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        

        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text
        
        if let hasText = text {
            print(hasText)
            presenter.cancelLoad()
            presenter.loadRepository(from: hasText)
            
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("click")
        let text = searchBar.text
        
        if let hasText = text {
            print(hasText)
//            presenter.cancelLoad()
            presenter.loadRepository(from: hasText)
            
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
        }
        
        // ✍️
//
//        if word.count != 0 {
//            url = "https://api.github.com/search/repositories?q=\(word!)"
//            task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
//                if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
//                    if let items = obj["items"] as? [[String: Any]] {
//                    self.repo = items
//                        DispatchQueue.main.async {
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//            }
//        // これ呼ばなきゃリストが更新されません
//        task?.resume()
//        }
        
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
        print(repositories?.items.count ?? 0)
    }
    
    func shouldShowNetworkErrorFeedback() {
        print("network error")
    }
    
    func shouldShowResultFailFeedback() {
        print("Parsing Error: fail to show result")
    }
}
