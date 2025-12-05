import XCTest
@testable import CarrotTest

final class BookDetailViewModelTests: XCTestCase {
    
    func test_loadDetail_success_setsBookAndUIProperties() {
        // given
        let mockRepo = MockBookRepository()
        
        let detail = BookDetailResponse(
            error: "0",
            title: "Practical MongoDB",
            subtitle: "Architecting, Developing, and Administering MongoDB",
            authors: "Shakuntala Gupta Edward, Navin Sabharwal",
            publisher: "Apress",
            language: "English",
            isbn10: "1484206487",
            isbn13: "9781484206485",
            pages: "272",
            year: "2015",
            rating: "3",
            desc: "Practical Guide to MongoDB...",
            price: "$41.65",
            image: "https://itbook.store/img/books/9781484206485.png",
            url: "https://itbook.store/books/9781484206485",
            pdf: [
                "Chapter 1": "https://itbook.store/files/9781484206485/chapter1.pdf"
            ]
        )
        
        mockRepo.detailResult = .success(detail)
        
        let viewModel = BookDetailViewModel(repository: mockRepo, isbn13: "9781484206485")
        let exp = expectation(description: "detail load")
        
        // when
        viewModel.loadDetail { result in
            switch result {
            case .success:
                // then - book이 세팅되었는지
                XCTAssertNotNil(viewModel.book)
                
                // 핵심 필드들만 우선 체크
                XCTAssertEqual(viewModel.titleText, "Practical MongoDB")
                XCTAssertEqual(viewModel.authorsText, "Shakuntala Gupta Edward, Navin Sabharwal")
                XCTAssertEqual(viewModel.publisherText, "Apress")
                XCTAssertEqual(viewModel.isbn13Text, "9781484206485")
                
                // 있으면 좋은 부가 정보들
                XCTAssertEqual(viewModel.subtitleText, "Architecting, Developing, and Administering MongoDB")
                XCTAssertEqual(viewModel.languageText, "English")
                XCTAssertEqual(viewModel.pagesText, "272")
                XCTAssertEqual(viewModel.yearText, "2015")
                XCTAssertEqual(viewModel.ratingText, "3")
                XCTAssertEqual(viewModel.priceText, "$41.65")
                XCTAssertEqual(viewModel.urlText, "https://itbook.store/books/9781484206485")
                
                // pdf가 제대로 매핑되는지만 확인
                XCTAssertEqual(viewModel.pdf["Chapter 1"], "https://itbook.store/files/9781484206485/chapter1.pdf")
            case .failure:
                XCTFail("Expected success")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    func test_loadDetail_failure_propagatesError() {
        // given
        let mockRepo = MockBookRepository()
        mockRepo.detailResult = .failure(.invalidResponse)
        
        let viewModel = BookDetailViewModel(repository: mockRepo, isbn13: "123")
        let exp = expectation(description: "detail load failure")
        
        // when
        viewModel.loadDetail { result in
            // then
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                // Equatable 안 쓰는 버전
                switch error {
                case .invalidResponse:
                    XCTAssertTrue(true)
                default:
                    XCTFail("Expected invalidResponse")
                }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
