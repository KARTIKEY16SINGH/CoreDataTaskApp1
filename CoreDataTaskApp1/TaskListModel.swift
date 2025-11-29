//
//  TaskListModel.swift
//  CoreDataTaskApp1
//
//  Created by Iron Man on 29/11/25.
//

import Foundation

struct TaskListModel {
    let tasks: [TaskListInfoModel]
}

struct TaskListInfoModel {
    let id: UUID
    let title: String
}


