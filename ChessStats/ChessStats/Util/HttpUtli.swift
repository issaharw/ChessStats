//
//  HttpUtli.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation
import Combine

func sendRequest(urlStr: String, completion: @escaping ([String: Any]?, Error?) -> Void) {

    //create the url with NSURL
    let url = URL(string: urlStr)!

    //create the session object
    let session = URLSession.shared

    //now create the Request object using the url object
    var request = URLRequest(url: url)
    request.httpMethod = "GET" //set http method as POST

    //HTTP Headers
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("username: issaharw, email: issahar.wss@gmail.com", forHTTPHeaderField: "User-Agent")

    //create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request, completionHandler: { data, response, error in

        guard error == nil else {
            completion(nil, error)
            return
        }

        guard let data = data else {
            completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
            return
        }

        do {
            //create json object from data
            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                return
            }
            completion(json, nil)
        } catch let error {
            completion(nil, error)
        }
    })

    task.resume()
}

func sendTwoRequestsAndGetBothData(firstUrl: String, secondUrl: String, completion: @escaping ([Data]?, Error?) -> Void) {
    let url1 = URL(string: "https://api.example.com/endpoint1")!
    let url2 = URL(string: "https://api.example.com/endpoint2")!

    // Create publishers for each HTTP request
    let publisher1 = URLSession.shared.dataTaskPublisher(for: url1)
        .map(\.data)
        .catch { _ in Just(Data()) } // Handle errors or provide a default value

    let publisher2 = URLSession.shared.dataTaskPublisher(for: url2)
        .map(\.data)
        .catch { _ in Just(Data()) } // Handle errors or provide a default value

    // Array to collect responses
    var responses: [Data] = []

    // Subscription set
    var cancellables = Set<AnyCancellable>()

    // Merge publishers
    publisher1.merge(with: publisher2)
        .sink(receiveCompletion: { completion in
             switch completion {
             case .finished:
                 print("All requests completed") // All individual request streams completed
             case .failure(let error):
                 print("Error: \(error)") // Handle error scenario
             }
         }, receiveValue: { data in
             // Collect each piece of data
             responses.append(data)
             // Check if all responses are collected
             if responses.count == 2 {
                 print("Received all responses")
                 completion(responses, nil)
             }
         })
         .store(in: &cancellables)

}
