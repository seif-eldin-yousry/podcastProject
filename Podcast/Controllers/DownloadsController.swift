//
//  DownloadsController.swift
//  Podcast
//
//  Created by Seif Yousry on 11/26/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import UIKit

class DownloadsController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    
    var episodes = UserDefaults.standard.downloadedEpisodes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupObservers()
    }
    
    fileprivate func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
    }
    
    @objc fileprivate func handleDownloadProgress(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        
        guard let progress = userInfo["progress"] as? Double else { return }
        guard let title = userInfo["title"] as? String else { return }
        
        guard let index = self.episodes.firstIndex(where: {$0.title == title}) else { return }
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))  as? EpisodeCell else { return }
        
        cell.progressLabel.text = "\(Int(progress * 100))%"
        cell.progressLabel.isHidden = false
        
        if progress == 1 {
            cell.progressLabel.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
        
    }
    
    //MARK:- Setup
    
    fileprivate func setupTableView() {
        
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellId")
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        
        if episode.fileUrl != nil {
            UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
        } else {
            let alertController = UIAlertController(title: "File URL not found", message: "Can't find local file, play using streamUrl instead", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
            }))
            
            alertController.addAction(UIAlertAction(title: "cancel", style: .cancel))
            
            present(alertController, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        episodes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        UserDefaults.standard.deleteEpisode(episode: episode)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.deleteEpisode(episode: episode)
        }
        
        return [deleteAction]
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! EpisodeCell
        cell.episode = self.episodes[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
