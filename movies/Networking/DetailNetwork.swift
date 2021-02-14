//
//  DetailNetwork.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import Foundation



enum DetailNetwork {
    case id(id: Int)
}

extension DetailNetwork: NetworkPath {
 
    
    var url: String {
        switch self {
        case .id(let id):
            return "\(Config.baseURL)\(id)?api_key=\(Config.api_key)&language=en-US"
        }
    }
    
    var method: HTTPMethod {
        return HTTPMethod.get
    }
}
