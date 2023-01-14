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
    
    static func instantiate(with urlString: String?) -> ResultDetailViewController {
        guard let controller = UIStoryboard(name: "ResultDetail", bundle: nil).instantiateInitialViewController() as? ResultDetailViewController else {
            fatalError("ResultDetailViewController could not be found.")
        }
        
        controller.loadViewIfNeeded()
        controller.configure(with: urlString)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func configure(with urlString: String?) {
        if let hasURL = urlString {
            loadImage(urlString: hasURL) { image in
                DispatchQueue.main.async {
                    self.repositoryImageView.image = image
                }
            }
        }
        
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        navigationController?.title = "Result Detail"
    }
    
    func setUpUI() {
        repositoryTitleLabel.text = repositoryData?.title ?? ""
        repositoryLanguageLabel.text = "Written in \(repositoryData?.language ?? "")"
        repositoryStarsCountLabel.text = "\(repositoryData?.stargazersCount ?? 0) stars"
        repositoryWatchersCountLabel.text = "\(repositoryData?.wachersCount ?? 0) watchers"
        repositoryForksCountLabel.text = "\(repositoryData?.forksCount ?? 0) forks"
        repositoryIssuesCountLabel.text = "\(repositoryData?.openIssuesCount ?? 0) open issues"
    }
    
    func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void ) {
          networkLayer.request(type: .justURL(urlString: urlString)) { data, response, error in
              
              if let hasData = data {
                  completion(UIImage(data: hasData))
                  return
              }
              completion(nil)
          }
      }
    
//    func loadImage() {
//
//        let repo = vc1.repo[vc1.idx]
//
//        TtlLbl.text = repo["full_name"] as? String
//
//        if let owner = repo["owner"] as? [String: Any] {
//            if let imgURL = owner["avatar_url"] as? String {
//                URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
//                    let img = UIImage(data: data!)!
//                    DispatchQueue.main.async {
//                        self.ImgView.image = img
//                    }
//                }.resume()
//            }
//        }
//    }
    
}
