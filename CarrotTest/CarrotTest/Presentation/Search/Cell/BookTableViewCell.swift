//
//  BookTableViewCell.swift
//  CarrotTest
//
//  Created by vision on 12/4/25.
//

import UIKit

final class BookTableViewCell: UITableViewCell {
    static let reuseIdentifier = "BookTableViewCell"
    
    //이미지 로딩 취소용 ID (셀 재사용 대비 ID값 할당)
    private var loadID: UUID?
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 13)
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let isbnLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 9)
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        selectionStyle = .none
        
        let infoStack = UIStackView(arrangedSubviews: [isbnLabel, priceLabel])
        infoStack.axis = .horizontal
        infoStack.spacing = 8
        infoStack.distribution = .fillProportionally
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, infoStack, urlLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(textStack)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            textStack.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        isbnLabel.text = nil
        priceLabel.text = nil
        urlLabel.text = nil
        
        if let id = loadID {
            ImageLoader.shared.cancel(id: id)
            loadID = nil
        }
    }
    
    func configure(with book: BookModel) {
        titleLabel.text = book.title
        subtitleLabel.text = book.subtitle
        isbnLabel.text = book.isbn13
        priceLabel.text = book.price
        urlLabel.text = book.url
        
        if let url = URL(string: book.image) {
            loadID = ImageLoader.shared.load(url: url, completion: { [weak self] image in
                self?.thumbnailImageView.image = image
            })
        } else {
            thumbnailImageView.image = nil
        }
    }
}
