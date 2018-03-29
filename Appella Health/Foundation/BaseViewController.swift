//
//  BaseViewController.swift
//  Appella Health
//
//  Created by F.Q. on 26.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

class BaseViewController: UIViewController {
    public var container: Container = SwinjectStoryboard.defaultContainer
}
