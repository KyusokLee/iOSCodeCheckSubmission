//
//  HomeTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Kyus'lee on 2023/01/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var repositoryTitleLabel: UILabel!
    @IBOutlet weak var repositoryLanguageColorView: UIView!
    @IBOutlet weak var repositoryLanguageStackView: UIStackView!
    @IBOutlet weak var repositoryLanguageLabel: UILabel! {
        didSet {
            repositoryLanguageLabel.font = .systemFont(ofSize: 13)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(repository: Repository) {
        if repository.language == nil {
            repositoryLanguageStackView.isHidden = true
        } else {
            repositoryLanguageStackView.isHidden = false
        }
        
        repositoryTitleLabel.text = repository.title
        // MARK: ⚠️途中: Programming言語ごとの色をつけたい
        // 実装中だったので、isHiddenで隠す
        repositoryLanguageColorView.isHidden = true
        repositoryLanguageLabel.text = repository.language
    }
}
