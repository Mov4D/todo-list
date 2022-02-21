//
//  TaskCachService.swift
//  ToDoList
//
//  Created by Vadim Aleshin on 21.02.2022.
//

import Foundation

final class TaskCachService {
    
    private enum StringKeys: String {
        case userTasks
    }
    
    static var tasks: [CellTask]? {
        get {
            let key = StringKeys.userTasks.rawValue
            let defaults = UserDefaults.standard
            let decoder = JSONDecoder()
            if let savedPerson = defaults.object(forKey: key) as? Data {
                if let loadedPerson = try? decoder.decode([CellTask].self, from: savedPerson) {
                    return loadedPerson
                }
            }
            return nil
        }
        set {
            let key = StringKeys.userTasks.rawValue
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: key)
            }
        }
    }
    
}
