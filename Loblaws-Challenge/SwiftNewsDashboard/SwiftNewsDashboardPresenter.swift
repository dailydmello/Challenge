//
//  SwiftNewsDashboardPresenter.swift
//  Loblaws-Challenge
//
//  Created by Ethan D'Mello on 2020-09-27.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import Foundation

//As a way the separate responsibilites, the presenters job is to make netowork calls and tell the view when and what to display
class SwiftNewsDashboardPresenter: Presentable {
    private let apiClient: APIClient
    weak var view: SwiftNewsDashboardViewControllable!
    
    var viewModels: [SwiftNews] = []
    
    init(view: SwiftNewsDashboardViewControllable, apiClient: APIClient) {
        self.apiClient = apiClient
        self.view = view
    }
    
    func loadNews() {
        view.showLoading()
         _ = apiClient.execute(apiRequest: SwiftNewsDashboardRequest())
            .subscribe(onSuccess: { [unowned self] result in
                self.view.hideLoading()
                switch result {
                case .success(let data):
                    let viewModels = data.map { $0.data }
                    self.viewModels = viewModels
                    self.view.update()
                case .failure(let error):
                    self.view.showError(error)
                }
            })
    }
}
