//
//  ApiCaller.swift
//  newsApp
//
//  Created by Admin on 18.02.2022.
//

import Foundation

final class ApiCaller {
    
    static let shared = ApiCaller()
    
    struct Constants {
        static let headliner = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=04635be9b9e449d8bd824a22a59f2aa2")
    }
    
    private init() {
        
    }
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>)-> Void) {
        guard let url = Constants.headliner else {return}
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data else {
                return completion(.failure(error!))
            }
            
            do {
                let result = try JSONDecoder().decode(ApiResponse.self, from: data)
                
                completion(.success(result.articles))
            } catch  {
                completion(.failure(error))
            }
            
            
        }
        
        task.resume()
        
    }
}

struct ApiResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
