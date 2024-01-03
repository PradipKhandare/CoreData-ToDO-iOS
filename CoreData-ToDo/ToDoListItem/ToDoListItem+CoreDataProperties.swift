//
//  ToDoListItem+CoreDataProperties.swift
//  CoreData-ToDo
//
//  Created by NTS on 03/01/24.
//
//

import Foundation
import CoreData

extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?

}

extension ToDoListItem : Identifiable {

}
