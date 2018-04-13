//
//  NotebookTableViewController.swift
//  Everpobre
//
//  Created by Javi on 23/3/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import CoreData

class NotebookTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var notebooks =  [Notebook]()
    var notes = [Note]()
    
    lazy var fetchResultController: NSFetchedResultsController<Note> = {
       let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Note>(entityName: NOTE_ENTITY)
        
        let notebookSort = NSSortDescriptor(key: "notebook.name", ascending: true)
        let notesSort = NSSortDescriptor(key: "name", ascending: true)

        fetchRequest.sortDescriptors = [notebookSort, notesSort]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "notebook.name", cacheName: nil)
        
        frc.delegate = self
        do {
            try frc.performFetch()
        }catch let err{
            print("Error on fetch: ", err)
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.notes = CoreDataManager.shared.fetchNotes()
        //self.notebooks = CoreDataManager.shared.fetchNotebooks()
        
        navigationItem.title = "Everpobre"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Notebook", style: .plain, target: self, action: #selector(handleAddNotebook))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Note", style: .plain, target: self, action: #selector(handleAddNote))
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    // MARK: - Handle functions
    
    @objc func handleAddNotebook(){
        
        let createNotebookVC = NotebookModalViewController()
        
        let navController = UINavigationController(rootViewController: createNotebookVC)
        
        createNotebookVC.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleAddNote(){
        print("Adding note...")
        //TODO Get Default notebook and add here

        
        let createNoteVC = NoteViewController()
        createNoteVC.delegate = self
//        createNoteVC.notebook = notebooks[0]
        present(createNoteVC.wrappedInNavigation(), animated: true, completion: nil)
    }
}
