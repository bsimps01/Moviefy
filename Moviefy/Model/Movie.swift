//
//  Movie.swift
//  Moviefy
//
//  Created by Adriana González Martínez on 4/7/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

struct Movie {
    let id: Int
    let title: String
    let posterPath: String
    let releaseDate: String
}

extension Movie: Codable {
    enum MovieCodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case title
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
        id = try movieContainer.decode(Int.self, forKey: .id)
        posterPath = try movieContainer.decode(String.self, forKey: .posterPath)
        title = try movieContainer.decode(String.self, forKey: .title)
        releaseDate = try movieContainer.decode(String.self, forKey: .releaseDate)
    }
}
    
struct MovieApiResponse {
    let page: Int
    let numberOfPages: Int
    let movies: [Movie]

}
    
extension MovieApiResponse: Codable {
        
    private enum MovieApiResponseCodingKeys: String, CodingKey {
        case page
        case numberOfPages = "total_pages"
        case movies = "results"
        }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieApiResponseCodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        numberOfPages = try container.decode(Int.self, forKey: .numberOfPages)
        movies = try container.decode([Movie].self, forKey: .movies)
    }
}

