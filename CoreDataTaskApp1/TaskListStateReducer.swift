//
//  TaskListStateReducer.swift
//  CoreDataTaskApp1
//
//  Created by Iron Man on 29/11/25.
//

import Foundation

enum TaskListStateStatus {
    case unknown
    case viewLoaded
    case dataReceived
    case dataLoading
    case dataError
    case clickedAddButton
    case addNewTask(String)
    case taskCreated
    case deleteRow(Int)
}

protocol TaskListStateReduceable {
    func updateState(state: TaskListState, action: TaskListActions) -> TaskListState
}


struct TaskListStateReducer: TaskListStateReduceable {
    func updateState(state: TaskListState, action: TaskListActions) -> TaskListState {
        var state = state
        switch action {
        case .viewLoaded:
            state.status = .viewLoaded
        case .dataReceived:
            state.status = .dataReceived
        case .dataError:
            state.status = .dataError
        case .addButtonClicked:
            state.status = .clickedAddButton
        case .addTask(let optionalText):
            guard let text = optionalText else {
                state.status = .unknown
                break
            }
            state.status = .addNewTask(text)
        case .newTaskCreated:
            state.status = .taskCreated
        case .delete(row: let row):
            state.status = .deleteRow(row)
        }
        return state
    }
}

struct TaskListState {
    var status: TaskListStateStatus = .unknown
    var dataSource: TaskListModel? = nil
}
