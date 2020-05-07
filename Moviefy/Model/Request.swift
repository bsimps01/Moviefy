//
//  Request.swift
//  Moviefy
//
//  Created by Benjamin Simpson on 4/29/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

public enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum Route: String{
    case movies = "discover/movie"
    case upcomingMovies = "movie/top_rated"
    case token = "authentication/token/new"
    case session = "authentication/session/new"
    case account = "account"
}

struct Request {
    static let headers = [
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MzEzYTBlMGE3ZDNjNjFkOGI3NGVmNmI0YTM0NTQ0OSIsInN1YiI6IjVlYTlmOWIyMzI0ODliMDAyMWJjNmVkYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.rHluXQmswxb7v6jUlLLoRFcWFgho4MkV4tag8g2Es2U"
    ]
    
    public static let baseImageURL = URL(string: "https://image.tmdb.org/t/p/w500")!
    
    static func configureRequest(from route: Route, with parameters: [String: Any], and method: HTTPMethod, contains body: Data?) throws -> URLRequest {

        guard let url = URL(string: "https://api.themoviedb.org/3/\(route.rawValue)") else { fatalError("Error while unwrapping url")}
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
        request.httpMethod = method.rawValue
        request.httpBody = body
        try configureParametersAndHeaders(parameters: parameters, headers: headers, request: &request)
        return request
    }
    static func configureParametersAndHeaders(parameters: [String: Any]?,
                                                  headers: [String: String]?,
                                                  request: inout URLRequest) throws {
        do {
            if let headers = headers, let parameters = parameters {
                try Encoder.encodeParameters(for: &request, with: parameters)
                try Encoder.setHeaders(for: &request, with: headers)
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
    
    public enum NetworkError: String, Error {
        case parametersNil = "Parameters were nil"
        case encodingFailed = "Parameter Encoding failed"
        case decodingFailed = "Unable to Decode data"
        case missingURL = "The URL is nil"
        case couldNotParse = "Unable to parse the JSON response"
        case noData = "Data is nil"
        case fragmentResponse = "Response's body has fragments"
        case authenticationError = "You must be authenticated"
        case badRequest = "Bad request"
        case pageNotFound = "Page not found"
        case failed = "Request failed"
        case serverError = "Server error"
        case noResponse = "No response"
        case success = "Success"

    }

