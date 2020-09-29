//
//  SwiftNewsDetailViewController.swift
//  Loblaws-Challenge
//
//  Created by Ethan D'Mello on 2020-09-28.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import UIKit

class SwiftNewsDetailViewController: UIViewController {
    private var viewModel: SwiftNews?
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.swiftNewsDetailNavTitle
        updateView()
    }
    
    private func updateView() {
        if let viewModel = viewModel {
            if viewModel.thumbnail != "self", let url = URL(string: viewModel.thumbnail), let placeholderImage = UIImage(named: "swift-og") {
                articleImage.sd_setImage(with: url, placeholderImage: placeholderImage)
            }
            bodyTextLabel.text = viewModel.selftext
        }
    }
}

extension SwiftNewsDetailViewController: SwiftNewsDelegate {
    func passData(viewModel: SwiftNews) {
        self.viewModel = viewModel
    }
}
