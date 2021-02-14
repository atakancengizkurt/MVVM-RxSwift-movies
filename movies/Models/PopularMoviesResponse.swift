//
//  PopularMoviesResponse.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import Foundation


struct PopularMoviesResponse: Codable{
    var page: Int?
    var results: [Movie]?
    var total_pages: Int?
    var total_results: Int?
}

struct Movie: Codable {
    var id: Int?
    var backdrop_path: String?
    var poster_path: String?
    var name: String?
    var original_name: String?
    var vote_average: Double?
}



