
import UIKit

class MovieCell: UICollectionViewCell {
    var downLoadTask: URLSessionDownloadTask?
    static let reuseIdentifier = "movie-cell-reuse-identifier"
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let yearLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    deinit {
        downLoadTask?.cancel()
    }
}

extension MovieCell {
    
    func updateCell(with movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.releaseYearToString
        if let imageURL = URL(string: "\(movie.posterUrl!)") {
            downLoadTask  = imageView.loadImage(imageUrl: imageURL)
        }
    }
    
    func configure() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)

        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.adjustsFontForContentSizeCategory = true
        yearLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        yearLabel.adjustsFontForContentSizeCategory = true
        yearLabel.textColor = .placeholderText

        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        let spacing = CGFloat(10)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CGFloat(-40)),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            yearLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
}
