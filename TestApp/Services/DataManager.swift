//
//  DataManager.swift
//  TestApp
//
//  Created by Михаил Красильник on 15.08.2021.
//

import Foundation

class DataManager {
    
    
    static func fetchImage(url: String, completion: @escaping (Results) -> ()) {
        
        NetworkService.requestDataFromServer(withSrringURL: url) { data in
            let decoder = JSONDecoder()
            
            do {
                let results = try decoder.decode(Results.self, from: data)
                completion(results)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    

    
    
    
}
