//
//  SpinnerViewController.swift
//  Loblaws Challenge
//
//  Created by Ethan D'Mello on 2020-09-28.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import UIKit

class ActivitySpinnerViewController: UIViewController {
    var activitySpinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)

        activitySpinner.translatesAutoresizingMaskIntoConstraints = false
        activitySpinner.startAnimating()
        
        view.addSubview(activitySpinner)

        activitySpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activitySpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
