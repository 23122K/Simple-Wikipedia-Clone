//
//  Page+CoreDataProperties.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 13/05/2023.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var content: String?
    public var unwrappedContent: String {
        return content ?? "Failed to load content"
    }
    
    @NSManaged public var title: String?
    public var unwrappedTitle: String {
        return title ?? "Failed to load title"
    }

}

extension Page : Identifiable {

}
