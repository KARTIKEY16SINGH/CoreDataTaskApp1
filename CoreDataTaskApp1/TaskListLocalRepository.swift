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
    func deleteTask(with id: UUID)
    func getTask(with id: UUID) -> CDTask?
}

struct TaskListLocalRepository: TaskListBaseRepository {
    
    private let persistentStorage: PersistentStorageable
    
    private var context: NSManagedObjectContext {
        persistentStorage.privateContext
    }
    
    init(persistentStorage: PersistentStorageable) {
        self.persistentStorage = persistentStorage
    }
    
    func getTask() -> TaskListModel? {
        do {
            let result = try context.fetch(CDTask.fetchRequest())
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
        let newTask = CDTask(context: context)
        newTask.id = task.id
        newTask.title = task.title
        
        persistentStorage.saveContext()
    }
    
    func deleteTask(with id: UUID) {
        guard let task = getTask(with: id) else { return }
        context.delete(task)
        persistentStorage.saveContext()
    }
    
    func getTask(with id: UUID) -> CDTask? {
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)
        let fetchRequest = CDTask.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            guard let result = try context.fetch(fetchRequest).first else {
                return nil
            }
            return result
        } catch {
            debugPrint("Delete Error -> \(error)")
        }
        return nil
    }
}
