//
//  Category.swift
//  TODO
//
//  Created by José Antonio Fernández Sandá on 22/01/2019.
//  Copyright © 2019 José Antonio Fernández Sandá. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item> ()
}
