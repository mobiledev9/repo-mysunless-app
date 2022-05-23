//
//  ProductCategoryListVC.swift
//  MySunless
//
//  Created by Daydream Soft on 30/03/22.
//

import UIKit
import Alamofire
import SCLAlertView

protocol ProductCategoryListProtocol {
    func callEditCatList(catId: Int, catName: String)
    func callDeleteCatListAPI(catId: Int)
    func calllistofprodcatAPI()
}

class ProductCategoryListVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblProductCategoryList: UITableView!
   
    var token = String()
    var searching = false
    var arrCategoryList = [ShowProductCategoryInventory]()
    var arrFilterCategoryList = [ShowProductCategoryInventory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        tblProductCategoryList.tableFooterView = UIView()
        hideKeyboardWhenTappedAround()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblProductCategoryList.refreshControl = UIRefreshControl()
        tblProductCategoryList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        calllistofprodcatAPI()
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        searchBar.delegate = self
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            self.calllistofprodcatAPI()
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterCategoryList = arrCategoryList.filter({ (catList: ShowProductCategoryInventory) -> Bool in
            let category = catList.Category
            let Category = category.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let noOfProduct = "\(catList.pcount)"
            let NoOfProduct = noOfProduct.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Category != nil || NoOfProduct != nil
        })
    }

    @IBAction func btnAddNewCategoryClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductCategoryVC") as! ProductCategoryVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.isFromCatList = true
        VC.delegateCatList = self
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnAddProductClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductsListVC") as! ProductsListVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func callPullToRefresh() {
        DispatchQueue.main.async {
            self.calllistofprodcatAPI()
            self.tblProductCategoryList.refreshControl?.endRefreshing()
            self.tblProductCategoryList.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension ProductCategoryListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterCategoryList.count
        } else {
            return arrCategoryList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProductCategoryList.dequeueReusableCell(withIdentifier: "ProductCategoryCell", for: indexPath) as! ProductCategoryCell
        if searching {
            cell.model = arrFilterCategoryList[indexPath.row]
        } else {
            cell.model = arrCategoryList[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension ProductCategoryListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension ProductCategoryListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterCategoryList = arrCategoryList
            }
            tblProductCategoryList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblProductCategoryList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension ProductCategoryListVC: ProductCategoryListProtocol {
    func calllistofprodcatAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + LIST_OF_PROD_CAT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrCategoryList.removeAll()
                            self.arrFilterCategoryList.removeAll()
                            for dict in response {
                                self.arrCategoryList.append(ShowProductCategoryInventory(dict: dict))
                            }
                            self.arrFilterCategoryList = self.arrCategoryList
                            DispatchQueue.main.async {
                                self.tblProductCategoryList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            print(response)
                        }
                    }
                }
            }
        }
    }
    
    func callEditCatList(catId: Int, catName: String) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductCategoryVC") as! ProductCategoryVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.isEdit = true
        VC.catId = catId
        VC.catName = catName
        VC.delegateCatList = self
        self.present(VC, animated: true, completion: nil)
    }
    
    func callDeleteCatListAPI(catId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["catid": catId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_PRODUCT_CATEGORY, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
}
