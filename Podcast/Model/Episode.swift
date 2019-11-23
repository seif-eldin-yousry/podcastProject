//
//  Episode.swift
//  Podcast
//
//  Created by Seif Yousry on 11/11/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import Foundation
import FeedKit


struct Episode {
    var title : String
    var pubDate : Date
    var description : String
    var imageUrl : String?
    let author: String
    let streamUrl: String
    
    init(feedItem: RSSFeedItem) {
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    }
    
    
}
