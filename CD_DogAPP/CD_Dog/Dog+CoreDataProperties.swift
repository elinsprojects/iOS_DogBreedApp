//
//  Dog+CoreDataProperties.swift
//  CD_Dog
//
//  Created by Elin Ellinor Jernstrom on 17/04/2024.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var breed: String?
    @NSManaged public var image: String?
    @NSManaged public var origin: String?
    @NSManaged public var traits: String?
    @NSManaged public var url: String?
    @NSManaged public var isFavourite: Bool

}

extension Dog : Identifiable {

}
