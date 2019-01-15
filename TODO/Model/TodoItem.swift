//
//  TodoItem.swift
//  TODO
//
//  Created by José Antonio Fernández Sandá on 14/01/2019.
//  Copyright © 2019 José Antonio Fernández Sandá. All rights reserved.
//

import Foundation

class TodoItem: Codable {
    var title: String
    var done: Bool
    
    init(_ title:String, _ done:Bool) {
        self.title = title
        self.done = done
    }
    
}
