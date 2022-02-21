//
//  CheckView.swift
//  ToDoList
//
//  Created by Vadim Aleshin on 21.02.2022.
//

import UIKit

protocol CheckViewDelegate: AnyObject {
    func flagChange(_ flag: Bool)
}

class CheckView: UIControl {
    weak var delegate: CheckViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        changeStyle()
        
        self.addTarget(
            self,
            action: #selector(changeFlag),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var done: Bool? {
        get { flag }
        set { flag = newValue ?? false }
    }
    
    private let imageView: UIImageView = makeImageView()
    private var flag = false {
        didSet {
            changeStyle()
        }
    }
    
    func changeStyle() {
        switch flag {
        case true:
            self.layer.borderWidth = 0
            imageView.isHidden = false
            self.backgroundColor = Color.buttonRedColor
        case false:
            self.layer.borderWidth = 2
            imageView.isHidden = true
            self.backgroundColor = nil
        }
    }
    
    @objc private func changeFlag(_ sender: UIControl) {
        flag = !flag
        self.delegate?.flagChange(self.flag)

    }
    
}

// MARK: - Setup UI

extension CheckView {
    private func setupUI() {
        self.layer.borderColor = Color.buttonRedColor?.cgColor
        self.layer.cornerRadius = 5
        
        self.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

// MARK: - Factory

extension CheckView {
    private static func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = Image.image
        view.tintColor = Color.backgroundColor
        return view
    }
}

// MARK: - Const

extension CheckView {
    struct Color {
        static let backgroundColor = UIColor(named: "BackgroundColor")
        static let buttonRedColor = UIColor(named: "Red")
    }
    struct Image {
        static let image = UIImage(systemName: "checkmark")
    }
}
