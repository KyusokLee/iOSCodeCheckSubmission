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
    @IBOutlet weak var repositoryLanguageStackView: UIStackView!
    @IBOutlet weak var repositoryLanguageColorView: UIView!
    @IBOutlet weak var repositoryLanguageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(repository: Repository) {
        repositoryTitleLabel.text = repository.title
        repositoryLanguageStackView.isHidden = repository.language == nil ? true : false
        repositoryLanguageColorView.backgroundColor = .blue
        repositoryLanguageColorView.layer.cornerRadius = repositoryLanguageColorView.frame.width / 2
        repositoryLanguageLabel.text = repository.language
    }
}
