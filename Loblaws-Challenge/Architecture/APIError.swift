//
//  APIError.swift
//  Loblaws Challenge
//
//  Created by Ethan D'Mello on 2020-09-28.
//  Copyright © 2020 Ethan D'Mello. All rights reserved.
//

import Foundation

// error class that holds all errors that can occur in the app
class RedditAPIError: Error {
    let networkError: NetworkError?
    let globalServerError: ServerError?
    let errorCode: String
    let httpCode: Int?
    let requestURLPath: String?
    
    init(networkError: NetworkError) {
        self.networkError = networkError
        self.globalServerError = nil
        self.errorCode = networkError.errorCode
        self.httpCode = nil
        self.requestURLPath = nil
    }
    
    init(serverError: ServerError, httpCode: Int? = nil, requestURLPath: String) {
        self.networkError = nil
        self.globalServerError = serverError
        self.errorCode = serverError.errorCode
        self.httpCode = httpCode
        self.requestURLPath = requestURLPath
    }
}

// Transport errors
enum NetworkError: Error {
    case notConnectedToInternet
    case networkConnectionLost
    case timedOut
    case unknown(error: Error?)
    
    var errorCode: String {
        switch self {
        case .notConnectedToInternet:
            return String(URLError.notConnectedToInternet.rawValue)
        case .networkConnectionLost:
            return String(URLError.networkConnectionLost.rawValue)
        case .timedOut:
            return String(URLError.timedOut.rawValue)
        case .unknown(let error):
            return String((error as? URLError)?.errorCode ?? 9999)
        }
    }
}

//Server errors
enum ServerError: Error {
    case internalError(errorCode: String?, errorMessage: String?)
    case parsing(error: Error?)
        
    var errorCode: String {
        switch self {
        case .internalError(let errorCode, _):
            return errorCode ?? ""
        case .parsing(_):
            return "20"
        }
    }
}

struct NetworkErrorMapper {
    typealias RawErrorData = URLError
    typealias ConvertedError = NetworkError
    
    func convert(rawErrorData: URLError) -> NetworkError {
        switch rawErrorData {
        case URLError.notConnectedToInternet:
            return .notConnectedToInternet
        case URLError.networkConnectionLost:
            return .networkConnectionLost
        case URLError.timedOut:
            return .timedOut
        case URLError.unknown:
            return .unknown(error: rawErrorData)
        default:
            return .unknown(error: rawErrorData)
        }
    }
}

// mapper protocol to take raw errors returned from api calls and proper error models
protocol APIErrorMapper {
    associatedtype ErrorType: RedditAPIError
    
    //convert server errors
    func convert(httpCode: Int, data: Data?, requestUrlPath: String) -> ErrorType
    //convert transport errors
    func convert(error: URLError) -> ErrorType
}

protocol RedditAPIErrorMapper: APIErrorMapper where ErrorType == RedditAPIError {}

extension RedditAPIErrorMapper {
    func convert(httpCode: Int, data: Data?, requestUrlPath: String) -> ErrorType {
        let decoder = JSONDecoder()
        
        // created error model on assumption that server will return code and message when error occurs
        do {
            let errorModel = try decoder.decode(ErrorModel.self, from: data ?? Data())
            let serverError = ServerError.internalError(errorCode: errorModel.code, errorMessage: errorModel.message)
            return RedditAPIError(serverError: serverError, requestURLPath: requestUrlPath)
        } catch let error {
            return RedditAPIError(serverError: .parsing(error: error), requestURLPath: requestUrlPath)
        }
    }
    
    func convert(error: URLError) -> ErrorType {
        let networkError = NetworkErrorMapper().convert(rawErrorData: error)
        return RedditAPIError(networkError: networkError)
    }
}

struct ErrorMapper: RedditAPIErrorMapper {}
