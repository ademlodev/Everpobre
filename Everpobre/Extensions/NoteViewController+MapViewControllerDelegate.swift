//
//  NoteViewController+MapViewControllerDelegate.swift
//  Everpobre
//
//  Created by Javi on 20/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import Foundation

extension NoteViewController: MapViewControllerDelegate, NotebookTableViewControllerDelegate{
    func NotebookTableViewController(_ vc: NotebookTableViewController, didSelectNote: Note?, notebook: Notebook) {
        self.notebook = notebook
        self.note = didSelectNote
        SynchronizeView()
    }
    
    func didEditMap(latitude: Double, longitude: Double) {
        note?.latitude = latitude
        note?.longitude = longitude
    }
}
