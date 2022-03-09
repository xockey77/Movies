//
//  MovieDetailCoordinator.swift
//  CollectionsView
//
//  Created by Andrey Belov on 09.03.2022.
//

import UIKit

class MovieDetailCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var movieDetailViewController: MovieDetailViewController?
    private let movie: Movie

  init(presenter: UINavigationController, movie: Movie) {
      self.movie = movie
      self.presenter = presenter
  }

  func start() {
      let movieDetailViewController = MovieDetailViewController(nibName: nil, bundle: nil)
      movieDetailViewController.title = movie.title
      movieDetailViewController.movie = movie
      presenter.pushViewController(movieDetailViewController, animated: true)
      self.movieDetailViewController = movieDetailViewController
  }
}
