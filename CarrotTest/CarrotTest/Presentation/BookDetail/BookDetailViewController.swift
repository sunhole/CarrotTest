//
//  BookDetailViewController.swift
//  CarrotTest
//
//  Created by vision on 12/4/25.
//

import UIKit

final class BookDetailViewController: UIViewController {
    private let viewModel: BookDetailViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let authorsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let bookInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let pdfLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemBlue
        label.numberOfLines = 0
        return label
    }()
    
    private let pdfButtonsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "도서 상세"
        
        setupLayout()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addArrangedSubview(imageView)
        contentView.addArrangedSubview(titleLabel)
        contentView.addArrangedSubview(subtitleLabel)
        contentView.addArrangedSubview(authorsLabel)
        contentView.addArrangedSubview(descriptionLabel)
        contentView.addArrangedSubview(bookInfoLabel)
        contentView.addArrangedSubview(pdfLabel)
        contentView.addArrangedSubview(pdfButtonsStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }
    
    private func loadData() {
        viewModel.loadDetail(completion: { [weak self] result in
            switch result {
            case .success:
                self?.updateUI()
            case .failure(let error):
                print("!에러발생! \(error)")
            }
        })
    }
    
    
    private func updateUI(){
        titleLabel.text = viewModel.titleText
        subtitleLabel.text = viewModel.subtitleText
        authorsLabel.text = viewModel.authorsText
        descriptionLabel.text = viewModel.descriptionText
        
        bookInfoLabel.text = """
        출판사: \(viewModel.publisherText)
        언어: \(viewModel.languageText)
        ISBN10: \(viewModel.isbn10Text)
        ISBN13: \(viewModel.isbn13Text)
        페이지: \(viewModel.pagesText)
        출간 연도: \(viewModel.yearText)
        평점: \(viewModel.ratingText)
        가격: \(viewModel.priceText)
        URL: \(viewModel.urlText)
        """
                
        setupPDFSection()
        
        if let url = viewModel.imageURL {
           _ = ImageLoader.shared.load(url: url, completion: { [weak self] image in
                self?.imageView.image = image
            })
        }
    }
    
    private func setupPDFSection() {
        // 이전에 만든 버튼들 제거 다시 그릴 때 중복 방지
        pdfButtonsStackView.arrangedSubviews.forEach { button in
            pdfButtonsStackView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        let pdfDict = viewModel.pdf
        
        if pdfDict.isEmpty {
            pdfLabel.text = "이 책은 미리보기 pdf를 제공하지 않습니다."
            return
        }
        
        pdfLabel.text = "미리보기 PDF"
        
        // 챕터 이름으로 정렬해서 버튼 만들기
        let sortedEntries = pdfDict.sorted { $0.key < $1.key }
        
        for (chapter, link) in sortedEntries {
            guard let url = URL(string: link) else { continue }
            
            let button = UIButton(type: .system)
            button.setTitle(chapter, for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            
            // 버튼 탭 시 PDF 뷰어로 이동
            let action = UIAction { [weak self] _ in
                self?.openPDF(url: url)
            }
            button.addAction(action, for: .touchUpInside)
            
            pdfButtonsStackView.addArrangedSubview(button)
        }
    }
    
    private func openPDF(url: URL) {
        let viewer = PDFViewerViewController(pdfURL: url)
        navigationController?.pushViewController(viewer, animated: true)
    }
}

    

