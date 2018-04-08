//
//  UINavigationBar+Extensions.swift
//  Appella Health
//
//  Created by F.Q. on 28.03.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        let deviceInfo = DeviceInfo()
        switch deviceInfo {
        case .iPhoneX:
            updatedFrame.size.height += 44
        default:
            updatedFrame.size.height += 20
        }
        
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
        shadowImage = UIImage()
    }
}
