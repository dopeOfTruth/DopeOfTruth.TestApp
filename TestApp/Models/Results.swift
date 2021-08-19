//
//  Results.swift
//  TestApp
//
//  Created by Михаил Красильник on 15.08.2021.
//

import Foundation

struct Results: Codable {
    let results: [Result]
}

struct Result: Codable {
    
    var description: String?
    var urls: URLs
}

struct URLs: Codable {
    var small: String
    var full: String
}
