//
//  CDTask+CoreDataProperties.swift
//  CoreDataTaskApp1
//
//  Created by Iron Man on 29/11/25.
//
//

public import Foundation
public import CoreData


public typealias CDTaskCoreDataPropertiesSet = NSSet

extension CDTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTask> {
        return NSFetchRequest<CDTask>(entityName: "CDTask")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String

}

extension CDTask : Identifiable {

}
