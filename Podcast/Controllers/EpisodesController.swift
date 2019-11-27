//
//  EpisodesController.swift
//  Podcast
//
//  Created by Seif Yousry on 11/9/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import UIKit
import FeedKit


class EpisodesContoller: UITableViewController {
    
    var podcast : Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        guard let feedUrl = podcast?.feedUrl else { return }
        
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate let cellId = "CellId"
    
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBarButtons()
    }
    
    let favoritedPodcastKey = ""
    
    fileprivate func setupNavigationBarButtons() {
        
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        let hasFavorited = savedPodcasts.firstIndex(where: {$0.trackName == self.podcast?.trackName && $0.artistName == self.podcast?.artistName}) != nil
//        savedPodcasts.inde
        
        if hasFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite))
//                ,UIBarButtonItem(title: "fetch", style: .plain, target: self, action: #selector(handleFetchFavorite))
            ]
        }
        
    }
    
    @objc fileprivate func handleFetchFavorite () {
        //retrieving data from userDefaults
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastsKey) else { return }
        do {
            let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Podcast]
            savedPodcasts?.forEach({ (p) in
                print(p.trackName ?? "")
            })
        } catch let err {
            print(err)
        }
    }
    
    @objc fileprivate func handleSaveFavorite () {
        guard let podcast =  self.podcast else { return }
        
        //fetch saved podcasts
//        guard let savedPodcastsData = UserDefaults.standard.data(forKey: favoritedPodcastKey) else { return }
//        do {
//            guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData) as? [Podcast] else { return }
//            var listOfPodcasts = savedPodcasts
//            listOfPodcasts.append(podcast)
//            do {
//                let dataa = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
//                UserDefaults.standard.set(dataa, forKey: favoritedPodcastKey)
//            } catch let err {
//                print(err)
//            }
//        } catch let err {
//            print(err)
//        }
        
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
        do {
            let dataa = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(dataa, forKey: UserDefaults.favoritedPodcastsKey)
        } catch let err {
            print(err)
        }
        showBadgeHighlight()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: nil, action: nil)
    }
    
    fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = "New"
    }
    
    //MARK:- Setup TableView
    
    fileprivate func setupTableView () {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let downloadAction = UITableViewRowAction(style: .normal, title: "Downloads") { (_, _) in
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode: episode)
            self.showDownloadsHighlight()
            
            //Downloading the episode using Alamofire
            
        }
        
        return [downloadAction]
    }
    
    fileprivate func showDownloadsHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = "New"
    }
    
    //loading sign while fetching episode
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        
        let mainTabController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabController?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
        
        
//
//        let window = UIApplication.shared.keyWindow
//
//        let playerDetailsView = PlayerDetailsView.initFromNib()
//        playerDetailsView.episode = episode
//        playerDetailsView.frame = self.view.frame
//        window?.addSubview(playerDetailsView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}






