//
//  NoteViewController.swift
//  Everpobre
//
//  Created by Javi on 3/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate {
    func didAddNote(note: Note)
    func didEditNote(note: Note)
}

class NoteViewController: UIViewController, UINavigationControllerDelegate{
    
    var notebook: Notebook?
    var note: Note? {
        didSet {
            nameTextView.text = note?.name
            guard let date = note?.created else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YYYY"
            
            dateTextView.text = dateFormatter.string(from: date as Date)
            noteTextView.text = note?.text
            notebookLabel.text = notebook?.name
        }
    }
    var delegate : NoteViewControllerDelegate?
    
    var customImage : CustomImageView!
    var photos: [CustomImageView] = []

    let notebookLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let nameTextView: UITextField = {
        let textView = UITextField()
        textView.placeholder = "Enter the name"
        textView.translatesAutoresizingMaskIntoConstraints  = false
        return textView
    }()
    
    let dateTextView: UITextField = {
        let textView = UITextField()
        textView.placeholder = "dd/MM/YYYY"
        textView.translatesAutoresizingMaskIntoConstraints  = false
        return textView
    }()
    
    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints  = false
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIStyle()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Notebook", style: .plain, target: self, action: #selector(selectNotebook))
        
        if (note == nil){
            setupCancelNavigation()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(createNote))
        }
        
        notebookLabel.text = notebook?.name
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveNoteChanges()
    }
    
    func setupUIStyle(){
        
        let noteDataStackView = UIStackView(arrangedSubviews: [nameTextView,dateTextView])
        noteDataStackView.translatesAutoresizingMaskIntoConstraints = false
        noteDataStackView.distribution = .fillEqually
        
        view.addSubview(notebookLabel)
        view.addSubview(noteDataStackView)
        view.addSubview(noteTextView)
//        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
//            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            notebookLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notebookLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notebookLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            notebookLabel.heightAnchor.constraint(equalToConstant: 50),
            
            noteDataStackView.topAnchor.constraint(equalTo: notebookLabel.bottomAnchor),
            noteDataStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteDataStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noteDataStackView.heightAnchor.constraint(equalToConstant: 50),
            
            noteTextView.topAnchor.constraint(equalTo: noteDataStackView.bottomAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            //imageView.topAnchor.constraint(equalTo: noteTextView.topAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 250),
//            imageView.heightAnchor.constraint(equalToConstant: 250),
            
        ])
        
       
        navigationController?.isToolbarHidden = false
        
        let photoBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(catchPhoto))
        let flexible = UIBarButtonItem(title: "Tags", style: .done,target: self, action: #selector(addTags))
        let mapBarButton = UIBarButtonItem(title: "Map", style: .done, target: self, action: #selector(addLocation))
        
        self.setToolbarItems([photoBarButton,flexible,mapBarButton], animated: false)
        
    }
    
    @objc func catchPhoto()
    {
        let actionSheetAlert = UIAlertController(title: NSLocalizedString("Add photo", comment: "Add photo"), message: nil, preferredStyle: .actionSheet)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
//        let useCamera = UIAlertAction(title: "Camera", style: .default) { (alertAction) in
//            imagePicker.sourceType = .camera
//            self.present(imagePicker, animated: true, completion: nil)
//        }
        
        let usePhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (alertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .destructive, handler: nil)
        
//        actionSheetAlert.addAction(useCamera)
        actionSheetAlert.addAction(usePhotoLibrary)
        actionSheetAlert.addAction(cancel)
        
        present(actionSheetAlert, animated: true, completion: nil)
        
    }

    @objc func addLocation()
    {
        let mapVC = MapViewController()
        
        let navController = UINavigationController(rootViewController: mapVC)
        
        //createNotebookVC.delegate = self
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc func addTags(){
        let tagsVC = TagsViewController()
        let navController = UINavigationController(rootViewController: tagsVC)
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc func selectNotebook(){
        let notebookSelectorVC = NotebookSelectorViewController()
//        let navController = UINavigationController(rootViewController: notebookSelectorVC)
        
        notebookSelectorVC.notebooks = CoreDataManager.shared.fetchNotebooks()
        
        notebookSelectorVC.delegate = self
        
//        present(navController, animated: false, completion: nil)
        
        navigationController?.pushViewController(notebookSelectorVC, animated: false)
    }
    // MARK: TextField Delegate
//    func textFieldDidEndEditing(_ textField: UITextField)
//    {
//        note?.title = textField.text
//
//        try! note?.managedObjectContext?.save()
//    }
    
    
//    @objc func handleSave(){
//        if note == nil {
//            CreateNote()
//        }else{
//            saveNoteChanges()
//        }
//
//
//
//    }
    
    @objc func createNote(){
        guard let name = nameTextView.text else { return }
        guard let textDate = dateTextView.text else { return }
        guard let text = noteTextView.text else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        let noteDate = dateFormatter.date(from: textDate)
        guard let notebook = notebook else { return }
        
        let dataTuple = CoreDataManager.shared.CreateNote(name: name, noteDate: noteDate!, noteText: text, notebook: notebook)
        if let error = dataTuple.1 {
            print(error)
        }else{
//            dismiss(animated: true, completion: nil)
            dismiss(animated: true){
                self.delegate?.didAddNote(note: (dataTuple.0)!)
            }
        }
    }
    
    private func saveNoteChanges(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        guard let name = nameTextView.text else { return }
        guard let textDate = dateTextView.text else { return }
        guard let text = noteTextView.text else { return }
        
        // Check Date
        if textDate.isEmpty {
            let alertController = UIAlertController(title: "Fecha vacia", message: "Inserte una fecha", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let noteDate = dateFormatter.date(from: textDate) else {
            let alertDateFormatController = UIAlertController(title: "Fecha incorrecta", message: "Inserte formato dd/MM/yyyy", preferredStyle: .alert)
            alertDateFormatController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertDateFormatController, animated: true, completion: nil)
            return
        }
        let noteDate_ : NSDate = (noteDate as NSDate?)!
        guard let notebook = notebook else { return }
        
        note?.name = name
        note?.created = noteDate_
        note?.text = text
        note?.notebook = notebook
        
        do{
            try context.save()
            
            dismiss(animated: true){
                self.delegate?.didEditNote(note: self.note!)
            }
        } catch let saveErr {
            print("Failed to save note:", saveErr)
        }
    }
    
    
}

extension NoteViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //Create the image
            customImage = CustomImageView(view: noteTextView, image: image)
            customImage.setupUIStyle()
//            customImage.image = image
            photos.append(customImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
