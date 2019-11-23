//
//  String.swift
//  Podcast
//
//  Created by Seif Yousry on 11/11/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import Foundation

extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
