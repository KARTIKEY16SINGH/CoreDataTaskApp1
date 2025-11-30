//
//  TaskListLocalRepository.swift
//  CoreDataTaskApp1
//
//  Created by Iron Man on 29/11/25.
//

internal import CoreData

protocol TaskListBaseRepository {
    func getTask() -> TaskListModel?
    func addTask(task: TaskListInfoModel)
}

struct TaskListLocalRepository: TaskListBaseRepository {
    
    private let persistentStorage: PersistentStorageable
    
    init(persistentStorage: PersistentStorageable) {
        self.persistentStorage = persistentStorage
    }
    
    func getTask() -> TaskListModel? {
        do {
            let result = try persistentStorage.context.fetch(CDTask.fetchRequest())
            guard !result.isEmpty else {
                return nil
            }
            let taskList = result.compactMap { $0.convertToTaskListInfoModel() }
            return TaskListModel(tasks: taskList)
        } catch {
            debugPrint(error)
        }
        return nil
    }
    
    func addTask(task: TaskListInfoModel) {
        let newTask = CDTask(context: persistentStorage.context)
        newTask.id = task.id
        newTask.title = task.title
        
        persistentStorage.saveContext()
    }
}
