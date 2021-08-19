//
//  Extension + UIImageVeiw.swift
//  TestApp
//
//  Created by Михаил Красильник on 15.08.2021.
//

import UIKit

extension UIImageView {
    
    func fetchData(url: String) {
        guard let imageURL = URL(string: url) else {
            
            return
        }
        
        if let cachedImage = getImageFromCache(url: imageURL) {
            image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let error = error { print(error); return }
            
            guard let data = data, let response = response else { return }
            guard let responseURL = response.url else { return }
            
            if responseURL.absoluteString != url { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
            self.saveImageToCache(data: data, response: response)
            
        }.resume()
        
        
    }
    
    private func saveImageToCache(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cacheResponse =  CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cacheResponse, for: URLRequest(url: responseURL))
    }
    
    
    private func getImageFromCache(url: URL) -> UIImage? {
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }
}
