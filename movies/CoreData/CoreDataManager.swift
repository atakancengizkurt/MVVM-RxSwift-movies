//
//  CoreDataManager.swift
//  movies
//
//  Created by Atakan Cengiz KURT on 14.02.2021.
//

import Foundation
import CoreData

public class CoreDataManager: CoreDataLayer {


    static let sharedInstance = CoreDataManager()
    static let appName = "movies"
    static var favoritesArray = [Int]()
    
   
    
   

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataManager.appName)
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("CoreDataManager \(#function) Unresolved error \(error), \(error.userInfo)")
            }
            })
        return container
    }()

    public func saveContext () {
          let context = persistentContainer.viewContext
          if context.hasChanges {
            do {
              try context.save()
            } catch {
                if let error = error as NSError? {
                    fatalError("CoreDataManager \(#function) Unresolved error \(error), \(error.userInfo)")
                }
            }
          }
    }

    public func saveDb(completion: (Bool) -> Void) {
        let managedContext =
          CoreDataManager.sharedInstance.persistentContainer.viewContext
        do {
          try managedContext.save()
          completion(true)
        } catch let error as NSError {
          print("CoreDataManager \(#function) Unresolved error \(error), \(error.userInfo)")
          completion(false)
        }
    }



    public func fetchRecords(_ entityName: CoreDataEntities) -> [NSManagedObject] {

        var resultArray: Array<NSManagedObject> = []
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)

        do {
            resultArray = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("CoreDataManager \(#function) Unresolved error \(error), \(error.userInfo)")
        }

        return resultArray

    }
    
    public func loadFavorites()  {
        let array = fetchRecords(.Favorites)
        CoreDataManager.favoritesArray.removeAll()
        for result in array {
            if let resultId = result.value(forKey: "id") as? Int {
                CoreDataManager.favoritesArray.append(resultId)
            }
        }
        print("> \(String(describing: type(of: self))): \(#function): favoritesArray: \(CoreDataManager.favoritesArray)")
    }
    
    public func addFavorite( _ id: Int)  {
        let managedContext =
          CoreDataManager.sharedInstance.persistentContainer.viewContext
        let newCampaign = NSEntityDescription.insertNewObject(forEntityName: CoreDataEntities.Favorites.rawValue, into: managedContext)
        
        newCampaign.setValue(id, forKey: "id")
        saveDb { (result) in
            loadFavorites()
        }
        
    }
    
    public func deleteFavorite(_ id: Int) {
        let managedContext =
          CoreDataManager.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntities.Favorites.rawValue)
        let idString = id.description
        fetchRequest.predicate = NSPredicate(format: "id=%@", idString)
        fetchRequest.returnsObjectsAsFaults = false
        
        do{
            let results =  try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject]{
                    if let id = result.value(forKey: "id") as? Int {
                        if id == id {
                            managedContext.delete(result)
                            saveDb { (result) in
                                loadFavorites()
                            }
                            break
                        }
                    }
                }
                
            }
            
        }catch{
            print("Error")
        }
    }
    

}

