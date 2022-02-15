
import Foundation
import UIKit

extension UIImageView {
    func loadImage(imageUrl: URL) -> URLSessionDownloadTask? {
        if let image = Cache.imageCache[imageUrl] {
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
                        Cache.imageCache[imageUrl] = image
                    }
                }
            }
        }
        downloadTask.resume()
        return downloadTask
    }
}
