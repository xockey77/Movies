//
//  DetailViewController.swift
//  CollectionsView
//
//  Created by Andrey Belov on 15.02.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie?
    var cast: [Cast] = []
    var downLoadTask: URLSessionDownloadTask?
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movie {
            fetchCredits(from: API.shared.endpoint + "\(movie.id)/credits")
            updateUI(for: movie)
        }
    }
        
    func updateUI(for movie: Movie) {
        if let posterUrl = URL(string: "\(movie.posterUrl!)") {
            downLoadTask = posterView.loadImage(imageUrl: posterUrl)
        }
        posterView.layer.cornerRadius = 8
        posterView.clipsToBounds = true
        descriptionLabel.text = movie.overview ?? ""
        yearLabel.text = "\(movie.releaseYearToString), ★\(movie.voteAverage)"
    }
        
    deinit {
        downLoadTask?.cancel()
    }
}

extension MovieDetailViewController {
    
    func fetchCredits(from endpoint: String) {
        var urlComponents = URLComponents(string: endpoint)!
        urlComponents.queryItems = [
            "api_key":  API.shared.API_KEY,
        ].map { URLQueryItem(name: $0.key, value: $0.value)}
        let dataTask = URLSession.shared.dataTask(with: urlComponents.url!) { [self] data, response, error in
            if let error = error as NSError?, error.code == -999 {
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode(Credits.self, from: data)
                    if let cast = result.cast {
                        self.cast = cast
                    }
                    DispatchQueue.main.async {
                        for man in cast {
                            print("\(man.name) - \(man.character)")
                        }
                    }
                    return
                }
            } else {
                DispatchQueue.main.async { print("Network error!") }
                }
        }
        dataTask.resume()
    }
}
