//
//  ProductsListVC.swift
//  MySunless
//
//  Created by DaydreamSoft on 28/03/22.
//

import UIKit
import Alamofire

protocol ProductListProtocol {
    func UpdateProdStatusAPI(productId: Int)
    func editProduct(barcode: String)
    func viewProduct(productId: Int)
    func callDeleteProductAPI(productId: Int)
}

class ProductsListVC: UIViewController {

    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblProductList: UITableView!
    @IBOutlet var btnFilter: UIButton!
    
    var token = String()
    var arrShowProducts = [ShowProducts]()
    var arrFilterShowProducts = [ShowProducts]()
    var searching = false
    var salesTax = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        tblProductList.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        tblProductList.refreshControl = UIRefreshControl()
        tblProductList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowProductsAPI()
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 12
        btnFilter.layer.cornerRadius = 12
        searchBar.delegate = self
    }
    
    func callShowProductsAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SHOW_PRODUCTS, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrShowProducts.removeAll()
                            self.arrFilterShowProducts.removeAll()
                            for dict in response {
                                self.arrShowProducts.append(ShowProducts(dictionary: dict)!)
                            }
                            self.arrFilterShowProducts = self.arrShowProducts
                            DispatchQueue.main.async {
                                self.tblProductList.reloadData()
                            }
                        }
                        if let sales_tax = res.value(forKey: "sales_tax") as? String {
                            self.salesTax = sales_tax
                        }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterShowProducts = arrShowProducts.filter({ (productList: ShowProducts) -> Bool in
            let price = "$" + "\(productList.sellingPrice ?? 0)"
            let Price = price.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let title = productList.productTitle
            let Title = title?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let stock = "\(productList.noofPorduct ?? 0)"
            let Stock = stock.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let productTitle = productList.productTitle
            let ProductTitle = productTitle?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let barcode = productList.barcode
            let Barcode = barcode?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let category = productList.category
            let Category = category?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let brand = productList.brand
            let Brand = brand?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let desc = productList.productDescription
            let Desc = desc?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let cost = "$" + "\(productList.companyCost ?? 0)"
            let Cost = cost.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Price != nil || Title != nil || Stock != nil || ProductTitle != nil || Barcode != nil || Category != nil || Brand != nil || Desc != nil || Cost != nil
        })
    }
    
    @IBAction func btnAddProductClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductBarcodeVC") as! ProductBarcodeVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnManageProductCategoryClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductCategoryListVC") as! ProductCategoryListVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnAddProductBrandClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductBrandListVC") as! ProductBrandListVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        
    }
    
    @objc func callPullToRefresh(){
        DispatchQueue.main.async {
            self.callShowProductsAPI()
            self.tblProductList.refreshControl?.endRefreshing()
            self.tblProductList.reloadData()
        }
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension ProductsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterShowProducts.count
        } else {
            return arrShowProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProductList.dequeueReusableCell(withIdentifier: "ProductsListCell", for: indexPath) as! ProductsListCell
        if searching {
            cell.model = arrFilterShowProducts[indexPath.row]
        } else {
            cell.model = arrShowProducts[indexPath.row]
        }
        cell.setCell(index: indexPath.row, salesTax: salesTax)
        cell.delegate = self
        return cell
    }
}

extension ProductsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ProductsListVC: ProductListProtocol {
    func UpdateProdStatusAPI(productId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["id": productId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + UPDATE_PROD_STATUS, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                            self.callShowProductsAPI()
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
    
    func editProduct(barcode: String) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductVC") as! AddProductVC
        VC.barcode = barcode
        VC.tittle = "Update Product"
        VC.isEdit = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func viewProduct(productId: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        VC.productId = productId
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func callDeleteProductAPI(productId: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["id": productId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DELETE_PRODUCT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                            self.callShowProductsAPI()
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                        }
                    }
                }
            }
        }
    }
}

//MARK:- SearchBar Delegate Methods
extension ProductsListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterShowProducts = arrShowProducts
            }
            tblProductList.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblProductList.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
