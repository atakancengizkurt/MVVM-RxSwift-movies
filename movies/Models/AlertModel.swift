//
//  AlertModel.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import Foundation

struct AlertModel {
    let title:String
    let descriptionText:String
    
    init(title:String , descriptionText:String) {
        self.title = title
        self.descriptionText = descriptionText
    }
}
