//
//  UIApplication.swift
//  Podcast
//
//  Created by Seif Yousry on 11/23/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController () -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}

