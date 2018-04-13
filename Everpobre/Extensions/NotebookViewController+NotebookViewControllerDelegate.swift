
//
//  NotebookViewController+NotebookViewControllerDelegate.swift
//  Everpobre
//
//  Created by Javi on 3/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

extension NotebookTableViewController: NotebookModalViewControllerDelegate, NoteViewControllerDelegate{
    
    func didAddNotebook(notebook: Notebook) {
//        notebooks.append(notebook)
//
//        let newIndexPath = IndexPath(row: notebooks.count - 1, section: 0)
//        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    func didEditNotebook(notebook: Notebook) {
//        let row = notebooks.index(of: notebook)
//        let reloadIndexPath = IndexPath(row: row!, section: 0)
//        tableView.reloadRows(at: [reloadIndexPath], with: .middle)
    }
    
    func didAddNote(note: Note) {
        print("added note")
        //        notes.append(note)
        //
        //        let newIndexPath = IndexPath(row: note.count - 1, section: 0)
        //        tableView.insertRows(at: [newIndexPath], with: .automatic)
        tableView.reloadData()
    }
    
    func didEditNote(note: Note) {
        print("edit note")
    }
}
