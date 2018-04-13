//
//  TagsViewController.swift
//  Everpobre
//
//  Created by Javi on 6/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

class TagsViewController: UIViewController{

    var textInput : UITextField = {
       let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "verdana", size: 12.0)
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.gray.cgColor
        text.layer.cornerRadius = 1
        return text
    }()
    let addTagsButton : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Add Tag", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.tintColor = UIColor.black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 0.5
        button.addTarget(self, action: #selector(addTag(_:)), for: .touchUpInside)
        return button
    }()
    let contentTagsView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    var tagsArray:[String] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupUIStyle()
        
        createTagCloud(OnView: contentTagsView, withArray: tagsArray as [AnyObject])
        
        setupCancelNavigation()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    func SetupUIStyle(){
        view.addSubview(textInput)
        view.addSubview(addTagsButton)
        view.addSubview(contentTagsView)
        
        NSLayoutConstraint.activate([
                textInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                textInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                textInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                textInput.heightAnchor.constraint(equalToConstant: 50),
                
                addTagsButton.topAnchor.constraint(equalTo: textInput.bottomAnchor),
                addTagsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.5),
                addTagsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                addTagsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                addTagsButton.heightAnchor.constraint(equalToConstant: 50),
            
                contentTagsView.topAnchor.constraint(equalTo: addTagsButton.bottomAnchor),
                contentTagsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                contentTagsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                contentTagsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func createTagCloud(OnView view: UIView, withArray data:[AnyObject]) {
        
        for tempView in view.subviews {
            if tempView.tag != 0 {
                tempView.removeFromSuperview()
            }
        }
        
        var xPos: CGFloat = 15.0
        var ypos: CGFloat = 15.0
        var tag: Int = 1
        for str in data  {
            let startstring = str as! String
            let width = startstring.widthOfString(usingFont: UIFont(name:"verdana", size: 12.0)!)
            let checkWholeWidth = CGFloat(xPos) + CGFloat(width) + CGFloat(13.0) + CGFloat(25.5 )//13.0 is the width between lable and cross button and 25.5 is cross button width and gap to righht
            if checkWholeWidth > UIScreen.main.bounds.size.width - 30.0 {
                
                xPos = 15.0
                ypos = ypos + 29.0 + 8.0
            }
            
            let bgView = UIView(frame: CGRect(x: xPos, y: ypos, width:width + 17.0 + 38.5 , height: 29.0))
            bgView.layer.cornerRadius = 14.5
            bgView.backgroundColor = UIColor(red: 33.0/255.0, green: 135.0/255.0, blue:199.0/255.0, alpha: 1.0)
            bgView.tag = tag
            
            let textlable = UILabel(frame: CGRect(x: 17.0, y: 0.0, width: width, height: bgView.frame.size.height))
            textlable.font = UIFont(name: "verdana", size: 12.0)
            textlable.text = startstring
            textlable.textColor = UIColor.white
            bgView.addSubview(textlable)
            
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: bgView.frame.size.width - 2.5 - 23.0, y: 3.0, width: 23.0, height: 23.0)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = CGFloat(button.frame.size.width)/CGFloat(2.0)
            button.setImage(UIImage(named: "CrossWithoutCircle"), for: .normal)
            button.tag = tag
            button.addTarget(self, action: #selector(removeTag), for: .touchUpInside)
            bgView.addSubview(button)
            xPos = CGFloat(xPos) + CGFloat(width) + CGFloat(17.0) + CGFloat(43.0)
            view.addSubview(bgView)
            tag = tag  + 1
        }
        
    }
    
    @objc func removeTag(_ sender: AnyObject) {
        tagsArray.remove(at: (sender.tag - 1))
        createTagCloud(OnView: contentTagsView, withArray: tagsArray as [AnyObject])
    }
    
    @IBAction func addTag(_ sender: AnyObject) {
        
        if textInput.text?.count != 0 {
            tagsArray.append(textInput.text!)
            createTagCloud(OnView: contentTagsView, withArray: tagsArray as [AnyObject])
            textInput.text? = ""
        }
    }
    
    @objc func handleSave(){
        print("Saving Map")
        //        if notebook == nil {
        //            CreateNotebook()
        //        }else{
        //            saveNotebookChanges()
        //        }
    }
}

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}

