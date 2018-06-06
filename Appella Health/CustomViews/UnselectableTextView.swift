//
//  UnselectableTextView.swift
//  Appella Health
//
//  Created by F.Q. on 26.04.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class UnselectableTextView: UITextView {

    override func becomeFirstResponder() -> Bool {
        return false
    }
}
