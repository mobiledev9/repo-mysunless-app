//
//  CategoryReportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 13/04/22.
//

import UIKit
import Alamofire

class CategoryReportVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var vw_summary: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblCategoryReport : UITableView!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblSellingPrice: UILabel!
    @IBOutlet var lblCostPrice: UILabel!
    @IBOutlet var lblPayableTax: UILabel!
    @IBOutlet var lblNetProfitLoss: UILabel!
    @IBOutlet var vw_Main: UIView!
    @IBOutlet var vw_filter: UIView!
    
    var arrCategoryReport = [CategoryReport]()
    var arrFilterCategoryReport = [CategoryReport]()
    var searching = false
    var token = String()
    var arrSellingPrice = [Double]()
    var arrCostPrice = [Int]()
    var arrTax = [Double]()
    var arrProfitLoss = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        tblCategoryReport.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callviewCategorySaleReportAPI()
    }
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 8.0
        vw_filter.layer.cornerRadius = 8.0
        vw_Main.layer.borderWidth = 1.0
        vw_Main.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Main.layer.cornerRadius = 10.0
        searchBar.delegate = self
    }
    
    func setProductSummaryData() {
        lblQuantity.text = "\(arrCategoryReport.count)"
        lblSellingPrice.text = "$" + String(arrSellingPrice.reduce(0) { $0 + (Double($1)) })
        lblCostPrice.text = "$" + String(arrCostPrice.reduce(0) { $0 + (Double($1)) })
        lblPayableTax.text = "$" + String(arrTax.reduce(0) { $0 + (Double($1)) })
        lblNetProfitLoss.text = "$" + String(arrProfitLoss.reduce(0) { $0 + (Double($1) ?? 0.00) })
    }
    
    func callviewCategorySaleReportAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CATEGORY_REPORT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrCategoryReport.removeAll()
                            self.arrFilterCategoryReport.removeAll()
                            for dict in response {
                                self.arrCategoryReport.append(CategoryReport(dictionary: dict)!)
                            }
                            for dic in self.arrCategoryReport {
                                self.arrSellingPrice.append(dic.productFianlPrice ?? 0.00)
                                self.arrCostPrice.append(dic.cost_Price ?? 0)
                                self.arrTax.append(dic.productTax ?? 0.00)
                                self.arrProfitLoss.append(dic.profit ?? "")
                            }
                            self.arrFilterCategoryReport = self.arrCategoryReport
                            self.setProductSummaryData()
                            DispatchQueue.main.async {
                                self.tblCategoryReport.reloadData()
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
        arrFilterCategoryReport = arrCategoryReport.filter({ (categoryReport: CategoryReport) -> Bool in
            let category = categoryReport.category
            let Category = category?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let brand = categoryReport.brand
            let Brand = brand?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let quantity = "\(categoryReport.quantity ?? 0)"
            let Quantity = quantity.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let salesPrice = "$" + (categoryReport.productFianlPrice?.description ?? "")
            let SalesPrice = salesPrice.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let costPrice = "$" + "\(categoryReport.cost_Price ?? 0)"
            let CostPrice = costPrice.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let tax = categoryReport.productTax?.description
            let Tax = tax?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let profit = "$" + (categoryReport.profit ?? "")
            let Profit = profit.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Category != nil || Brand != nil || Quantity != nil || SalesPrice != nil || CostPrice != nil || Tax != nil || Profit != nil
        })
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
    }       
}

//MARK:- TableView Delegate and Datasource Methods
extension CategoryReportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterCategoryReport.count
        } else {
            return arrCategoryReport.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategoryReport.dequeueReusableCell(withIdentifier: "CategoryReportCell", for: indexPath) as! CategoryReportCell
        if searching {
            cell.model = arrFilterCategoryReport[indexPath.row]
        } else {
            cell.model = arrCategoryReport[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        return cell
    }
}

extension CategoryReportVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension CategoryReportVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterCategoryReport = arrCategoryReport
            }
            tblCategoryReport.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblCategoryReport.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}
