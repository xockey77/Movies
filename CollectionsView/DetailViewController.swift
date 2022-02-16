//
//  DetailViewController.swift
//  CollectionsView
//
//  Created by Andrey Belov on 15.02.2022.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var movie: Movie!
    var downLoadTask: URLSessionDownloadTask?
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .clear
        if movie != nil {
            updateUI()
        }
    }
        
    func updateUI() {
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
