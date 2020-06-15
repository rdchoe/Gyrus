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
    func categoryCreated()
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
        let saveButton = UIButton(type: .system)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(Constants.categoryBottomSheet.backgroundColor, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: Constants.font.futura, size: Constants.font.h6)
        saveButton.titleLabel?.textAlignment = .center
        saveButton.backgroundColor = Constants.categoryBottomSheet.inactiveColor
        saveButton.isUserInteractionEnabled = true
        saveButton.layer.cornerRadius = 18.0
        return saveButton
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
    
    private let verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.alignment = .center
        verticalStackView.spacing = 16
        verticalStackView.backgroundColor = UIColor.clear
        
        return verticalStackView
    }()
    
    private var saveButtonColorActive: Bool = false
    private var originalFrame: CGRect!
    private var keyboardHeight: CGFloat?
    
    var delegate: CreateCategoryBottomSheetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
    }
    
    private func setupViewController() {
        self.view.backgroundColor = Constants.categoryBottomSheet.backgroundColor
        self.view.addSubview(verticalStackView)
        
        // Emoji picker view setup
        self.emojiPickerView.addSubview(emoji)
        self.emojiPickerView.addSubview(emojiPickerEditButton)
        emojiPickerEditButton.addTarget(self, action: #selector(editEmojiButtonClicked), for: .touchUpInside)
        emoji.delegate = self
        self.view.addSubview(titleLabel)
        self.view.addSubview(emojiPickerView)
        self.view.addSubview(categoryNameField)
        self.view.addSubview(saveButton)
        self.view.addSubview(cancelButton)
        layoutConstraints()
        
        // Interactive Targets
        categoryNameField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        cancelButton.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        // Handling keyboard showing
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func layoutConstraints() {
        let views : [String:Any] = ["titleLabel": self.titleLabel, "categoryNameField":self.categoryNameField, "saveButton":self.saveButton, "cancelButton":self.cancelButton, "emojiPickerView":self.emojiPickerView, "emoji":self.emoji, "emojiPickerEditButton":self.emojiPickerEditButton]
        
        ["H:|-[titleLabel]-|",
         "H:[emojiPickerView(75)]",
         "H:|-[categoryNameField]-|",
         "H:|-[saveButton]-|",
         "H:|-[cancelButton]-|",
         "H:|-[emoji]-|",
         "V:|-[emoji]-|",
         "V:|-8-[titleLabel]-[emojiPickerView(75)]-16-[categoryNameField]-16-[saveButton]-8-[cancelButton]"
            ].forEach{NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: nil, views: views))}
        NSLayoutConstraint.activate([
            /*
            self.verticalStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
             */
            self.titleLabel.heightAnchor.constraint(equalToConstant: 50),
            self.categoryNameField.heightAnchor.constraint(equalToConstant: 50),
            self.saveButton.heightAnchor.constraint(equalToConstant: 35),
            self.cancelButton.heightAnchor.constraint(equalToConstant: 50),
            self.emojiPickerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), // centers the emoji picker view
            self.emojiPickerEditButton.trailingAnchor.constraint(equalTo: emojiPickerView.trailingAnchor, constant: 8),
            self.emojiPickerEditButton.bottomAnchor.constraint(equalTo: emojiPickerView.bottomAnchor, constant: 8)
            
        ])
    }
    
    // MARK: Interactive Targets
    // Dismisses the bottom sheet view controller
    @objc private func cancelClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Saves the created category to core data. Should do input validation before saving to core data
    @objc private func saveButtonClicked() {
        if emoji.text?.count == 0 || categoryNameField.text?.count == 0 {
            return
        } else { // Verfies that both emoji and category name has been entered
            AppDelegate.appCoreDateManager.addCategory(name: categoryNameField.text!, emoji: emoji.text!)
            self.delegate?.categoryCreated()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func textFieldDidChange() {
        guard let text = self.categoryNameField.text else { return }
        if text.count > 0 {
            if (!self.saveButtonColorActive) {
                self.saveButton.backgroundColor = Constants.categoryBottomSheet.activeColor
                self.saveButtonColorActive = true
            }
        } else {
            self.saveButton.backgroundColor = Constants.categoryBottomSheet.inactiveColor
            self.saveButtonColorActive = false
        }
    }
    
    @objc private func editEmojiButtonClicked() {
        self.emoji.becomeFirstResponder()
    }
    @objc private func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            var newYOrigin: CGFloat = 0
            if (self.originalFrame == nil) {
                self.originalFrame = self.view.frame
            }
            if endFrameY < UIScreen.main.bounds.size.height {
                if self.keyboardHeight == nil  {
                    self.keyboardHeight = endFrame!.height
                }
                newYOrigin = self.originalFrame.origin.y - self.keyboardHeight!
            } else {
                newYOrigin = self.originalFrame.origin.y
            }
            
            let currFrame = self.view.frame
            UIView.animate(withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: {
                self.view.frame = CGRect(x: currFrame.origin.x, y: newYOrigin, width: currFrame.size.width, height: currFrame.size.height)
             self.view.layoutIfNeeded()
             },
            completion: nil)
        }
    }
    
}

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
