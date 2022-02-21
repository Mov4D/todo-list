//
//  ViewController.swift
//  ToDoList
//
//  Created by Vadim Aleshin on 21.02.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "taskCell")
        
        setupUI()
        
        buttonAddTask.addTarget(
            self,
            action: #selector(buttonAction),
            for: .touchUpInside
        )
        
        DispatchQueue.global().async { [weak self] in
            guard let tasks = TaskCachService.tasks else { return }
            self?.taskArray = tasks
        }
        tableView.reloadData()
    }
    
    
    private let buttonAddTask: UIButton = makeButtonAddTask()
    private let tableView: UITableView = UITableView()
    private var taskArray: [CellTask] = [] {
        didSet {
            DispatchQueue.global().sync {
                TaskCachService.tasks = self.taskArray
            }
        }
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        print("Tap button")
        let vc = AddOrChangeTaskViewController(style: .add)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - Delegate & DataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskTableViewCell
        else { return UITableViewCell() }
        
        cell.text = taskArray[indexPath.row].task.title
        cell.done = taskArray[indexPath.row].done
        cell.indexPath = indexPath
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddOrChangeTaskViewController(style: .change)
        vc.task = taskArray[indexPath.row]
        vc.indexPath = indexPath
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController: AddOrChangeTaskViewControllerDelegate {
    func changeData(_ title: String?, _ description: String?, _ indexPath: IndexPath) {
        let task = Task(
            title: title ?? "",
            description: description ?? ""
        )
        let cellTask = CellTask(
            task: task,
            done: false
        )
        self.taskArray[indexPath.row] = cellTask
                
        tableView.reloadData()
    }
    
    func saveData(_ title: String?, _ description: String?) {
        let task = Task(
            title: title ?? "",
            description: description ?? ""
        )
        let cellTask = CellTask(
            task: task,
            done: false
        )
        self.taskArray.append(cellTask)
        
        tableView.reloadData()
    }
}

extension ViewController: TaskTableViewCellDelegate {
    func flagChange(_ flag: Bool, _ indexPath: IndexPath?) {
        guard let index = indexPath else { return }
        taskArray[index.row].done = flag
    }
}

// MARK: - Setup UI

extension ViewController {
    private func setupUI() {
        view.backgroundColor = Color.backgroundColor
        tableView.backgroundColor = Color.backgroundColor
        
        view.addSubview(buttonAddTask)
        view.addSubview(tableView)
        
        buttonAddTask.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonAddTask.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
            buttonAddTask.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            buttonAddTask.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            buttonAddTask.heightAnchor.constraint(equalToConstant: 50),
            
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: buttonAddTask.bottomAnchor, constant: 10),
        ])
    }
}

// MARK: - Factory

extension ViewController {
    private static func makeButtonAddTask() -> UIButton {
        let button = UIButton()
        button.setTitle("Add task", for: .normal)
        button.setTitleColor(
            Color.buttonRedColor,
            for: .normal
        )
        button.backgroundColor = Color.backgroundColor
        
        button.layer.borderColor = Color.buttonRedColor?.cgColor
        button.layer.borderWidth = 3
        
        button.layer.cornerRadius = 10
        
        return button
    }
}

extension ViewController {
    struct Color {
        static let backgroundColor = UIColor(named: "BackgroundColor")
        static let buttonRedColor = UIColor(named: "Red")
    }
}
