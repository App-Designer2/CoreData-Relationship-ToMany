//
//  Comment+CoreDataProperties.swift
//  Medias
//
//  Created by App Designer2 on 03.02.22.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var comment: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var liked: Bool
    @NSManaged public var commentToMedia: Media?
    @NSManaged public var commentToSocial: Social?

}

extension Comment : Identifiable {

}
