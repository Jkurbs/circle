//
//  AddressVC.swift
//  Sparen
//
//  Created by Kerby Jean on 2/16/19.
//  Copyright © 2019 Kerby Jean. All rights reserved.
//

import UIKit
import MapKit
import Cartography
import FirebaseAuth

class AddressVC: UIViewController {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var nextButton: UIButton!
    
    var data = [String: Any]()

    
    var label: UILabel!
    var descLabel: UILabel!
    var tableView: UITableView!
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
        label = UICreator.create.label("Enter Your Address", 20, .darkText, .center, .medium, view)
        descLabel = UICreator.create.label("Your address is use for verification purposes.", 15, .lightGray, .center, .regular, view)

        
    
        tableView = UITableView()
        tableView.center = view.center
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        self.view.addSubview(tableView)
        
        searchBar.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.tintColor = .darkText
        searchBar.returnKeyType = .done
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
        tableView.tableHeaderView = searchBar
        
        nextButton = UICreator.create.button("Next", nil, .white, .red, tableView)
        nextButton.isEnabled = true
        nextButton.alpha = 0.0
        nextButton.backgroundColor = UIColor.sparenColor
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        
        
        searchCompleter.delegate = self
        

    }
    
    
    
    @objc func nextStep() {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.activityIndicatorViewStyle = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
        
        DataService.call.RefUsers.child(Auth.auth().currentUser!.uid).child("address").updateChildValues(data) { (error, ref) in
            
            if let err = error {
                print("error", err)
                return
            }
            activityIndicator.stopAnimating()
            self.navigationController?.pushViewController(FirstPaymentVC(), animated: true)            
        }
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        constrain(label, descLabel, tableView, nextButton, view) { (label, descLabel, tableView, nextButton, view) in
            
            label.top == view.top + 200
            label.centerX == view.centerX
            label.width == view.width - 100
            
            descLabel.top == label.bottom + 10
            descLabel.centerX == view.centerX
            descLabel.width == view.width - 50
            
            tableView.top == descLabel.bottom + 20
            tableView.centerX == view.centerX
            tableView.width == view.width - 50
            tableView.height == view.height - 100
            
            nextButton.top == tableView.top + 100
            nextButton.centerX == tableView.centerX
            nextButton.height == 50
            nextButton.width == tableView.width - 40
            
        }
    }
    
}

extension AddressVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, searchText.isEmpty {
            self.searchResults.removeAll()
            self.tableView.reloadData()
        }
        self.nextButton.alpha = 0.0
        searchCompleter.queryFragment = searchText
    }
}

extension AddressVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension AddressVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.backgroundColor = .white
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
}

extension AddressVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            
            if let err = error {
                print("err:", err.localizedDescription)
            } else {
                
                let resp = response?.mapItems[0].placemark
                
                let thoroughfare = resp?.thoroughfare ?? ""
                let subThoroughfare = resp?.subThoroughfare ?? ""
                
                let country = resp?.countryCode
                let state = resp?.administrativeArea
                let line1 = subThoroughfare + " " + thoroughfare
                let postalCode = resp?.postalCode
                let city = resp?.locality
                
                self.label.text = resp?.title ?? ""
                self.searchBar.endEditing(true)
                self.searchBar.text = ""
                self.nextButton.alpha = 1.0
                self.searchResults.removeAll()
                self.tableView.reloadData()
                
                self.data = ["city": city, "country" :country, "line1": line1, "postalCode": postalCode, "state": state]
            }
            
        
            
            
//            let address = ["country": country]
//            print("COORDINATE:", String(describing: coordinate))
        }
    }
}
