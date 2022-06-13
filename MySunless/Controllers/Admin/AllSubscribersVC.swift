//
//  AllSubscribersVC.swift
//  MySunless
//
//  Created by Daydream Soft on 11/06/22.
//

import UIKit

class AllSubscribersVC: UIViewController {

    @IBOutlet weak var vw_searchBar: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lblFilterBadge: UILabel!
    @IBOutlet weak var tblSubscribersList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
      //  searchBar.delegate = self
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
    }
    
}

extension AllSubscribersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSubscribersList.dequeueReusableCell(withIdentifier: "SubscriberListCell", for: indexPath) as! SubscriberListCell
        
        return cell
    }
    
    
}

extension AllSubscribersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
