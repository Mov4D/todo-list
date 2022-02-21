//
//  TaskModel.swift
//  ToDoList
//
//  Created by Vadim Aleshin on 21.02.2022.
//

import Foundation

struct Task: Codable {
    let title: String
    let description: String
}

struct CellTask: Codable {
    let task: Task
    var done: Bool
}

enum StyleVC {
    case add
    case change
}
