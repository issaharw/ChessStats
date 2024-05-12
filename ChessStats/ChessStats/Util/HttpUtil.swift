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
//            .receive(on: RunLoop.main) // Ensure the result is delivered on the main thread
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
    
    func sendTwoRequestsAndGetBothData(firstUrl: String, secondUrl: String, completion: @escaping ([Data]?, Error?) -> Void) {
        let publisher1 = URLSession.shared.dataTaskPublisher(for: URL(string: firstUrl)!)
            .map(\.data)
            .catch { _ in Just(Data()) } // Handle errors
        
        let publisher2 = URLSession.shared.dataTaskPublisher(for: URL(string: secondUrl)!)
            .map(\.data)
            .catch { _ in Just(Data()) } // Handle errors

        publisher1.zip(publisher2)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished requests")
                    // Requests completed
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { (data1, data2) in
                print("Received both responses")
                // Process data1 and data2 here
            })
            .store(in: &cancellables)
    }
}
