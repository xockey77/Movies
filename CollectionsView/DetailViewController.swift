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
    
    let x: Int = {
       return 10
    }()
    
    override func viewDidLoad() {
            super.viewDidLoad()
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
        }
        
        deinit {
            downLoadTask?.cancel()
        }

}
