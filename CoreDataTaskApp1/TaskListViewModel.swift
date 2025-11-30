//
//  TaskListViewModel.swift
//  CoreDataTaskApp1
//
//  Created by Iron Man on 29/11/25.
//

import UIKit

protocol TaskListViewModelable {
    var view: TaskListViewable? {get set}
    func performAction(_ action: TaskListActions)
    func getNumberOfItems() -> Int
    func getItem(forRow row: Int) -> TaskListInfoModel?
}

final class TaskListViewModel {
    weak var view: TaskListViewable?
    private let reducer: TaskListStateReduceable
    private var state: TaskListState
    private let repository: TaskListBaseRepository
    
    init(reducer: TaskListStateReduceable, repository: TaskListBaseRepository) {
        self.reducer = reducer
        self.repository = repository
        state = TaskListState()
    }
    
    private func handleStateUpdate() {
        switch state.status {
        case .viewLoaded, .taskCreated:
            guard let data = repository.getTask() else {
                performAction(.dataError)
                return
            }
            state.dataSource = data
            performAction(.dataReceived)
        case .dataReceived:
            view?.dataDidUpdate()
        case .dataError:
            var taskList = [TaskListInfoModel]()
            for task in 1...3 {
                let taskInfo = TaskListInfoModel(id: UUID(), title: "Task \(task)")
                taskList.append(taskInfo)
            }
            state.dataSource = TaskListModel(tasks: taskList)
            performAction(.dataReceived)
        case .clickedAddButton:
            view?.onAddButtonClicked()
        case .addNewTask(let text):
            let task = TaskListInfoModel(id: UUID(), title: text)
            repository.addTask(task: task)
            performAction(.newTaskCreated)
        default:
            break
        }
    }
}

extension TaskListViewModel: TaskListViewModelable {
    func getNumberOfItems() -> Int {
        state.dataSource?.tasks.count ?? 0
    }
    
    func getItem(forRow row: Int) -> TaskListInfoModel? {
        guard let items = state.dataSource?.tasks, row >= 0 && row < items.count else {
            return nil
        }
        return items[row]
    }
    
    func performAction(_ action: TaskListActions) {
        state = reducer.updateState(state: state, action: action)
        handleStateUpdate()
    }
}


enum TaskListActions {
    case viewLoaded
    case dataReceived
    case dataError
    case addButtonClicked
    case addTask(String?)
    case newTaskCreated
}

