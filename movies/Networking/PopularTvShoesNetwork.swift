//
//  PopularTvShoesNetwork.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import Foundation


enum PopularTvShowsNetwork {
    case page(page: Int)
}

extension PopularTvShowsNetwork: NetworkPath {
 
    
    var url: String {
        switch self {
        case .page(let page):
            return "\(Config.baseURL)popular?api_key=\(Config.api_key)&language=en-US&page=\(page)"
        }
    }
    
    var method: HTTPMethod {
        return HTTPMethod.get
    }
}
