//
//  NotebookViewController+UITableView.swift
//  Everpobre
//
//  Created by Javi on 3/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

extension NotebookTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let notebook = fetchResultController.sections![section]
        
        let label = UILabel()
        label.text = fetchResultController.sectionIndexTitles[section]
        label.backgroundColor = UIColor.lightGray
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        
        let note = fetchResultController.object(at: indexPath)
//        let note = notes[indexPath.row]
        cell.textLabel?.text = note.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            (_, indexPath) in
            let note = self.fetchResultController.object(at: indexPath)
            print("Attempting to delete notebook: ", note.name ?? "")
            
            //Remove the notebook from out tableview
            self.notes.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //delete the notebook from core data
            let context = CoreDataManager.shared.persistentContainer.viewContext
            
            context.delete(note)
            do {
                try context.save()
            } catch let saveErr{
                print("Failed to delete notebook:", saveErr)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit",handler: handleEditNote)
        
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let note = self.notes[indexPath.row]
        let note = fetchResultController.object(at: indexPath)
        
        
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            //Avisamos al delegate
            delegate?.NotebookTableViewController(self, didSelectNote: note,notebook: note.notebook!)
        }else if UIDevice.current.userInterfaceIdiom == .phone{
            let noteVC = NoteViewController()
            noteVC.notebook = note.notebook
            noteVC.note = note
            navigationController?.pushViewController(noteVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "No notebooks available..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return fetchResultController.sections![section].numberOfObjects == 0 ? 150 : 0
    }

    private func handleEditNote(action: UITableViewRowAction, indexPath: IndexPath){
        print("Editing note...")
        
        let editNoteController = NoteViewController()
        editNoteController.delegate = self
        let note = fetchResultController.object(at: indexPath)
        editNoteController.note = note
        editNoteController.notebook = note.notebook
        let navController = UINavigationController(rootViewController: editNoteController)
        present(navController, animated: true, completion: nil)
    }
}
