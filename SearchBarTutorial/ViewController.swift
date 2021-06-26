//
//  ViewController.swift
//  SearchBarTutorial
//
//  Created by Mesut Aygün on 26.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let countries = Country.GetAllCountries()
    var filteredCountries = [Country]()
    
    
    lazy var tableview : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.register(CountryCell.self, forCellReuseIdentifier: "cell")
        return tv
        
    }()
    
    lazy var searchController : UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search..."
        search.searchBar.sizeToFit()
        search.searchBar.searchBarStyle = .prominent
        search.searchBar.scopeButtonTitles = ["All","Europe","Asia","Africa"]
        search.searchBar.delegate = self
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.searchController = searchController
        setupElements()
    }
    
func filterContentForSearchText(searchText : String , scope : String = "All") {
    filteredCountries = countries.filter({ (country : Country)-> Bool in
        let doesCategoryMatch = (scope == "All") || (country.continent == scope)
        
        if searchBarEmpty()  {
            return doesCategoryMatch
        }else{
            return doesCategoryMatch && country.title.lowercased().contains(searchText.lowercased())
        }
    })
    tableview.reloadData()
}
    
    func searchBarEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarEmpty() || searchBarScopeIsFiltering)
    }

}

extension ViewController : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){return filteredCountries.count }
        return countries.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CountryCell else {
            return UITableViewCell() }
        
        let currentCountry : Country
        
        if isFiltering() {
            currentCountry = filteredCountries[indexPath.row]
        }else{
            currentCountry = countries[indexPath.row]
        }
        cell.titleLbl.text = currentCountry.title
        cell.categoryLbl.text = currentCountry.continent
        return cell
        }
        
    }

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        
    }
}

extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text! , scope: scope)
    }
    
    
}
    
extension ViewController {
    func setupElements() {
        view.addSubview(tableview)
        
        tableview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}


