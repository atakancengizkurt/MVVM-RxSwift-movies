//
//  Detail.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import Foundation


struct DetailResponse: Codable {
    var name: String?
    var original_name: String?
    var poster_path: String?
    var genres: [Genre]?
    var number_of_episodes: Int?
    var number_of_seasons: Int?
    
    
    func getGenres() -> String{
        if let genres = self.genres{
            var genresArray = [String]()
            for i in genres{
                if let name = i.name{
                    genresArray.append(name)
                }
            }
            return genresArray.joined(separator: ", ")
        }
        return ""
    }
    
    
}

struct Genre: Codable {
    var id: Int?
    var name: String?
}
