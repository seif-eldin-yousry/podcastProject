//
//  APIService.swift
//  Podcast
//
//  Created by Seif Yousry on 11/8/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

extension Notification.Name {
    static let downloadProgress = Notification.Name("downloadProgress")
    static let downloadComplete = Notification.Name("downloadComplete")
}


class APIService {
    
//    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episode.title: String)
    
    //Singleton
    static let shared = APIService()
    
    func downloadEpisode(episode: Episode) {
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            
//            print(progress.fractionCompleted)
            
            //Notify Downloads controller with download progess
            
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": progress.fractionCompleted])
            
            
            }.response { (resp) in
                print(resp.destinationURL?.absoluteString ?? "")
                
//                NotificationCenter.default.post(name: .downloadComplete, object: <#T##Any?#>, userInfo: nil)
                
                //update User Defaults downloaded episodes with the temp file
                
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let index = downloadedEpisodes.firstIndex(where: { $0.title == episode.title && $0.author == episode.author  }) else { return }
                downloadedEpisodes[index].fileUrl = resp.destinationURL?.absoluteString ?? ""
                
                do {
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
                } catch let err {
                    print("failed to encode downloaded episodes with file ", err)
                }
                
        }
        
    }
    
    
    func fetchEpisodes (feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        guard let url = URL(string: secureFeedUrl) else { return }
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { (result) in
                print("Sucessfuly parrsed", result.isSuccess)
                
                switch result {
                case let .rss(feed):
                    
                    let episodes = feed.toEpisodes()
                    completionHandler(episodes)
                    //RSSFeed extension
                    //                self.episodes = feed.toEpisodes()
                    //                DispatchQueue.main.async {
                    //                    self.tableView.reloadData()
                    //                }
                    break
                case let .failure(error):
                    print("Failed to feed", error)
                    break
                    
                default:
                    print("Found feed..")
                }
            }
        }
    }
    
    func fetchPodcast (searchText: String, completionHandler: @escaping ([Podcast]) -> ()) {
        print("Fetching ")
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("failed to connect to iTunes\(err)")
                return
            }
            guard let data = dataResponse.data else {return}
            
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                
                completionHandler(searchResult.results)
//                self.podcasts = searchResult.results
//                self.tableView.reloadData()
                
            } catch let decodeErr {print("Error decoding data", decodeErr) }
        }
    }
    
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
}








