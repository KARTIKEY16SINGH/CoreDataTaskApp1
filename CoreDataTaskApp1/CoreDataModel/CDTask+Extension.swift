//
//  CDTask+Extension.swift
//  CoreDataTaskApp1
//
//  Created by Iron Man on 29/11/25.
//

extension CDTask {
    func convertToTaskListInfoModel() -> TaskListInfoModel {
        .init(id: id, title: title)
    }
}
