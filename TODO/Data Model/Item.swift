//
//  Item.swift
//  TODO
//
//  Created by José Antonio Fernández Sandá on 22/01/2019.
//  Copyright © 2019 José Antonio Fernández Sandá. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
