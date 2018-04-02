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
}
