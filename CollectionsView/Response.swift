//
//  Response.swift
//  CollectionsView
//
//  Created by Andrey Belov on 14.02.2022.
//

import Foundation

struct APIResponseList<ResultType: Decodable>: Decodable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [ResultType]

    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
