//
//  Models.swift
//  Loblaws-Challenge
//
//  Created by Ethan D'Mello on 2020-09-27.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import Foundation

struct Root: Codable {
    let kind: String
    let data: RootData
}

struct RootData: Codable {
    let children: [Children]
}

struct Children: Codable {
    let data: SwiftNews
}

struct SwiftNews: Codable {
    let title: String
    let thumbnail: String
    let selftext: String
}

// added this model for internal server codes and messages
struct ErrorModel: Codable {
    let code: String?
    let message: String?
}
