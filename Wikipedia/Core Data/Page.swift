//
//  Page+CoreDataClass.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 13/05/2023.
//
//

import Foundation
import CoreData

@objc(Page)
public class Page: NSManagedObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case title
        case content = "extract"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext else {
            throw fatalError("Missing Managed Object Context")
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Page", in: context) else {
            throw fatalError("Missing Entity")
        }
        
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: Page.CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Page.CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
    }
}
