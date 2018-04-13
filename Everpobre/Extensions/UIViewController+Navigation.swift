//
//  UIViewController+Navigation.swift
//  Everpobre
//
//  Created by Javi on 24/3/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import UIKit

extension UIViewController{
    func wrappedInNavigation() -> UINavigationController{
        return UINavigationController(rootViewController: self)
    }
    
    func setupCancelNavigation(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
}
