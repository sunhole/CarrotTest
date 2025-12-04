//
//  ImageLoader.swift
//  CarrotTest
//
//  Created by vision on 12/4/25.
//

import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = ImageCache.shared
    private let session = URLSession.shared
    //셀 재사용 시 취소하기 위한 task 관리
    private var runningTasks: [UUID: URLSessionDataTask] = [:]
    
    func load(url: URL, completion: @escaping (UIImage?) -> Void) -> UUID? {
        //캐시 먼저 확인하기
        if let cached = cache.image(url: url) {
            completion(cached)
            return nil
        }
        //캐시에 없음 네트워크 다운로드 처리 UUID를 넣어서 추적
        let id = UUID()
        
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            // 함수 성공여부를 떠나서 일단은 태스크에 저장된 id값기준으로 한번 날리기
            defer { self?.runningTasks.removeValue(forKey: id) }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    // 실패해도 메인스레드에서 completion 처리
                    completion(nil)
                }
                return
            }
            //캐시 저장 부분
            self?.cache.store(image: image, url: url)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        //태스크관리로 취소할수있도록 관리 포인트 개선
        runningTasks[id] = task
        task.resume()
        return id
    }
    //캔슬 안하면 셀 리유즈시에 이전 요청 이미지가 들어가는등 꼬일수있음
    func cancel(id: UUID) {
        runningTasks[id]?.cancel()
        runningTasks.removeValue(forKey: id)
    }
}
