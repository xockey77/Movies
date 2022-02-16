
import UIKit

class StartViewController: UIViewController {
    
    var collections: [MovieCollection] = []
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<MovieCollection, Movie>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<MovieCollection, Movie>! = nil
    static let titleElementKind = "title-element-kind"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Netflix"
        fetchMovies(collectionTitle: "Popular", from: API.shared.endpoint + "popular")
        fetchMovies(collectionTitle: "Top Rated", from: API.shared.endpoint + "top_rated")
        fetchMovies(collectionTitle: "Upcoming", from: API.shared.endpoint + "upcoming")
        configureHierarchy()
        configureDataSource()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMovieDetail" {
            let movieDetailViewController = segue.destination as! MovieDetailViewController
            let indexPath = sender as! IndexPath
            let title = collections[indexPath.section].movies[indexPath.row].title
            movieDetailViewController.title = title
            movieDetailViewController.movie = collections[indexPath.section].movies[indexPath.row]
                
        }
    }
}

extension StartViewController {
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupFractionalWidth = CGFloat(layoutEnvironment.container.effectiveContentSize.width > 500 ? 0.425 : 0.33)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(groupFractionalWidth), heightDimension: .absolute(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: StartViewController.titleElementKind,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }
}

extension StartViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<MovieCell, Movie> { (cell, indexPath, movie) in
            cell.updateCell(with: movie)
        }
        
        dataSource = UICollectionViewDiffableDataSource<MovieCollection, Movie>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movie)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: StartViewController.titleElementKind) { (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = videoCategory.title
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: index)
        }
        
        applySnapshot(animatingDifferences: false)
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        currentSnapshot = NSDiffableDataSourceSnapshot<MovieCollection, Movie>()
        collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.movies)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: animatingDifferences)
    }
}

extension StartViewController {
    
    func fetchMovies(collectionTitle: String, from endpoint: String) {
        var urlComponents = URLComponents(string: endpoint)!
        urlComponents.queryItems = [
            "api_key":  API.shared.API_KEY,
            "language": "ru"
        ].map { URLQueryItem(name: $0.key, value: $0.value)}
        let dataTask = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            if let error = error as NSError?, error.code == -999 {
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode(APIResponseList<Movie>.self, from: data)
                    let movieSet = result.results
                    let collection = MovieCollection(title: collectionTitle, movies: movieSet)
                    self.collections.append(collection)
                    DispatchQueue.main.async {
                        self.applySnapshot(animatingDifferences: false)
                    }
                    return
                }
            } else {
                DispatchQueue.main.async {
                    self.showNetworkError()
                }
            }
        }
        dataTask.resume()
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Ошибка!",
                                      message: "Ошибка загрузки данных. Попытайтесь позже",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}


extension StartViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      guard dataSource.itemIdentifier(for: indexPath) != nil else { return }
      performSegue(withIdentifier: "ShowMovieDetail", sender: indexPath)
  }
}
