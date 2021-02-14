//
//  HTTPMethod.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import Foundation


// MARK: Request Method - Enum
enum HTTPMethod {
    case get
   
    var stringify:String {
        switch self {
            case .get: return "GET"
        }
    }
}
