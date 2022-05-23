//
//  ProductDetailVC.swift
//  MySunless
//
//  Created by Daydream Soft on 14/04/22.
//

import UIKit
import Alamofire

class ProductDetailVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var vw_summary: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblProductDetail : UITableView!
    @IBOutlet var vw_BtnExport: UIView!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblSellingPrice: UILabel!
    @IBOutlet var lblCostPrice: UILabel!
    @IBOutlet var lblPayableTax: UILabel!
    @IBOutlet var lblNetProfitLoss: UILabel!
    @IBOutlet var vw_Main: UIView!
    
    @IBOutlet var imgProduct: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet var lblProductPrice: UILabel!
    @IBOutlet var lblProductTax: UILabel!
    @IBOutlet var lblProductCost: UILabel!
    @IBOutlet var lblProductBarcode: UILabel!
    @IBOutlet var lblProductCategory: UILabel!
    @IBOutlet var lblProductBrand: UILabel!
    @IBOutlet var lblProductStock: UILabel!
    @IBOutlet var lblProductDescription: UILabel!
    
    var productId = Int()
    var token = String()
    var arrProductReport = [ProductReport]()
    var arrFilterProductReport = [ProductReport]()
    var searching = false
    var arrSellingPrice = [String]()
    var arrCostPrice = [String]()
    var arrTax = [String]()
    var arrProfitLoss = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        tblProductDetail.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
//        tblProductList.refreshControl = UIRefreshControl()
//        tblProductList.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callviewProductSaleReportAPI()
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 5.0
        searchBar.delegate = self
    }
    
    func setProductSummaryData() {
        lblQuantity.text = "\(arrProductReport.count)"
        lblSellingPrice.text = "$" + String(arrSellingPrice.reduce(0) { $0 + (Double($1) ?? .zero) })
        lblCostPrice.text = "$" + String(arrCostPrice.reduce(0) { $0 + (Double($1) ?? .zero) })
        lblPayableTax.text = "$" + String(arrTax.reduce(0) { $0 + (Double($1) ?? .zero) })
        lblNetProfitLoss.text = "$" + String(arrProfitLoss.reduce(0) { $0 + (Double($1) ?? .zero) })
    }
    
    func callviewProductSaleReportAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = ["product": productId]
        if(APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + PRODUCT_REPORT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrProductReport.removeAll()
                            self.arrFilterProductReport.removeAll()
                            for dict in response {
                                self.arrProductReport.append(ProductReport(dictionary: dict)!)
                            }
                            for dic in self.arrProductReport {
                                self.arrSellingPrice.append(dic.productFianlPrice ?? "")
                                self.arrCostPrice.append(dic.productCostPrice ?? "")
                                self.arrTax.append(dic.productTaxPrice ?? "")
                                self.arrProfitLoss.append(dic.profit ?? "")
                                self.lblProductName.text = dic.productTitle
                                self.lblProductPrice.text = "$\(dic.sellingPrice ?? 0)"
                                self.lblProductTax.text = (dic.sales_tax ?? "") + " " + "TAX"
                                self.lblProductCost.text = "$\(dic.companyCost ?? 0)"
                                self.lblProductBarcode.text = dic.barcode
                                self.lblProductCategory.text = dic.category
                                self.lblProductBrand.text = dic.brand
                                self.lblProductStock.text = "\(dic.noofPorduct ?? 0) Left"
                                self.lblProductDescription.text = dic.productDescription
                            }
                            self.arrFilterProductReport = self.arrProductReport
                            self.setProductSummaryData()
                            
                            DispatchQueue.main.async {
                                self.tblProductDetail.reloadData()
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
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterProductReport = arrProductReport.filter({ (productReport: ProductReport) -> Bool in
            let username = productReport.username
            let Username = username?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let custname = productReport.custname
            let Custname = custname?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let invoiceNumber = productReport.invoiceNumber
            let InvoiceNumber = invoiceNumber?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let prodcutQuality = productReport.prodcutQuality
            let ProdcutQuality = prodcutQuality?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            var orderdate = productReport.orderTime
            orderdate?.removeLast(11)
            let Orderdate = orderdate?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let sellPrice = "$" + (productReport.productFianlPrice ?? "")
            let SellPrice = sellPrice.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let costPrice = "$" + (productReport.productCostPrice ?? "")
            let CostPrice = costPrice.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let profitLoss = "$" + (productReport.profit ?? "")
            let ProfitLoss = profitLoss.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
//            let tax = "$" + (productReport.productTaxPrice ?? "")
//            let Tax = tax.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Username != nil || Custname != nil || InvoiceNumber != nil || ProdcutQuality != nil || Orderdate != nil || SellPrice != nil || CostPrice != nil || ProfitLoss != nil
        })
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension ProductDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterProductReport.count
        } else {
            return arrProductReport.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProductDetail.dequeueReusableCell(withIdentifier: "ProductDetailCell", for: indexPath) as! ProductDetailCell
        if searching {
            cell.model = arrFilterProductReport[indexPath.row]
        } else {
            cell.model = arrProductReport[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        return cell
    }
}

extension ProductDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

//MARK:- SearchBar Delegate Methods
extension ProductDetailVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterProductReport = arrProductReport
            }
            tblProductDetail.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblProductDetail.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

