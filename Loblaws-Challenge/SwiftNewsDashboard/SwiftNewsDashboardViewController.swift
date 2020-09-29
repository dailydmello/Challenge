//
//  SwiftNewsDashboardViewController.swift
//  Loblaws-Challenge
//
//  Created by Ethan D'Mello on 2020-09-27.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import UIKit

protocol SwiftNewsDashboardViewControllable: ViewControllable {
    func update()
}

//Delegate protocol to pass data between view controllers
protocol SwiftNewsDelegate: class {
    func passData(viewModel: SwiftNews)
}

class SwiftNewsDashboardViewController: UIViewController {
    let child = ActivitySpinnerViewController()
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: SwiftNewsDelegate?
    
    lazy var presenter: SwiftNewsDashboardPresenter = {
        return SwiftNewsDashboardPresenter(view: self, apiClient: APIClient())
    }()
    
    // empyty label text to display when empty array is returned, good UI practice
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = K.emptyLabelText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.swiftNewsNavTitle
        
        tableView.register(UINib(nibName: SwiftNewsDashboardCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SwiftNewsDashboardCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter.loadNews()
    }
    
    // MARK: Loadable Protocol
    func showLoading() {
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            self.child.willMove(toParent: nil)
            self.child.view.removeFromSuperview()
            self.child.removeFromParent()
        }
    }
    
    // MARK: ErrorMessagePresentable Protocol
    func showError(_ error: Error) {
        let errorMessage = parseError(error: error)
        let alert = UIAlertController(title: "", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func parseError(error: Error) -> String {
        // would display friendly message on production and detailed message like below on dev, to help debug
        var message = ""
        if let redditAPIError = error as? RedditAPIError {
            if let httpCode = redditAPIError.httpCode {
                message += "status: \(httpCode)\n\n"
            }
            message += "code: \(redditAPIError.errorCode)\n\n"
            message += "message: \(redditAPIError.localizedDescription )\n\n"
            message += "path: \(redditAPIError.requestURLPath ?? "")\n\n"
            if let networkError = redditAPIError.networkError {
                message += "network error: \(networkError)\n\n"
            } else if let serverError = redditAPIError.globalServerError {
                message += "server error: \(serverError)\n\n"
            }
        }
        return message
    }
    
    // MARK: Creator and Router
    private func createAndRoute(with viewModel: SwiftNews) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SwiftNewsDetailViewController") as! SwiftNewsDetailViewController
        navigationController?.pushViewController(vc, animated: true)
        delegate = vc
        delegate?.passData(viewModel: viewModel)
    }
}

extension SwiftNewsDashboardViewController: SwiftNewsDashboardViewControllable {
    func update() {
        DispatchQueue.main.async {
            if self.presenter.viewModels.isEmpty {
                self.tableView.isHidden = true
                self.showEmptyView()
            } else {
                self.emptyLabel.removeFromSuperview()
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    func showEmptyView() {
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 16).isActive = true
    }
}

extension SwiftNewsDashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < presenter.viewModels.count else {
            return UITableViewCell()
        }

        var cell: UITableViewCell
        let viewModel = presenter.viewModels[indexPath.row]
        if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: SwiftNewsDashboardCell.reuseIdentifier, for: indexPath) as? SwiftNewsDashboardCell {
            tableViewCell.configure(with: viewModel)
            cell = tableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: SwiftNewsDashboardCell.reuseIdentifier, for: indexPath)
        }

        return cell
    }
}

extension SwiftNewsDashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = presenter.viewModels[indexPath.row]
        createAndRoute(with: model)
    }
}



