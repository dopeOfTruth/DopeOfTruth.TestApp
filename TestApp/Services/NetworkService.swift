//
//  NetworkService.swift
//  TestApp
//
//  Created by Михаил Красильник on 15.08.2021.
//

import Foundation

class NetworkService {
    
    static func requestDataFromServer(withSrringURL stringURL: String, completion: @escaping (Data) -> ()) {
        
        guard let url = URL(string: stringURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID 1Jl_vUmroER7xgZUK-kCQ9EyVIBvYxBW7xeZXj95hWU", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.init(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            completion(data)
        }
        dataTask.resume()
    }
}
