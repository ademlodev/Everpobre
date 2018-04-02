//
//  NotebookTableViewController.swift
//  Everpobre
//
//  Created by Javi on 23/3/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit
import CoreData

class NotebookTableViewController: UITableViewController {
    
    var notebooks =  [Notebook]()
    
    private func fetchNotebooks(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Notebook>(entityName: NOTEBOOK_ENTITY)
        
        do{
            let notebooks = try context.fetch(fetchRequest)
            
//            notebooks.forEach({ (notebook) in
//                print(" Notebook: \(notebook.name ?? "")")
//            })
            
            self.notebooks = notebooks
            self.tableView.reloadData()
            
            
        } catch let fetchErr {
            print("Failed to fetch Notebooks:" , fetchErr)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNotebooks()

        navigationItem.title = "Everpobre"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add Notebook", style: .plain, target: self, action: #selector(handleAddNotebook))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAddNote))
        
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        
        let noteBook = notebooks[indexPath.row]
        cell.textLabel?.text = noteBook.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebooks.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            (_, indexPath) in
            let notebook = self.notebooks[indexPath.row]
            print("Attempting to delete notebook: ", notebook.name ?? "")
            
            //Remove the notebook from out tableview
            self.notebooks.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //delete the notebook from core data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            context.delete(notebook)
            do {
                try context.save()
            } catch let saveErr{
                print("Failed to delete notebook:", saveErr)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit",handler: handleEditNotebook)
        
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No notebooks available..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return notebooks.count == 0 ? 150 : 0
    }
    
    // MARK: - Handle functions
    
    @objc func handleAddNotebook(){
        
        let createNotebookVC = CreateNotebookViewController()
        
        let navController = UINavigationController(rootViewController: createNotebookVC)
        
        createNotebookVC.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc func handleAddNote(){
        print("Adding note..")
        
        let createNoteVC = NoteViewController()
        
        present(createNoteVC.wrappedInNavigation(), animated: true, completion: nil)
    }
    
    private func handleEditNotebook(action: UITableViewRowAction, indexPath: IndexPath){
        print("Editing notebook..")
        
        let editNotebookController = CreateNotebookViewController()
        editNotebookController.delegate = self
        editNotebookController.notebook = notebooks[indexPath.row]
        let navController = UINavigationController(rootViewController: editNotebookController)
        present(navController, animated: true, completion: nil)
    }
    
}

extension NotebookTableViewController: CreateNotebookViewControllerDelegate{
    
    func didAddNotebook(notebook: Notebook) {
        notebooks.append(notebook)
        
        let newIndexPath = IndexPath(row: notebooks.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditNotebook(notebook: Notebook) {
        let row = notebooks.index(of: notebook)
        let reloadIndexPath = IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
}
