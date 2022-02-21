//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Vadim Aleshin on 21.02.2022.
//

import UIKit

protocol AddOrChangeTaskViewControllerDelegate: AnyObject {
    func saveData(_ title: String?, _ description: String?)
    func changeData(_ title: String?, _ description: String?, _ indexPath: IndexPath)
}

class AddOrChangeTaskViewController: UIViewController {
    weak var delegate: AddOrChangeTaskViewControllerDelegate?

    init(style: StyleVC) {
        self.styleVC = style
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        switch styleVC {
        case .add:
            buttonSave.addTarget(
                self,
                action: #selector(buttonActionAdd),
                for: .touchUpInside
            )
        case .change:
            buttonSave.addTarget(
                self,
                action: #selector(buttonActionChange),
                for: .touchUpInside
            )
            guard let taskCell = cellTask else { return }
            titleField.text = taskCell.task.title
            descriptionField.text = taskCell.task.description
            //buttonSave.isHidden = true
        }
    }
    
    var task: CellTask? {
        get { cellTask }
        set { cellTask = newValue }
    }
    var indexPath: IndexPath? {
        get { cellIndexPath }
        set { cellIndexPath = newValue }
    }
    
    private let titleLabel: UILabel = makeTitleLabel()
    private let descriptionLabel: UILabel = makeDescriptionLabel()
    private let titleField: UITextField = makeTextField()
    private let descriptionField: UITextField = makeTextField()
    private let buttonSave: UIButton = makeButtonSave()
    private var styleVC: StyleVC
    private var cellTask: CellTask?
    private var cellIndexPath: IndexPath?

    @objc private func buttonActionChange(_ sender: UIButton) {
        guard let indexCell = indexPath else { return }
        if titleField.text == "" {
            return
        }
        print("Change")
        self.delegate?.changeData(titleField.text, descriptionField.text, indexCell)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func buttonActionAdd(_ sender: UIButton) {
        if titleField.text == "" {
            return
        }
        print("Save")
        self.delegate?.saveData(titleField.text, descriptionField.text)
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Setup UI

extension AddOrChangeTaskViewController {
    private func setupUI() {
        view.backgroundColor = Color.backgroundColor
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(titleField)
        view.addSubview(descriptionField)
        view.addSubview(buttonSave)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        titleField.translatesAutoresizingMaskIntoConstraints = false
        descriptionField.translatesAutoresizingMaskIntoConstraints = false
        buttonSave.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            titleField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            titleField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            titleField.heightAnchor.constraint(equalToConstant: 150),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 10),
            descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            descriptionField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            descriptionField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            descriptionField.heightAnchor.constraint(equalToConstant: 150),
            
            buttonSave.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 10),
            buttonSave.rightAnchor.constraint(equalTo: view.rightAnchor),
            buttonSave.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
    }
}

// MARK: - Factory

extension AddOrChangeTaskViewController {
    private static func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Title"
        return label
    }
    
    private static func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Description"
        return label
    }
    
    private static func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.contentVerticalAlignment = .top
        textField.borderStyle = .roundedRect
        textField.placeholder = "Please enter relevant information"
        textField.backgroundColor = Color.backgroundColor
        return textField
    }
    
    private static func makeButtonSave() -> UIButton {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }
    
}

extension AddOrChangeTaskViewController {
    struct Color {
        static let backgroundColor = UIColor(named: "BackgroundColor")
        static let buttonRedColor = UIColor(named: "Red")
    }
}
