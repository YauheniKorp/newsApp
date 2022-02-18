//
//  NewsTableViewCell.swift
//  newsApp
//
//  Created by Admin on 18.02.2022.
//

import UIKit

class NewsTableViewCellModel {
    
    
    let title: String
    let subtitle: String
    let imageUrl: URL?
    var imageData: Data? = nil
    
    internal init(title: String, subtitle: String, imageUrl: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
    }
}

class NewsTableViewCell: UITableViewCell {

    static let identifier = "NewsTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(photoImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width-170, height: 70)
        subtitleLabel.frame = CGRect(x: 10, y: 70, width: contentView.frame.size.width-170, height: contentView.frame.size.height/2)
        
        photoImageView.frame = CGRect(x: contentView.frame.size.width-150, y: 5, width: 140, height: contentView.frame.size.height-10)
        
    }
    
    public func configure(with model: NewsTableViewCellModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        
        if let data = model.imageData {
            photoImageView.image = UIImage(data: data)
        } else if let url = model.imageUrl {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                model.imageData = data
                DispatchQueue.main.async {
                    self?.photoImageView.image = UIImage(data: data)
                }

            }.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        photoImageView.image = nil
    }

}
