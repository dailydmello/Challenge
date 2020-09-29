//
//  SwiftNewsDashboardRequest.swift
//  Loblaws-Challenge
//
//  Created by Ethan D'Mello on 2020-09-27.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import Foundation

struct SwiftNewsDashboardRequest: APIRequest {
    let method: RequestType = .GET
    let path: String = K.articlesPath
}
