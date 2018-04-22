//
//  Note+CoreDataProperties.swift
//  Everpobre
//
//  Created by Javi on 22/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var created: NSDate?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var text: String?
    @NSManaged public var images: Photo?
    @NSManaged public var notebook: Notebook?

}
