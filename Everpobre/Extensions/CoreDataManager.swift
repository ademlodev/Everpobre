//
//  CoreDataManager.swift
//  Everpobre
//
//  Created by Javi on 1/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
     static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: EVERPOBRE_CD)
        
        container.loadPersistentStores{ (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed \(err)")
            }
        }
        return container
    }()
    
    func fetchNotebooks() -> [Notebook] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Notebook>(entityName: NOTEBOOK_ENTITY)
        
        do{
            let notebooks = try context.fetch(fetchRequest)
            
            return notebooks
        } catch let fetchErr {
            print("Failed to fetch Notebooks:" , fetchErr)
            return []
        }
    }
    
    func fetchNotebookDefault() -> [Notebook] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Notebook>(entityName: NOTEBOOK_ENTITY)
        fetchRequest.predicate = NSPredicate(format: "isDefault == true")
        do{
            let notebooks = try context.fetch(fetchRequest)
            
            return notebooks
        } catch let fetchErr {
            print("Failed to fetch Notebooks:" , fetchErr)
            return []
        }
    }
    
    func fetchNotes() -> [Note] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Note>(entityName: NOTE_ENTITY)
        
        do{
            let note = try context.fetch(fetchRequest)
            
            return note
        } catch let fetchErr {
            print("Failed to fetch Note:" , fetchErr)
            return []
        }
    }
    
//    mutating func fetchNotesByNotebook() -> [Note] {
//        let context = persistentContainer.viewContext
//        
//        let fetchRequest = NSFetchRequest<Note>(entityName: NOTE_ENTITY)
//        
////        do{
//            let notebookSort = NSSortDescriptor(key: "notebook.name", ascending: true)
//            let notesSort = NSSortDescriptor(key: "name", ascending: true)
//            
//            fetchRequest.sortDescriptors = [notebookSort, notesSort]
//            
//            
////            let note = try context.fetch(fetchRequest)
//        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "notebook.name", cacheName: "dist") as! NSFetchedResultsController<NSFetchRequestResult>
//            
//            fetchedResultsController.delegate = self
//            
//            do {
//                try fetchedResultsController.performFetch()
//            } catch let error as NSError {
//                print("Error: \(error.localizedDescription)")
//            }
////            return note
////        } catch let fetchErr {
////            print("Failed to fetch Note:" , fetchErr)
////            return []
////        }
//    }
    
    
    // MARK: Notes
    func CreateNote(name: String,noteDate: Date, noteText: String, notebook: Notebook) -> (Note?, Error?) {
        let context = persistentContainer.viewContext
        
        let note = NSEntityDescription.insertNewObject(forEntityName: NOTE_ENTITY, into: context) as! Note
        
        note.notebook = notebook
        
        note.setValue(name, forKey: "name")
        note.setValue(noteDate, forKey: "created")
        note.setValue(noteText,forKey: "text")
        
        do{
            try context.save()
            return (note as? Note,nil)
        } catch let saveErr {
            print("Failed to save notebook:", saveErr)
            return (nil,saveErr)
        }
    }
}
