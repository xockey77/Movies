//
//  APIClient.swift
//  CollectionsView
//
//  Created by Andrey Belov on 14.02.2022.
//

import Foundation

public class APIClient {
    private let publicKey: String
    private static let baseUrl: URL? = URL(string: "https://api.themoviedb.org/3/")
    static let baseImageStringUrl: String = "https://image.tmdb.org/t/p/w500"
    private let session: URLSession
    

    init(publicKey: String = "91ada702dc3365bdbb0bb056b9fa5c03",
         session: URLSession = .shared) {
        self.publicKey = publicKey
        self.session = session
    }

    
}
