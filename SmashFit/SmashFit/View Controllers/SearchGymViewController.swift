//
//  PickGymViewController.swift
//  SmashFit
//
//  Created by Kudryatzhan Arziyev on 2/8/18.
//  Copyright © 2018 Kudryatzhan Arziyev. All rights reserved.
//

import UIKit
import Firebase

protocol GymCellDelegate: class {
    func gymWasSelectedWithName(_ name: String)
}

class SearchGymViewController: UIViewController, UISearchResultsUpdating {
 
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    weak var delegate: GymCellDelegate?
    
    // Search Controller
    var searchController: UISearchController!
    var searchResults: [String] = []
    var allGymsSorted: [String] {
        return allGymsList.sorted()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // search controller set up
        searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController?.isActive = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        // search bar customization
        searchController.searchBar.placeholder = "Find your gym..."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = #colorLiteral(red: 0.738317728, green: 0.08215675503, blue: 0.08656511456, alpha: 1)
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    // MARK: - Helper methods
    func filterContent(for searchText: String) {
    
        searchResults = allGymsSorted.filter({ (gym) -> Bool in
            let isMatch = gym.localizedCaseInsensitiveContains(searchText)
            return isMatch
        })

    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchGymViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return allGymsSorted.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GymCell", for: indexPath)
        
        // Determine if we get the gym from search result or the original array
        let gym = (searchController.isActive) ? searchResults[indexPath.row] : allGymsSorted[indexPath.row]
        
        // Configure the cell...
        cell.textLabel?.text = gym
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gym = (searchController.isActive) ? searchResults[indexPath.row] : allGymsSorted[indexPath.row]
        delegate?.gymWasSelectedWithName(gym)
        self.navigationController?.popViewController(animated: true)
    }
}

