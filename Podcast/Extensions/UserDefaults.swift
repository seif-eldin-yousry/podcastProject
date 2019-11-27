//
//  UserDefaults.swift
//  Podcast
//
//  Created by Seif Yousry on 11/25/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    static let favoritedPodcastsKey = "favoritedPodcastsKey"
    static let downloadedEpisodesKey = "downloadedEpisodesKey"
    
    func downloadEpisode(episode: Episode) {
        do {
            var episodes = downloadedEpisodes()
            episodes.append(episode)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeErr {
            print("failed to encode ",encodeErr)
        }
    }
    
    func downloadedEpisodes () -> [Episode] {
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodesKey) else { return []}
        
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: episodesData)
            return episodes
        } catch let decodableErr{
            print("Failed to decode ", decodableErr)
        }
        return []
    }
    
    func deleteEpisode(episode: Episode){
        let episodes = downloadedEpisodes()
        let filteredEpisodes = episodes.filter { (e) -> Bool in
            return e.title != episode.title
        }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: filteredEpisodes, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let err {
            print(err)
        }
        
    }
    
    
    func savedPodcasts() -> [Podcast] {
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastsKey) else { return [] }
        var savedPodcasts: [Podcast] = []
        do {
            savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData) as? [Podcast] ?? []
            
            return savedPodcasts
        } catch let err {
            print(err)
        }
        return savedPodcasts
    }
    
    func deletePodcast(podcast: Podcast){
        let podcasts = savedPodcasts()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastsKey)
        } catch let err {
            print(err)
        }
        
    }
}
