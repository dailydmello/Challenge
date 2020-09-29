//
//  Networking.swift
//  Loblaws Challenge
//
//  Created by Ethan D'Mello on 2020-09-27.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import Foundation
import RxSwift

public enum RequestType: String {
    case GET, POST
}

protocol APIRequest {
    var method: RequestType { get }
    var path: String { get }
    
    // creates requests
    func request(with baseURL: URL) -> URLRequest
    
    //maps any error returned during network calls
    func getMapper() -> ErrorMapper
}

extension APIRequest {
    func getMapper() -> ErrorMapper {
        return ErrorMapper()
    }
    
    func request(with baseURL: URL) -> URLRequest {
        guard let components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("URL Components fail")
        }

        guard let url = components.url else {
            fatalError("Could not create URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

struct APIClient {
    private let baseURL = URL(string: K.baseURL)
    
    func execute(apiRequest: APIRequest) -> Single<Result<[Children], Error>> {
        guard let url = baseURL else { fatalError("URL failed in APIClient") }
        
        return Observable<Result<[Children], Error>>.create { observer in
            let request = apiRequest.request(with: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                //check for any transport/network related errors
                if let networkError = error as? URLError {
                    let redditAPIError = apiRequest.getMapper().convert(error: networkError)
                    observer.onNext(Result.failure(redditAPIError))
                    return
                }
                
                let response = response as! HTTPURLResponse
                let status = response.statusCode
                
                //check for 2XX status otherwise map to server error
                guard (200...299).contains(status) else {
                    let redditAPIError = apiRequest.getMapper().convert(httpCode: status, data: data, requestUrlPath: apiRequest.path)
                    observer.onNext(Result.failure(redditAPIError))
                    return
                }
                                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                //try to decode
                do {
                    let root = try decoder.decode(Root.self, from: data ?? Data())
                    observer.onNext(Result.success(root.data.children))
                } catch let error {
                    //pass decode error as server error, to be seen on screen for QA
                    let redditAPIError = RedditAPIError(serverError: ServerError.parsing(error: error), requestURLPath: apiRequest.path)
                    observer.onNext(Result.failure(redditAPIError))
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }.asSingle()
    }
}
