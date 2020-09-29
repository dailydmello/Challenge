//
//  SwiftNewsDashboardCell.swift
//  Loblaws-Challenge
//
//  Created by Ethan D'Mello on 2020-09-27.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import SDWebImage

class SwiftNewsDashboardCell: UITableViewCell {
    static let reuseIdentifier: String = "SwiftNewsDashboardCell"
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    
    func configure(with news: SwiftNews) {
        if news.thumbnail != "self", let url = URL(string: news.thumbnail), let placeholderImage = UIImage(named: "swift-og") {
            articleImage.sd_setImage(with: url, placeholderImage: placeholderImage, options: [], context: nil)
        }
        articleTitle.text = news.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImage.sd_cancelCurrentImageLoad()
        articleImage.image = nil
    }
}
