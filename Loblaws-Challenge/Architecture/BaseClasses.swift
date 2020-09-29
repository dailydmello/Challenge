//
//  Presenter.swift
//  Loblaws Challenge
//
//  Created by Ethan D'Mello on 2020-09-27.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import RxSwift

// MARK: - Presenter

protocol Presentable {
    associatedtype View
    var view: View! { get set }
}

// MARK: - ViewController

protocol ViewControllable: class, Loadable, ErrorMessagePresentable {}

protocol Loadable {
    func showLoading()
    func hideLoading()
}

protocol ErrorMessagePresentable {
    func showError(_ error: Error)
}

