//
//  CoreDataManager.swift
//  Everpobre
//
//  Created by Javi on 1/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//
import UIKit
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
    
    // MARK : Fetch Methods
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
    
    func fetchPhotosByNote(note: Note) -> [Photo] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Photo>(entityName: PHOTO_ENTITY)
        fetchRequest.predicate = NSPredicate(format: "note.name contains [c] %@", note.name!)
        do{
            let photos = try context.fetch(fetchRequest)
            
            return photos
        } catch let fetchErr {
            print("Failed to fetch Photos:" , fetchErr)
            return []
        }
    }
    
    
    // MARK: Notes
    func CreateNote(name: String,noteDate: Date, noteText: String, latitude: Double, longitude: Double, notebook: Notebook) -> (Note?, Error?) {
        let context = persistentContainer.viewContext
        
        let note = NSEntityDescription.insertNewObject(forEntityName: NOTE_ENTITY, into: context) as! Note
        
        note.notebook = notebook
        
        note.setValue(name, forKey: "name")
        note.setValue(noteDate, forKey: "created")
        note.setValue(noteText,forKey: "text")
        note.setValue(latitude, forKey: "latitude")
        note.setValue(longitude, forKey: "longitude")
        
        do{
            try context.save()
            return (note,nil)
        } catch let saveErr {
            print("Failed to save note:", saveErr)
            return (nil,saveErr)
        }
    }
    
    func createPhoto(image: Data ,posX: Float,posY: Float, note: Note) -> (Photo?, Error?) {
        let context = persistentContainer.viewContext
        
        let photo = NSEntityDescription.insertNewObject(forEntityName: PHOTO_ENTITY, into: context) as! Photo
        
        photo.setValue(image, forKey: "imageData")
        photo.setValue(posX, forKey: "posX")
        photo.setValue(posY, forKey: "posY")
        photo.setValue(note,forKey: "note")
        
        do{
            try context.save()
            return (photo,nil)
        } catch let saveErr {
            print("Failed to save photo:", saveErr)
            return (nil,saveErr)
        }
    }
}
