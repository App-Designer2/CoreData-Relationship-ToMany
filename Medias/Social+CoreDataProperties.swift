//
//  Social+CoreDataProperties.swift
//  Medias
//
//  Created by App Designer2 on 03.02.22.
//
//

import Foundation
import CoreData


extension Social {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Social> {
        return NSFetchRequest<Social>(entityName: "Social")
    }

    @NSManaged public var about: String?
    @NSManaged public var avatar: Data?
    @NSManaged public var comentario: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var imageD: Data?
    @NSManaged public var name: String?
    @NSManaged public var socialToComment: Set<Comment>?
    @NSManaged public var socialToMedia: Media?

    public var comment: [Comment] {
        let setComment = socialToComment
        return setComment!.sorted {
            $0.id > $1.id
        }
    }
}

// MARK: Generated accessors for socialToComment
extension Social {

    @objc(addSocialToCommentObject:)
    @NSManaged public func addToSocialToComment(_ value: Comment)

    @objc(removeSocialToCommentObject:)
    @NSManaged public func removeFromSocialToComment(_ value: Comment)

    @objc(addSocialToComment:)
    @NSManaged public func addToSocialToComment(_ values: NSSet)

    @objc(removeSocialToComment:)
    @NSManaged public func removeFromSocialToComment(_ values: NSSet)

}

extension Social : Identifiable {

}
