//
//  AllMoviesCoordinator.swift
//  CollectionsView
//
//  Created by Andrey Belov on 09.03.2022.
//

import UIKit

class MoviesCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var moviesViewController: MoviesViewController?
    private var movieDetailCoordinator: MovieDetailCoordinator?


    init(presenter: UINavigationController) {
        self.presenter = presenter
    }

    func start() {
        let moviesViewController = MoviesViewController()
        moviesViewController.delegate = self
        moviesViewController.navigationItem.title = "Movies"
        presenter.pushViewController(moviesViewController, animated: true)
        self.moviesViewController = moviesViewController
    }
}

extension MoviesCoordinator: MoviesViewControllerDelegate {
    func moviesViewControllerDidSelectMovie(_ selectedMovie: Movie) {
        let movieDetailCoordinator = MovieDetailCoordinator(presenter: presenter, movie: selectedMovie)
        movieDetailCoordinator.start()
        self.movieDetailCoordinator = movieDetailCoordinator

    }
}
