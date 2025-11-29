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
        }
        return state
    }
}

struct TaskListState {
    var status: TaskListStateStatus = .unknown
    var dataSource: TaskListModel? = nil
}
