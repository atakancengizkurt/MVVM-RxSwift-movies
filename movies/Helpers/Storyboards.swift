//
//  Storyboards.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 13.02.2021.
//

import UIKit


open class Storyboards: NSObject {
    
    static let detailViewController: UIStoryboard = {
        let storyboard = UIStoryboard(name: "Detail", bundle: Bundle.main)
        return storyboard
    }()

    
}
