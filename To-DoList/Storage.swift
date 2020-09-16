//
//  Storage.swift
//  To-DoList
//
//  Created by Viktor Golubenkov on 26.08.2020.
//  Copyright © 2020 Viktor Golubenkov. All rights reserved.
//

import Foundation

class TasksStorage {
    let title: String
    let description: String
    let notification: Date
    
    init(title: String, description: String, notification: Date) {
        self.title = title
        self.description = description
        self.notification = notification
    }
    
    
}


