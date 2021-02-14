//
//  CoreDataLayer.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 14.02.2021.
//

import Foundation
import CoreData

public protocol CoreDataLayer: class {
    func saveContext()
    func saveDb(completion:(_ result: Bool) -> Void)
    func fetchRecords(_ entityName: CoreDataEntities) -> [NSManagedObject]
    func loadFavorites()
    func addFavorite(_ id: Int)
    func deleteFavorite(_ id: Int)
    
}
