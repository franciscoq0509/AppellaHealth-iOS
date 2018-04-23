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
            break
        }
        
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        switch deviceInfo {
        case .iPhoneX:
            gradientLayer.locations = [0.3, 1.0]
        default:
            gradientLayer.locations = [0.3, 0.8]
        }
        
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
        shadowImage = UIImage()
    }
}
