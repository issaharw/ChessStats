//
//  HttpUtli.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation
import Combine

class HttpUtil {
    var cancellables = Set<AnyCancellable>()
    
    func fetchData<T: Codable>(ofType type: T.Type, from urlString: String, completion: @escaping (T?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, URLError(.badURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("username: issaharw, email: issahar.wss@gmail.com", forHTTPHeaderField: "User-Agent")

        let task = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
        task
            .sink(receiveCompletion: { taskCompletion in
                 switch taskCompletion {
                 case .finished:
                     print("Successfully fetched data for \(urlString)")
                 case .failure(let error):
                     print("Failed to fetch data: \(error)")
                     completion(nil, error)
                 }
             }, receiveValue: { retData in
                completion(retData, nil)
             })
             .store(in: &cancellables)
    }
    
    func fetchMultipleData<T: Codable>(ofType type: T.Type, from urlStrings: [String], completion: @escaping ([T]?, Error?) -> Void) {
        let tasks = urlStrings.compactMap { urlString -> AnyPublisher<T, Error>? in
            guard let url = URL(string: urlString) else {
                completion(nil, URLError(.badURL))
                return nil
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("username: issaharw, email: issahar.wss@gmail.com", forHTTPHeaderField: "User-Agent")

            return URLSession.shared.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        }
        
        let initialPublisher = Result<[T], Error>.Publisher([]).eraseToAnyPublisher()
        
        // Chain the publishers using flatMap
        let combinedTasks = tasks.reduce(initialPublisher) { (combined, next) in
            combined.flatMap { results in
                next.map { result in
                    results + [result] // Append the result to the array
                }
            }
            .eraseToAnyPublisher()
        }

//        Publishers.MergeMany(tasks)
//            .collect()
        combinedTasks.sink(receiveCompletion: { taskCompletion in
                 switch taskCompletion {
                 case .finished:
                     print("Successfully fetched data for multiple request")
                 case .failure(let error):
                     print("Failed to fetch data: \(error)")
                     completion(nil, error)
                 }
             }, receiveValue: { retData in
                completion(retData, nil)
             })
             .store(in: &cancellables)
    }
}
