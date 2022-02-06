//
//  Media+CoreDataProperties.swift
//  Medias
//
//  Created by App Designer2 on 30.01.22.
//
//

import Foundation
import CoreData


extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

    @NSManaged public var category: String?
    @NSManaged public var id: UUID?
    @NSManaged public var mediaToSocial: Set<Social>?
    @NSManaged public var mediaToComment: Set<Comment>?

    //Let set the Social and bind it with Media
    public var social: [Social] {
        let setSocial = mediaToSocial
        return setSocial!.sorted {
            $0.id > $1.id
            
            //Now they are in an relationship and can get marrie!!
        }
    }
    //-----------Comment---Relationship--------------
    
    //Let set the Social and bind it with Media
    public var comment: [Comment] {
        let setComment = mediaToComment
        return setComment!.sorted {
            $0.id > $1.id
            
            //Now they are in an relationship and can get marrie!!
        }
    }
}

// MARK: Generated accessors for mediaToSocial
extension Media {

    @objc(addMediaToSocialObject:)
    @NSManaged public func addToMediaToSocial(_ value: Social)

    @objc(removeMediaToSocialObject:)
    @NSManaged public func removeFromMediaToSocial(_ value: Social)

    @objc(addMediaToSocial:)
    @NSManaged public func addToMediaToSocial(_ values: NSSet)

    @objc(removeMediaToSocial:)
    @NSManaged public func removeFromMediaToSocial(_ values: NSSet)

}

// MARK: Generated accessors for mediaToComment
extension Media {

    @objc(addMediaToCommentObject:)
    @NSManaged public func addToMediaToComment(_ value: Comment)

    @objc(removeMediaToCommentObject:)
    @NSManaged public func removeFromMediaToComment(_ value: Comment)

    @objc(addMediaToComment:)
    @NSManaged public func addToMediaToComment(_ values: NSSet)

    @objc(removeMediaToComment:)
    @NSManaged public func removeFromMediaToComment(_ values: NSSet)

}

extension Media : Identifiable {

}
