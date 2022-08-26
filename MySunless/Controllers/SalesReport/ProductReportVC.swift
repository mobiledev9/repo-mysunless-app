//
//  ProductReportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 13/04/22.
//

import UIKit
import Alamofire

protocol FilterSalesReportProtocol {
    func updateSalesReport(ReportDatas : (String,Int)?,
                              userDatas : [(String,String)]?,
                              CustomerDatas:[(String,String)]?,
                              CategoryDatas :(String,Int)?,
                              filterBadgeCount: Int)
}

class ProductReportVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var vw_summary: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblProductReport : UITableView!
    @IBOutlet var vw_BtnFilter: UIView!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblSellingPrice: UILabel!
    @IBOutlet var lblCostPrice: UILabel!
    @IBOutlet var lblPayableTax: UILabel!
    @IBOutlet var lblNetProfitLoss: UILabel!
    @IBOutlet var lblBadgeCount: UILabel!
    @IBOutlet var vw_Main: UIView!
    
    @IBOutlet weak var summaryViewHeight: NSLayoutConstraint!
    var arrProductReport = [ProductReport]()
    var arrFilterProductReport = [ProductReport]()
    var searching = false
    var token = String()
    var arrSellingPrice = [String]()
    var arrCostPrice = [String]()
    var arrTax = [String]()
    var arrProfitLoss = [String]()
    var valSelctedSalesDates : (String,Int) = ("",-1)
    var valSelctedCategory : (String,Int) = ("",-1)
    var arrSelctedCustomers = [(String,String)]()
    var arrSelctedUsers = [(String,String)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitially()
        hideKeyboardWhenTappedAround()
        tblProductReport.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callviewProductSaleReportAPI()
    }
    
    func setInitially() {
        summaryViewHeight.constant = 0
        vw_summary.isHidden = true
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 8.0
        vw_BtnFilter.layer.cornerRadius = 8.0
        vw_Main.layer.borderWidth = 1.0
        vw_Main.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Main.layer.cornerRadius = 10.0
        searchBar.delegate = self
    }
    
    func setProductSummaryData() {
        lblQuantity.text = "\(arrProductReport.count)"
        lblSellingPrice.text = "$" + String(arrSellingPrice.reduce(0) { $0 + (Double($1) ?? .zero) })
        lblCostPrice.text = "$" + String(arrCostPrice.reduce(0) { $0 + (Double($1) ?? .zero) })
        lblPayableTax.text = "$" + String(arrTax.reduce(0) { $0 + (Double($1) ?? .zero) })
        lblNetProfitLoss.text = "$" + String(arrProfitLoss.reduce(0) { $0 + (Double($1) ?? .zero) })
        
    }
    
    func callviewProductSaleReportAPI(isFilter : Bool? = false) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        if isFilter! {
            var dict :[String:String] = [:]
            if valSelctedSalesDates != ("",-1) {
                dict["selectDateRange"] = valSelctedSalesDates.0
            }
            if arrSelctedUsers.count > 0 {
                dict["selectuser"] = arrSelctedUsers.map{$0.1}.joined(separator:",")
             }
            if arrSelctedCustomers.count > 0 {
                dict["selectcutomer"] = arrSelctedCustomers.map{$0.1}.joined(separator:",")
            }
            if valSelctedCategory != ("",-1) {
                dict["Category"] = valSelctedCategory.0
            }
            params = dict as NSDictionary
            
        } else {
            params = [:]
        }
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
                            }
                            self.arrFilterProductReport = self.arrProductReport
                            self.setProductSummaryData()
                            
                            DispatchQueue.main.async {
                                self.tblProductReport.reloadData()
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
            let category = productReport.category
            let Category = category?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let custname = productReport.custname
            let Custname = custname?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let invoiceNumber = productReport.invoiceNumber
            let InvoiceNumber = invoiceNumber?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let productTitle = productReport.productTitle
            let ProductTitle = productTitle?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
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
            let tax = "$" + (productReport.productTaxPrice ?? "")
            let Tax = tax.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Username != nil || Category != nil || Custname != nil || InvoiceNumber != nil || ProductTitle != nil || ProdcutQuality != nil || Orderdate != nil || SellPrice != nil || CostPrice != nil || Tax != nil || ProfitLoss != nil
        })
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "SalesReportFilterVC") as! SalesReportFilterVC
        VC.isFromSalesReportList = true
        VC.delegateSalesReportProtocol = self
        VC.valSelctedSalesDates = valSelctedSalesDates
        VC.arrSelctedUsers = arrSelctedUsers
        VC.arrSelctedCustomers = arrSelctedCustomers
        VC.valSelctedCategory = valSelctedCategory
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension ProductReportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterProductReport.count
        } else {
            return arrProductReport.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProductReport.dequeueReusableCell(withIdentifier: "ProductReportCell", for: indexPath) as! ProductReportCell
        if searching {
            cell.model = arrFilterProductReport[indexPath.row]
        } else {
            cell.model = arrProductReport[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        
        return cell
    }
}

extension ProductReportVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- SearchBar Delegate Methods
extension ProductReportVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterProductReport = arrProductReport
            }
            tblProductReport.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblProductReport.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

//MARK:- Filter Delegate Methods
extension ProductReportVC: FilterSalesReportProtocol {
    func updateSalesReport(ReportDatas: (String, Int)?, userDatas: [(String, String)]?, CustomerDatas: [(String, String)]?, CategoryDatas: (String, Int)?, filterBadgeCount: Int) {
        self.valSelctedSalesDates = ReportDatas ?? ("",-1)
        self.arrSelctedUsers = userDatas ?? []
        self.arrSelctedCustomers = CustomerDatas ?? []
        self.valSelctedCategory = CategoryDatas ?? ("",-1)
        lblBadgeCount.text = "\(filterBadgeCount)"
        callviewProductSaleReportAPI(isFilter: true)
    }
    
 
}

