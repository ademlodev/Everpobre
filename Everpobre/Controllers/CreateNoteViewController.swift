//
//  CreateNoteViewController.swift
//  Everpobre
//
//  Created by Javi on 1/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController{
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    let nameTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints  = false
        return textView
    }()
    
    let notebookLabel: UILabel = {
        let label = UILabel()
        label.text = "Notebook"
        label.translatesAutoresizingMaskIntoConstraints  = false
        return label
    }()
    let dateTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints  = false
        return textView
    }()
}
