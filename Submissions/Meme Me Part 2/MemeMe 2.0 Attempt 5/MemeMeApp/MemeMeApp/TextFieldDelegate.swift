//
//  TextFieldDelegate.swift
//  MemeMeApp
//
//  Created by Douglas Cooper on 10/15/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import UIKit

class textFieldDelegate: NSObject, UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
