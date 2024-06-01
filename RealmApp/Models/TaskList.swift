//
//  TaskList.swift
//  RealmApp
//
//  Created by Alexander Ilyk on 20.05.2024.
//  Copyright © 2024 Alexander Ilyk. All rights reserved.
//

import RealmSwift

class TaskList: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var tasks = List<Task>()
}

class Task: Object {
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var isComplete = false
}
