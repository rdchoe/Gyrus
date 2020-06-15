//
//  EmojiTextField.swift
//  Gyrus
//
//  Created by Robert Choe on 6/15/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import UIKit

class EmojiTextField: UITextField {
    override var textInputContextIdentifier: String? { "" }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
