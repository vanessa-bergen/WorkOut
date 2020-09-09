//
//  APIClient.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-09-08.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation
import Combine

enum HttpMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class APIClient {
    
    let baseURL = URL(string: "http://165.232.56.142:3004")!
    let session = URLSession.shared
    
    func fetchData<T: Fetchable>(_ model: T.Type, completion: @escaping (Result<[T], Error>) -> Void) {
        
        // Construct the URLRequest
        // since the model conforms to Fetchable, it has to have the variable apiBase
        let url = baseURL
            .appendingPathComponent(model.apiBase)
        let urlRequest = URLRequest(url: url)

        // Send it to the URLSession
        let task = session.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                let result = Result { try JSONDecoder().decode([T].self, from: data) }
                completion(result)
            }
        }
        task.resume()
    }
    
    func sendData<T: Fetchable>(_ model: T.Type, for object: T, method httpMethod: HttpMethod, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) {
    
        guard let encoded = try? JSONEncoder().encode(object) else {
            print("Failed to encode object")
            return
        }
        
        let urlPath = { () -> String in
            switch httpMethod {
            case .post:
                return model.apiBase
            case .put:
                return model.apiBase + "/edit"
            default:
                return model.apiBase + "/delete"
            }
        }()
        
        let url = baseURL
            .appendingPathComponent(urlPath)
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod.rawValue
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // will either have error or data set to a value
            // if we have an error return the error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // if there's no errors, unwrap the data and response and return them
            guard let data = data, let response = response else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            completion(.success((data, response)))

        }.resume()
    }
}

// the generic type T will have to conform to Fetchable and Codable
// the fetchable protocol requires that the model has the apiBase string that will be used for the url
protocol Fetchable: Codable {
    static var apiBase: String { get }
}

extension Exercise: Fetchable {
    static var apiBase: String { return "exercise" }
}

extension Workout: Fetchable {
    static var apiBase: String { return "workout" }
}
