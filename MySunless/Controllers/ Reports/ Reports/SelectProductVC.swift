//
//  SelectProductVC.swift
//  MySunless
//
//  Created by iMac on 28/02/22.
//

import UIKit
import Alamofire
import SCLAlertView

class SelectProductVC: UIViewController {

    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblProduct: UITableView!
    
    var token = String()
    var arrViewProduct = [ViewProduct]()
    var arrFilterViewProduct = [ViewProduct]()
    var searching = false
    var modelProduct = ViewProduct(dictionary: [:])
    var arrSelectedProductIds = [String]()
    var delegate: AddOrderProtocol?
    var arrAddedProductIds = [String]()
    var alertTitle = String()
    var arrAddedProductTitle = [String]()
    var arrCartListProduct = [CartList]()
//    var arrFinalIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblProduct.tableFooterView = UIView()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callViewProductAPI()
    }
    
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        searchBar.delegate = self
    }
    
//    func showAlertForProductIdExist() {
//        let alert = SCLAlertView()
//        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
//
//        })
//        alert.iconTintColor = UIColor.white
//        alert.showSuccess("", subTitle: alertTitle)
//    }
    
    func callViewProductAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + VIEW_PRODUCT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrViewProduct.removeAll()
                            self.arrFilterViewProduct.removeAll()
                            for dict in response {
                                self.arrViewProduct.append(ViewProduct(dictionary: dict)!)
                            }
                            self.arrFilterViewProduct = self.arrViewProduct
                            DispatchQueue.main.async {
                                self.tblProduct.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrViewProduct.removeAll()
                            self.arrFilterViewProduct.removeAll()
                            self.tblProduct.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterViewProduct = arrViewProduct.filter({ (product: ViewProduct) -> Bool in
            let barcode = product.barcode
            let Barcode = barcode?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let name = product.productTitle
            let Name = name?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let sellingPrice = "$\(product.sellingPrice ?? 0)"
            let SellingPrice = sellingPrice.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let salestax = product.sales_tax ?? "0" + "%"
            let SalesTax = salestax.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let qty = "\(product.noofPorduct ?? 0)"
            let Qty = qty.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Barcode != nil || Name != nil || SellingPrice != nil || SalesTax != nil || Qty != nil
        })
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAddToCartClick(_ sender: UIButton) {
        if arrSelectedProductIds.count != 0 {
            delegate?.callOrderProductAPI(productIds: arrSelectedProductIds.joined(separator: ","), arrSelectedProductIds: arrSelectedProductIds)
        } else {
            AppData.sharedInstance.showAlert(title: "Alert", message: "Please select product", viewController: self)
        }
    }
    
    @IBAction func btnManageProductClick(_ sender: UIButton) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let storyBoard = UIStoryboard(name:"Main", bundle: nil)
        if let conVC = storyBoard.instantiateViewController(withIdentifier: "ProductsListVC") as? ProductsListVC,
           let navController = window?.rootViewController as? UINavigationController {
            self.dismiss(animated: true, completion: nil)
            navController.pushViewController(conVC, animated: true)
        }
    }
    
}

extension SelectProductVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterViewProduct.count
        } else {
            return arrViewProduct.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProduct.dequeueReusableCell(withIdentifier: "SelectProductCell", for: indexPath) as! SelectProductCell
        
        if searching {
            cell.modelProduct = arrFilterViewProduct[indexPath.row]
        } else {
            cell.modelProduct = arrViewProduct[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.parent = self
        return cell
    }
    
}

extension SelectProductVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK:- SearchBar Delegate Methods
extension SelectProductVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterViewProduct = arrViewProduct
            }
            tblProduct.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblProduct.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
