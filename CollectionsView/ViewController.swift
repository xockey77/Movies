//
//  ViewController.swift
//  CollectionsView
//
//  Created by Andrey Belov on 10.02.2022.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    private let API_KEY = "91ada702dc3365bdbb0bb056b9fa5c03"
    private let endpoint1 = "https://api.themoviedb.org/3/movie/top_rated"
    private let endpoint2 = "https://api.themoviedb.org/3/movie/popular"
    static var imageCache: [URL:UIImage] = [:]
    
    
    private var lenta: [Movie] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collection1: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(
      top: 30.0,
      left: 20.0,
      bottom: 30.0,
      right: 20.0)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCollectionCell", for: indexPath) as! TableViewCell
        cell.collectionView.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Title Section \(section)"
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return lenta.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! CollectionViewCell1
        cell.configure(for: lenta[indexPath.row])
        //cell.label.text = lenta[indexPath.row].title//"\(indexPath.row + 1)\n\(films[indexPath.row])"
        return cell
     
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies(from: endpoint2)
        //collection1.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    
        return CGSize(width: 100, height: 150)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
  
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

}

extension ViewController {
    
    func fetchMovies(from endpoint: String) {
        var urlComponents = URLComponents(string: endpoint)!
        urlComponents.queryItems = [
            "api_key": API_KEY
        ].map { URLQueryItem(name: $0.key, value: $0.value)}
        //print(urlComponents.url!)
        let dataTask = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            if let error = error as NSError?, error.code == -999 {
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    let decoder = JSONDecoder()
                    let result = try! decoder.decode(APIResponseList<Movie>.self, from: data)
                    self.lenta = result.results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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

extension UIImageView {
    func loadImage(imageUrl: URL) -> URLSessionDownloadTask? {
        if let image = ViewController.imageCache[imageUrl] {
            self.image = image
            return nil
        }
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: imageUrl) {
            [weak self] url, _, error in
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                        ViewController.imageCache[imageUrl] = image
                        print(ViewController.imageCache.count)
                    }
                }
            }
        }
        downloadTask.resume()
        return downloadTask
    }
}
