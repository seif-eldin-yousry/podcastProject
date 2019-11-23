//
//  Podcast.swift
//  Podcast
//
//  Created by Seif Yousry on 11/7/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
