//
//  NotebookSelectorViewController.swift
//  Everpobre
//
//  Created by Javi on 18/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

protocol NotebookSelectorViewControllerDelegate {
    func didSelectNotebook(notebook: Notebook)
}

class NotebookSelectorViewController: UITableViewController{

    var notebooks: [Notebook]!
    var notebook: Notebook?
    var delegate : NotebookSelectorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Select notebook"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.didSelectNotebook(notebook: self.notebook!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "NotebookCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ??
            UITableViewCell(style: .default, reuseIdentifier: cellId)
        
//        let notebook = notebooks![indexPath.row]
//        cell.textLabel?.text = notebook.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let notebook = notebooks[indexPath.row]
        //Sincroniza el modelo con las celdas
        cell.textLabel?.text = notebook.name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (notebooks?.count)!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notebook = notebooks[indexPath.row]
        
    }
}
