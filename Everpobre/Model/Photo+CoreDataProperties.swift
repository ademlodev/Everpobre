//
//  Photo+CoreDataProperties.swift
//  Everpobre
//
//  Created by Javi on 22/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var posX: Float
    @NSManaged public var posY: Float
    @NSManaged public var rotation: Float
    @NSManaged public var scale: Float
    @NSManaged public var note: Note?

}
