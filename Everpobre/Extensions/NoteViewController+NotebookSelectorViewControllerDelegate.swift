//
//  NoteViewController+NotebookSelectorViewControllerDelegate.swift
//  Everpobre
//
//  Created by Javi on 18/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

extension NoteViewController: NotebookSelectorViewControllerDelegate {
    func didSelectNotebook(notebook: Notebook) {
        self.notebookLabel.text = notebook.name
        self.notebook = notebook
    }
    
    
}
