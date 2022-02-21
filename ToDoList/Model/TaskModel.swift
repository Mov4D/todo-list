//
//  TaskModel.swift
//  ToDoList
//
//  Created by Vadim Aleshin on 21.02.2022.
//

import Foundation

struct Task: Codable {
    var title: String
    var description: String
}

struct CellTask: Codable {
    var task: Task
    var done: Bool
}

enum StyleVC {
    case add
    case change
}
