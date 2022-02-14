//
//  Genre.swift
//  CollectionsView
//
//  Created by Andrey Belov on 14.02.2022.
//

import Foundation

struct Genre: Decodable, Identifiable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
