//
//  ImageCache.swift
//  CarrotTest
//
//  Created by vision on 12/4/25.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    
    private let memoryCache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheURL: URL
    
    private init() {
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        diskCacheURL = cacheDir.appendingPathComponent("ImageCache", isDirectory: true)
        
        if !fileManager.fileExists(atPath: diskCacheURL.path) {
            try? fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        }
    }
    
    func image(url: URL) -> UIImage? {
        let key = url as NSURL
        //메모리 캐시
        if let memoryImage = memoryCache.object(forKey: key) {
            print("메모리캐시:", url.absoluteString)
            return memoryImage
        }
        //디스크 캐시
        let fileURL = diskFileURL(url: url)
        
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            print("디스크캐시:", url.absoluteString)
            memoryCache.setObject(image, forKey: key)
            return image
        }
        print("캐시에 없음", url.absoluteString)
        return nil
    }
    
    func store(image: UIImage, url: URL) {
        let key = url as NSURL
        memoryCache.setObject(image, forKey: key)
        
        let fileURL = diskFileURL(url: url)
        if let data = image.pngData() {
            try? data.write(to: fileURL)
            print("케시 저장성공", fileURL.path)
        } else {
            print("캐시 저장실패", url.absoluteString)
        }
    }
    
    private func diskFileURL(url: URL) -> URL {
        //url을 파일명으로 쓰기위한 인코딩 처리
        let encoded = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? UUID().uuidString
        return diskCacheURL.appendingPathComponent(encoded)
    }
    
}
