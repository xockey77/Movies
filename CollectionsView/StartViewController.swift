
import UIKit

class StartViewController: UIViewController {
    
    private let API_KEY = "91ada702dc3365bdbb0bb056b9fa5c03"
    private let endpoint1 = "https://api.themoviedb.org/3/movie/top_rated"
    private let endpoint2 = "https://api.themoviedb.org/3/movie/popular"
    private let endpoint3 = "https://api.themoviedb.org/3/movie/upcoming"
    
    var videoSet: [Movie] = []

    struct VideoCollection: Hashable {
        var title: String = ""
        var videos: [Movie] = []

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    var collections: [VideoCollection] = [VideoCollection(title: "Popular", videos: []),
                                          VideoCollection(title: "Top Rated", videos: []),
                                          VideoCollection(title: "Upcoming", videos: [])]
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<VideoCollection, Movie>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<VideoCollection, Movie>! = nil
    static let titleElementKind = "title-element-kind"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Netflix"
        fetchMovies(from: endpoint2)
        while videoSet.isEmpty {
            
        }
        collections[0].videos = videoSet
        videoSet = []
        fetchMovies(from: endpoint1)
        while videoSet.isEmpty {
            
        }
        collections[1].videos = videoSet
        videoSet = []
        fetchMovies(from: endpoint3)
        while videoSet.isEmpty {
            
        }
        collections[2].videos = videoSet
        configureHierarchy()
        configureDataSource()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowMovieDetail" {
                let movieDetailViewController = segue.destination as! MovieDetailViewController
                let indexPath = sender as! IndexPath
                let title = collections[indexPath.section].videos[indexPath.row].title
                movieDetailViewController.title = title
                movieDetailViewController.movie = collections[indexPath.section].videos[indexPath.row]
                
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
        
        let cellRegistration = UICollectionView.CellRegistration
        <MovieCell, Movie> { (cell, indexPath, video) in
            cell.titleLabel.text = video.title
            cell.yearLabel.text = video.releaseYearToString
            if let imageURL = URL(string: "\(video.posterUrl!)") {
                _ = cell.imageView.loadImage(imageUrl: imageURL)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource
        <VideoCollection, Movie>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, video: Movie) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: video)
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryView>(elementKind: StartViewController.titleElementKind) {
            (supplementaryView, string, indexPath) in
            if let snapshot = self.currentSnapshot {
                let videoCategory = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.label.text = videoCategory.title
            }
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: supplementaryRegistration, for: index)
        }
        
        currentSnapshot = NSDiffableDataSourceSnapshot
            <VideoCollection, Movie>()
        collections.forEach {
            let collection = $0
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.videos)
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension StartViewController {
    
    func fetchMovies(from endpoint: String) {
        var urlComponents = URLComponents(string: endpoint)!
        urlComponents.queryItems = [
            "api_key":  API_KEY
            //"language": "ru"
        ].map { URLQueryItem(name: $0.key, value: $0.value)}
        let dataTask = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            if let error = error as NSError?, error.code == -999 {
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode(APIResponseList<Movie>.self, from: data)
                    self.videoSet = result.results
                    DispatchQueue.main.async {
                        //self.collectionView.reloadData()
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
    guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
      performSegue(withIdentifier: "ShowMovieDetail", sender: indexPath)
  }
}
