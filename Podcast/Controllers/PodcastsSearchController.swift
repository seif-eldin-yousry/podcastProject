//
//  PodcastsSearchController.swift
//  Podcast
//
//  Created by Seif Yousry on 11/7/19.
//  Copyright © 2019 Seif Yousry. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    var podcasts = [Podcast]()
    
    let cellID = "CellID"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
        
    }
    
    //MARK:- Setup work
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            APIService.shared.fetchPodcast(searchText: searchText) { (podcasts) in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
            //implementing alamofire to search iTunes API
            //let url = "https://itunes.apple.com/search?term=\(searchText)"
        })   
    }
    
    
    
    fileprivate func setupTableView() {
        
        tableView.tableFooterView = UIView()
        
        //Register cell for tableview
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    //MARK:- UITableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episodesController = EpisodesContoller()
        let podcast = self.podcasts[indexPath.row]
        episodesController.podcast = podcast
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Search for Podcasts"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.podcasts.count > 0 ? 0 : 250
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
        
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
        
        
//        cell.textLabel?.text = "\(podcasts[indexPath.row].trackName ?? "")\n\(podcasts[indexPath.row].artistName ?? "")"
//        cell.textLabel?.numberOfLines = -1
//        cell.imageView?.image = UIImage(named: "appicon")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
}
