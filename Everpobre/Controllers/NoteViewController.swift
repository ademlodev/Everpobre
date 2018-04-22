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
    var photos: [Photo]?
    var photosCI: [CustomImageView] = []
    
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
    
    // MARK: IBOutlet by code
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
        
        SynchronizeView()
        
        let selectNotebookBarBtn = UIBarButtonItem(title: "Notebook", style: .plain, target: self, action: #selector(selectNotebook))
        let saveBarBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItems = [saveBarBtn, selectNotebookBarBtn]
        
        notebookLabel.text = notebook?.name
    }
    
    func SynchronizeView() {
        
        if let note = note {
            photos = CoreDataManager.shared.fetchPhotosByNote(note: note)
            for photoToCI in photos! {
                if let imageData = photoToCI.imageData {
                    let image = UIImage(data: imageData as Data)
                    let photoCI = CustomImageView(view: noteTextView, image: image!, posX: photoToCI.posX, posY: photoToCI.posY, rotation: photoToCI.rotation, scale: photoToCI.scale)
                    photoCI.setupUIStyle()
                    photosCI.append(photoCI)
                }
            }
        }else{
            let backItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
            
            navigationItem.leftBarButtonItem = backItem
        }
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
            
        ])
        
       
        navigationController?.isToolbarHidden = false
        
        let photoBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(catchPhoto))
        let flexible1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let tagsBarButton = UIBarButtonItem(title: "Tags", style: .done,target: self, action: #selector(addTags))
        let flexible2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let mapBarButton = UIBarButtonItem(title: "Map", style: .done, target: self, action: #selector(addLocation))
        
        self.setToolbarItems([photoBarButton,flexible1,tagsBarButton,flexible2,mapBarButton], animated: false)
        
    }
    
    @objc func catchPhoto(){
        let actionSheetAlert = UIAlertController(title: NSLocalizedString("Add photo", comment: "Add photo"), message: nil, preferredStyle: .actionSheet)
        actionSheetAlert.popoverPresentationController?.sourceView = self.view
        actionSheetAlert.popoverPresentationController?.sourceRect = self.view.bounds
        
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

    @objc func addLocation(){
        
        let mapVC = MapViewController(latitude: note?.latitude ?? 0.0, longitude: note?.longitude ?? 0.0)
        
        mapVC.delegate = self
        
        let navController = UINavigationController(rootViewController: mapVC)
                
        present(navController, animated: true, completion: nil)
    }
    
    @objc func addTags(){
        let tagsVC = TagsViewController()
        let navController = UINavigationController(rootViewController: tagsVC)
        
        present(navController, animated: true, completion: nil)
    }
    
    @objc  func selectNotebook(){
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
    
    
    @objc func handleSave(){
        if note == nil {
            createNote()
        }else{
            saveNoteChanges()
        }
    }
    
    @objc override func handleCancel(){
        dismiss(animated: false, completion: nil)
    }
    
    @objc func createNote(){
        guard let name = nameTextView.text else {
            let alertController = UIAlertController(title: "Nombre vacia", message: "Inserte un nombre", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let textDate = dateTextView.text else { let alertController = UIAlertController(title: "Fecha vacia", message: "Inserte una fecha", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let text = noteTextView.text else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        
        guard let noteDate = dateFormatter.date(from: textDate) else {
            let alertDateFormatController = UIAlertController(title: "Fecha incorrecta", message: "Inserte formato dd/MM/yyyy", preferredStyle: .alert)
            alertDateFormatController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertDateFormatController, animated: true, completion: nil)
            return
        }
        
        guard let notebook = notebook else { return }
        
        let dataTuple = CoreDataManager.shared.CreateNote(name: name, noteDate: noteDate, noteText: text, latitude: note?.latitude ?? 0.0, longitude: note?.longitude ?? 0.0, notebook: notebook)
        if let error = dataTuple.1 {
            print(error)
        }else{
            //Save Photos
            if (photosCI.count > 0 ){
                savePhotos(note: note!, photosCI: photosCI)
            }
            
            dismiss(animated: true){
                self.delegate?.didAddNote(note: (dataTuple.0)!)
            }
        }
    }
    
    private func saveNoteChanges(){
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        guard let name = nameTextView.text else {
            let alertController = UIAlertController(title: "Nombre vacia", message: "Inserte un nombre", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let textDate = dateTextView.text else {
            let alertController = UIAlertController(title: "Fecha vacia", message: "Inserte una fecha", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        guard let text = noteTextView.text else { return }
                
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
        //already informed by delegate -> note?.mapDirection = direction
        
        //Save Photos
        if (photosCI.count > 0 ){
            savePhotos(note: note!, photosCI: photosCI)
        }
        
        do{
            try context.save()
            
            dismiss(animated: true){
                self.delegate?.didEditNote(note: self.note!)
            }
        } catch let saveErr {
            print("Failed to save note:", saveErr)
        }
    }
    
    func savePhotos(note: Note, photosCI: [CustomImageView]){
//        let context = CoreDataManager.shared.persistentContainer.viewContext
        photos?.removeAll()
        
        for element in photosCI {
            print("Item: \(element)")
            var image = NSData()
            
            if let photoinData = element.imageView.image {
                if let imageData = UIImageJPEGRepresentation(photoinData, 0.8){
                    let dataTuple = CoreDataManager.shared.createPhoto(image: imageData, posX: element.posX, posY: element.posY, note: note)
                    if let error = dataTuple.1 {
                        print(error)
                    }else{
                        photos?.append(dataTuple.0!)
                    }
                }
            }
        }
    }
    
}

extension NoteViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //Create the image
            customImage = CustomImageView(view: noteTextView, image: image, posX: 10, posY: 10, rotation: 0, scale: 1.0)
            customImage.setupUIStyle()
//            customImage.image = image
            photosCI.append(customImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
