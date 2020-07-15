//
//  GyrusCreateCategoryBottomSheetViewController.swift
//  Gyrus
//
//  Created by Robert Choe on 6/11/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import Foundation
import UIKit

protocol CreateCategoryBottomSheetDelegate {
    func categoryCreated(category: Category)
}

class GyrusCreateCategoryBottomSheetViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: Constants.font.futura, size: Constants.font.h4)
        titleLabel.textColor = Constants.colors.whiteTextColor
        titleLabel.text = "Create Category"
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let categoryNameField: UITextField = {
        let categoryNameField = UITextField()
        categoryNameField.translatesAutoresizingMaskIntoConstraints = false
        categoryNameField.backgroundColor = Constants.categoryBottomSheet.nameFieldBackgroundColor
        categoryNameField.layer.cornerRadius = 12.0
        categoryNameField.layer.borderColor = Constants.categoryBottomSheet.borderColor.cgColor
        categoryNameField.layer.borderWidth = 2.0
        categoryNameField.font = UIFont(name: Constants.font.futura, size: Constants.font.h6)
        categoryNameField.attributedPlaceholder = NSAttributedString(string: "Enter Category Name", attributes: [NSAttributedString.Key.foregroundColor : Constants.colors.gray])
        categoryNameField.textColor = Constants.colors.whiteTextColor
        categoryNameField.textAlignment = .center
        return categoryNameField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Constants.colors.lightGray
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont(name: Constants.font.futura, size: Constants.font.body)
        button.setTitleColor(Constants.colors.white, for: .normal)
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(Constants.categoryBottomSheet.activeColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: Constants.font.futura, size: Constants.font.h6)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.isUserInteractionEnabled = true
        cancelButton.backgroundColor = UIColor.clear
        
        return cancelButton
    }()
    
    
    /// CUSTOM EMOJI PICKER VIEW
    
    private let emojiPickerView: UIView = {
        let emojiPickerView = UIView()
        emojiPickerView.translatesAutoresizingMaskIntoConstraints = false
        emojiPickerView.backgroundColor = Constants.categoryBottomSheet.emojiPickerBackgroundColor
        emojiPickerView.layer.cornerRadius = 12.0
        return emojiPickerView
    }()
    
    private let emoji: EmojiTextField = {
        let emoji = EmojiTextField()
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.font = UIFont(name: Constants.font.futura, size: 50)
        emoji.text = "🌥"
        emoji.textAlignment = .center
        emoji.smartInsertDeleteType = .no
        return emoji
    }()
    
    private let emojiPickerEditButton: UIButton = {
        let emojiPickerEditButton = UIButton(type: .system)
        emojiPickerEditButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        emojiPickerEditButton.translatesAutoresizingMaskIntoConstraints = false
        emojiPickerEditButton.backgroundColor = Constants.colors.white
        emojiPickerEditButton.layer.cornerRadius = emojiPickerEditButton.frame.size.width / 2
        emojiPickerEditButton.setImage(#imageLiteral(resourceName: "pencil"), for: .normal)
        emojiPickerEditButton.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        emojiPickerEditButton.tintColor = UIColor.black
        return emojiPickerEditButton
    }()
    
    private var saveButtonColorActive: Bool = false
    private var originalFrame: CGRect!
    
    var delegate: CreateCategoryBottomSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
    }
    
    private func setupViewController() {
        view.setGradientBackground(colorOne: #colorLiteral(red: 0.08831106871, green: 0.09370639175, blue: 0.1314730048, alpha: 1), colorTwo: #colorLiteral(red: 0.09751460701, green: 0.1287023127, blue: 0.1586345732, alpha: 1))
        setupNavBar()
        addSubviews()
        layoutConstraints()
        
        // Interactive Targets
        categoryNameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        emojiPickerEditButton.addTarget(self, action: #selector(editEmojiButtonClicked), for: .touchUpInside)
        emoji.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    fileprivate func setupNavBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonClicked))
        self.title = "Create Category"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back" , style: .plain, target: self, action: #selector(backButtonClicked))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.gray, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.body)!], for: .normal)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.gray, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.body)!], for: .normal)
    }
    
    fileprivate func addSubviews() {
        self.emojiPickerView.addSubview(emoji)
        self.emojiPickerView.addSubview(emojiPickerEditButton)
        self.view.addSubview(emojiPickerView)
        self.view.addSubview(categoryNameField)
        self.view.addSubview(saveButton)
    }
    private func layoutConstraints() {
        let marginGuide = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            self.emojiPickerView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 36),
            self.emojiPickerView.widthAnchor.constraint(equalToConstant: 75),
            self.emojiPickerView.heightAnchor.constraint(equalToConstant: 75),
            self.emojiPickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emoji.centerXAnchor.constraint(equalTo: emojiPickerView.centerXAnchor),
            self.emoji.centerYAnchor.constraint(equalTo: emojiPickerView.centerYAnchor),
            self.emojiPickerEditButton.trailingAnchor.constraint(equalTo: emojiPickerView.trailingAnchor, constant: 8),
            self.emojiPickerEditButton.bottomAnchor.constraint(equalTo: emojiPickerView.bottomAnchor, constant: 8),
            self.categoryNameField.topAnchor.constraint(equalTo: emojiPickerView.bottomAnchor, constant: 16),
            self.categoryNameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.categoryNameField.heightAnchor.constraint(equalToConstant: 50),
            self.categoryNameField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            self.categoryNameField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            self.saveButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8),
            self.saveButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.saveButton.heightAnchor.constraint(equalToConstant: 40),
            self.saveButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}

// MARK: Text Field Delegate
/// Handling only one character allowed for emoji picker
extension GyrusCreateCategoryBottomSheetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let emojiTextFieldText = self.emoji.text, let rangeOfTextToReplace = Range(range, in: emojiTextFieldText) else {
            return false
        }
        let substringToReplace = emojiTextFieldText[rangeOfTextToReplace]
        let count = emojiTextFieldText.count - substringToReplace.count + string.count
        return count <= 1
    }
}

// MARK: Targets
extension GyrusCreateCategoryBottomSheetViewController {
    
    @objc fileprivate func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func editEmojiButtonClicked() {
        self.emoji.becomeFirstResponder()
    }
    
    // Saves the created category to core data. Should do input validation before saving to core data
    @objc private func saveButtonClicked() {
        if emoji.text?.count == 0 || categoryNameField.text?.count == 0 {
            return
        } else { // Verfies that both emoji and category name has been entered
            AppDelegate.appCoreDateManager.addCategory(name: categoryNameField.text!, emoji: emoji.text!)
            let category = AppDelegate.appCoreDateManager.fetchCategory(byName: categoryNameField.text!)
            self.navigationController?.popViewController(animated: true)
            self.delegate?.categoryCreated(category: category!)
        }
    }
    
    @objc private func textFieldDidChange() {
           guard let text = self.categoryNameField.text else { return }
           if text.count > 0 {
               if (!self.saveButtonColorActive) {
                   self.saveButton.backgroundColor = Constants.categoryBottomSheet.activeColor
                   self.saveButtonColorActive = true
                self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.activeColor, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.body)!], for: .normal)
               }
           } else {
               self.saveButton.backgroundColor = Constants.categoryBottomSheet.inactiveColor
               self.saveButtonColorActive = false
            self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.colors.inactiveColor, NSAttributedString.Key.font: UIFont(name: Constants.font.futura, size: Constants.font.body)!], for: .normal)
           }
       }
}
