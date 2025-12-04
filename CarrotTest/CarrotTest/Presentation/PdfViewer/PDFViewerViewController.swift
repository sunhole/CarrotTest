//
//  PDFViewerViewController.swift
//  CarrotTest
//
//  Created by vision on 12/5/25.
//

import UIKit
import PDFKit

final class PDFViewerViewController: UIViewController {
    private let pdfURL: URL
    private let pdfView = PDFView()
    
    init(pdfURL: URL) {
        self.pdfURL = pdfURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("\(coder)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "미리보기 PDF"
        
        setupPDFView()
        loadPDF()
    }
    
    private func setupPDFView() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        view.addSubview(pdfView)
        
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadPDF() {
        // 원격 URL이니까 Data로 내려받아서 PDFDocument 생성
        URLSession.shared.dataTask(with: pdfURL) { [weak self] data, _, error in
            guard let self = self else { return }
            guard
                error == nil,
                let data = data,
                let document = PDFDocument(data: data)
            else {
                print("PDF 로드 실패:", error ?? NSError())
                return
            }
            
            DispatchQueue.main.async {
                self.pdfView.document = document
            }
        }.resume()
    }
}
