//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Vadim Aleshin on 21.02.2022.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func flagChange(_ flag: Bool, _ indexPath: IndexPath?)
}

class TaskTableViewCell: UITableViewCell {
    weak var delegate: TaskTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        checkView.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var text: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var done: Bool? {
        get { checkView.done }
        set { checkView.done = newValue }
    }
    var indexPath: IndexPath? {
        get { cellIndexPath }
        set { cellIndexPath = newValue }
    }
    
    private let checkView = CheckView()
    private let titleLabel: UILabel = UILabel()
    private var cellIndexPath: IndexPath?
    
}

// MARK: - Setup UI

extension TaskTableViewCell {
    private func setupUI() {
        self.backgroundColor = UIColor(named: "BackgroundColor")
        self.selectionStyle = .none
        
        self.contentView.addSubview(checkView)
        self.contentView.addSubview(titleLabel)
        
        checkView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            checkView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            checkView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            checkView.widthAnchor.constraint(equalToConstant: self.frame.height - 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: checkView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: checkView.rightAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        ])
    }
}

extension TaskTableViewCell: CheckViewDelegate {
    func flagChange(_ flag: Bool) {
        self.delegate?.flagChange(flag, indexPath)
    }
}
