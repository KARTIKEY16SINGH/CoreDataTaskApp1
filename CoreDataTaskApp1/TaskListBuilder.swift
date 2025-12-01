//
//  TaskListBuilder.swift
//  CoreDataTaskApp1
//
//  Created by Iron Man on 29/11/25.
//

import UIKit

struct TaskListBuilder {
    func build()  -> UIViewController {
        let repository = TaskListLocalRepository(persistentStorage: PersistentStorage.shared)
        let viewModel = TaskListViewModel(reducer: TaskListStateReducer(), repository: repository)
        let viewController = TaskListViewController()
        viewController.build(with: viewModel)
        return viewController
    }
}
