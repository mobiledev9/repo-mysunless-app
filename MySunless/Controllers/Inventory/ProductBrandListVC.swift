//
//  ProductBrandListVC.swift
//  MySunless
//
//  Created by Daydream Soft on 30/03/22.
//

import UIKit
import Alamofire
import SCLAlertView
import Kingfisher

@objc protocol ProductBrandListProtocol {
    func callShowProductBrandAPI()
   @objc optional func updateProductBrandList()
    func editBrand(brandId: Int, brandName: String)
    func calldeleteProductBrandAPI(brandId: Int)
}

class ProductBrandListVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblProductBrandList: UITableView!
   
    var token = String()
    var searching = false
    var arrBrandList = [ShowProductBrand]()
    var arrFilterBrandList = [ShowProductBrand]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        tblProductBrandList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        hideKeyboardWhenTappedAround()
        tblProductBrandList.refreshControl = UIRefreshControl()
        tblProductBrandList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
     }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowProductBrandAPI()
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
            self.callShowProductBrandAPI()
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterBrandList = arrBrandList.filter({ (brandList: ShowProductBrand) -> Bool in
            let brand = brandList.Brand
            let Brand = brand.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
           
            return Brand != nil
        })
    }
    
    @objc func callPullToRefresh() {
        DispatchQueue.main.async {
            self.callShowProductBrandAPI()
            self.tblProductBrandList.refreshControl?.endRefreshing()
            self.tblProductBrandList.reloadData()
        }
    }

    @IBAction func btnAddNewBrandClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddBrandVC") as! AddBrandVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.delegateBrand = self
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnAddProductClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductsListVC") as! ProductsListVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
}

//MARK:- TableView Delegate and Datasource Methods
extension ProductBrandListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterBrandList.count
        } else {
            return arrBrandList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProductBrandList.dequeueReusableCell(withIdentifier: "ProductBrandCell", for: indexPath) as! ProductBrandCell
        if searching {
            cell.model = arrFilterBrandList[indexPath.row]
        } else {
            cell.model = arrBrandList[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension ProductBrandListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension ProductBrandListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterBrandList = arrBrandList
            }
            tblProductBrandList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblProductBrandList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
 
extension ProductBrandListVC: ProductBrandListProtocol {
    func updateProductBrandList() {
        callShowProductBrandAPI()
    }
    
    func callShowProductBrandAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PRODUCT_BRAND, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrBrandList.removeAll()
                            self.arrFilterBrandList.removeAll()
                            for dict in response {
                                self.arrBrandList.append(ShowProductBrand(dict: dict))
                            }
                            self.arrFilterBrandList = self.arrBrandList
                            DispatchQueue.main.async {
                                self.tblProductBrandList.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrBrandList.removeAll()
                            self.arrFilterBrandList.removeAll()
                            DispatchQueue.main.async {
                                self.tblProductBrandList.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func editBrand(brandId: Int, brandName: String) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddBrandVC") as! AddBrandVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.delegateBrand = self
        VC.isEdit = true
        VC.brandId = brandId
        VC.brandName = brandName
        self.present(VC, animated: true, completion: nil)
    }
    
    func calldeleteProductBrandAPI(brandId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["brandId": brandId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_PRODUCT_BRAND, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? Int {
                    if success == 1 {
                        if let response = res.value(forKey: "message") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    } else {
                        if let response = res.value(forKey: "message") as? String {
                            self.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
}
