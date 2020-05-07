//
//  APIClient.swift
//  Moviefy
//
//  Created by Benjamin Simpson on 4/29/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

struct APIClient{
    static let shared = APIClient()
    let session = URLSession(configuration: .default)
    let parameters = [
           "sort_by": "popularity.desc"
    ]
    func getPopularMovies(_ completion: @escaping (Result<[Movie]>) -> ()) {
        do{
          // Creating the request
            let request = try Request.configureRequest(from: .movies, with: parameters, and: .get, contains: nil)
                session.dataTask(with: request) { (data, response, error) in

                if let response = response as? HTTPURLResponse, let data = data {
                            print(request)
                    let result = Response.handleResponse(for: response)
                    switch result {
                    case .success:
                        //Decode if successful
                        let result = try? JSONDecoder().decode(MovieApiResponse.self, from: data)
                        completion(Result.success(result!.movies))

                    case .failure:
                        completion(Result.failure(NetworkError.decodingFailed))
                    }
                }
            }.resume()
        }catch{
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
    func getUpcomingMovies(_ completion: @escaping (Result<[Movie]>) -> ()) {
        do{
          // Creating the request
            let request = try Request.configureRequest(from: .upcomingMovies, with: parameters, and: .get, contains: nil)
                session.dataTask(with: request) { (data, response, error) in

                if let response = response as? HTTPURLResponse, let data = data {
                            print(request)
                    let result = Response.handleResponse(for: response)
                    switch result {
                    case .success:
                        //Decode if successful
                        let result = try? JSONDecoder().decode(MovieApiResponse.self, from: data)
                        completion(Result.success(result!.movies))

                    case .failure:
                        completion(Result.failure(NetworkError.decodingFailed))
                    }
                }
            }.resume()
        }catch{
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
    func createRequestToken(_ completion: @escaping (Result<AuthenticationTokenResponse>) -> ()){
        
        do{
            let request = try Request.configureRequest(from: .token, with: [:], and: .get, contains: nil)
            session.dataTask(with: request) { (data, response, error) in

              if let response = response as? HTTPURLResponse, let data = data {
                  let result = Response.handleResponse(for: response)
                  switch result {
                  case .success:
                      let result = try? JSONDecoder().decode(AuthenticationTokenResponse.self, from: data)
                      completion(Result.success(result!))
                      //(result)

                  case .failure:
                      completion(Result.failure(NetworkError.decodingFailed))
                  }
              }
            }.resume()
        }catch{
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
    func createSession(requestToken: String, _ completion: @escaping (Result<CreateSessionResponse>) -> Void){
        
            let parameters: [String: Any] = ["request_token": requestToken]

            do {
                let jsonParams = try JSONSerialization.data(withJSONObject: parameters, options: [])
                let request = try Request.configureRequest(from: .token, with: [:], and: .post, contains: jsonParams)
                session.dataTask(with: request) { (data, response, error) in

                  if let response = response as? HTTPURLResponse, let data = data {
                      let result = Response.handleResponse(for: response)
                      switch result {
                      case .success:
                          let result = try? JSONDecoder().decode(CreateSessionResponse.self, from: data)
                          completion(Result.success(result!))
                          //print(result)

                      case .failure:
                          completion(Result.failure(NetworkError.decodingFailed))
                      }
                  }
                }.resume()
        }catch{
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
    func fetchAccount(sessionId: String, _ completion: @escaping (Result<Account>) -> ()){
        
        do{
            //let parameters: [String: Any] = ["session_id": sessionId]

            //do {
                //let jsonParams = try JSONSerialization.data(withJSONObject: parameters, options: [])
                let request = try Request.configureRequest(from: .token, with: parameters, and: .get, contains: nil)
                session.dataTask(with: request) { (data, response, error) in

                  if let response = response as? HTTPURLResponse, let data = data {
                      let result = Response.handleResponse(for: response)
                      switch result {
                      case .success:
                          let result = try? JSONDecoder().decode(Account.self, from: data)
                          completion(Result.success(result!))
                          //print(result)

                      case .failure:
                          completion(Result.failure(NetworkError.decodingFailed))
                      }
                  }
                }.resume()
            //} catch { print("Error: unable to add parameters to POST request.")}
        }catch{
            completion(Result.failure(NetworkError.badRequest))
        }
    }
}

