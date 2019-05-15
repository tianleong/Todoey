//
//  Category.swift
//  Todoey
//
//  Created by Tian Xiang Leong on 13/05/19.
//  Copyright © 2019 Tian Xiang Leong. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    //holds a list of Item objects. Initialised as an empty list.
    //this defines the forward relationship i.e. inside each Category there's a thing called items that will point to a list of Item objects.
    let items = List<Item>()
    //each Category can have a number of items (i.e. a List of Item objects.

}
