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
            .tryMap { output -> Data in
                // Check for HTTP response status code if needed
                guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .tryMap { data -> T in
                // Attempt to decode the data into MyObject
                do {
                    let object = try JSONDecoder().decode(T.self, from: data)
                    return object
                } catch {
                    debugData(header: "Single request Decoding issue", data: String(data: data, encoding: .utf8)!)
                    throw URLError(.badServerResponse)
                }
            }
            .eraseToAnyPublisher()

        task
            .sink(receiveCompletion: { taskCompletion in
                 switch taskCompletion {
                 case .finished:
                     debug("Successfully fetched data for \(urlString)")
                 case .failure(let error):
                     debug("Failed to fetch data: \(error)")
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
                .tryMap { output -> Data in
                    // Check for HTTP response status code if needed
                    guard let httpResponse = output.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    return output.data
                }
                .tryMap { data -> T in
                    // Attempt to decode the data into MyObject
                    do {
                        let object = try JSONDecoder().decode(T.self, from: data)
                        return object
                    } catch {
                        debugData(header: "Multiple requests Decoding issue", data: String(data: data, encoding: .utf8)!)
                        throw URLError(.badServerResponse)
                    }
                }
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

        combinedTasks.sink(receiveCompletion: { taskCompletion in
                 switch taskCompletion {
                 case .finished:
                     debug("Successfully fetched data for multiple request")
                 case .failure(let error):
                     debug("Failed to fetch data: \(error)")
                     completion(nil, error)
                 }
             }, receiveValue: { retData in
                completion(retData, nil)
             })
             .store(in: &cancellables)
    }
}
