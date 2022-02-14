//
//  CollectionViewCell1.swift
//  CollectionsView
//
//  Created by Andrey Belov on 10.02.2022.
//

import UIKit

class CollectionViewCell1: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    var downloadTask: URLSessionDownloadTask?
    
    func configure(for result: Movie) {
            
        //label.text = result.title

        imageView.image = UIImage(systemName: "square")
        imageView.layer.cornerRadius = 8
            
        if let imageURL = URL(string: "\(result.posterUrl!)") {
            downloadTask = imageView.loadImage(imageUrl: imageURL)
        }
            
    }
}
