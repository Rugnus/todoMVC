//
//  Task.swift
//  ToDoApp
//
//  Created by Sungur on 27.02.2022.
//

import Foundation

struct Task {
    
    var text: String
    var isComplete: Bool
    
    
}

class Model {
    
    var taskArray: [Task] = [
        Task(text: "Task number 1", isComplete: false),
        Task(text: "Task 2", isComplete: false),
        Task(text: "IM last task", isComplete: true)
    ]
    
    var sort: Bool = true
    var editClicked = false
    
    func changeRow(at item: Int) -> Bool {
        taskArray[item].isComplete = !taskArray[item].isComplete
        return taskArray[item].isComplete
    }
    
    func moveTask(startIndex: Int, endIndex: Int) {
        let startPosition = taskArray[startIndex]
        taskArray.remove(at: startIndex)
        taskArray.insert(startPosition, at: endIndex)
    }
    
    func updateTask(at index: Int, with string: String) {
        taskArray[index].text = string
    }
    
    func addTask(taskName: String, isComplete: Bool = false) {
        taskArray.append(Task(text: taskName, isComplete: false))
    }

    func sortByTitle() {
        taskArray.sort {
            sort ? $0.text < $1.text : $0.text > $1.text
        }
    }
    
    func removeTask(at index: Int) {
        taskArray.remove(at: index)
    }
}
