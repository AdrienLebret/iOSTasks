//
//  ReminderEntityClass.swift
//  iOSTasks
//
//  Created by Adrien Lebret on 12/12/2019.
//  Copyright © 2019 if26. All rights reserved.
//

import Foundation

class ReminderEntityClass {
    
    var category:String
    var comment:String
    var completed:Bool
    var deadline:Date
    var rating:String
    var title:String
    var triggerDateTime:Date
    var uuid:String

    init(cat:String, com:String, dea:Date, rat:String, tit:String) {
        self.category = cat
        self.comment = com
        self.deadline = dea
        self.rating = rat
        self.title = tit
        self.triggerDateTime = Date() // to put in comment
        self.uuid = UUID().uuidString
        self.triggerDateTime = Date()
        self.completed = false
    }
}
