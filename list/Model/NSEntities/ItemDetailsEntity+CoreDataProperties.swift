//
//  ItemDetailsEntity+CoreDataProperties.swift
//  list
//
//  Created by student on 18.12.2024.
//
//

import Foundation
import CoreData


extension ItemDetailsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemDetailsEntity> {
        return NSFetchRequest<ItemDetailsEntity>(entityName: "ItemDetailsData")
    }

    @NSManaged public var abilities: String?
    @NSManaged public var entityId: String?
    @NSManaged public var height: String?
    @NSManaged public var name: String?
    @NSManaged public var sprites: String?
    @NSManaged public var stats: String?
    @NSManaged public var types: String?
    @NSManaged public var weight: String?

}

extension ItemDetailsEntity : Identifiable {

}
