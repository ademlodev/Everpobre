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
        if let notebook = self.notebook {
            self.delegate?.didSelectNotebook(notebook: notebook)
        }else {
            let alertController = UIAlertController(title: "Seleccione notebook", message: "Debe seleccionar un notebook", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
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
