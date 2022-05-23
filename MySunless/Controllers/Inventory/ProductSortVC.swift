//
//  ProductSortVC.swift
//  MySunless
//
//  Created by Daydream Soft on 30/03/22.
//

import UIKit

class ProductSortVC: UIViewController {
    @IBOutlet var tblProductSortList: UITableView!
    var token = String()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        tblProductSortList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
     }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setInitially() {
        
    }

    @IBAction func btnDoneClick(_ sender: UIButton) {
        
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
           
    }
    
    
}

//MARK:- TableView Delegate and Datasource Methods
extension ProductSortVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProductSortList.dequeueReusableCell(withIdentifier: "ProductSortCell", for: indexPath) as! ProductSortCell
         return cell
    }
}

extension ProductSortVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

 
