//
//  Item.swift
//  Todoey
//
//  Created by Tian Xiang Leong on 13/05/19.
//  Copyright © 2019 Tian Xiang Leong. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    //properties of Item:
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    //to define the backward relationship:
    // each item has a relationship to the parent category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    //fromType - the destination that it links to
    //property - the name of the inverse relationship
}
