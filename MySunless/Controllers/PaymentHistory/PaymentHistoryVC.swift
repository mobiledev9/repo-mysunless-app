//
//  PaymentHistoryVC.swift
//  MySunless
//
//  Created by Daydream Soft on 14/04/22.
//

import UIKit
import Alamofire

protocol PaymentHistoryCellProtocol {
    func showUserDetail()
    func showClientDetail(clientId: Int)
    func viewInvoice(orderId: Int)
    func editEventListView(index: Int)
}

protocol FilterPaymentHistoryProtocol {
    func updatePaymentHistory(PaymentDatas : (String,Int)?,
                              userDatas : [(String,String)]?,
                              CustomerDatas:[(String,String)]?,
                              PaymentsDatas :[(String,String)]?,
                              filterBadgeCount: Int)
}

class PaymentHistoryVC: UIViewController {
    
    @IBOutlet var vw_searchBar: UIView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblPaymentHistory : UITableView!
    @IBOutlet var vw_BtnFilter: UIView!
    @IBOutlet var vw_Main: UIView!
    @IBOutlet weak var lblBadgeCount: UILabel!
    
    var arrPaymentList = [PaymentList]()
    var arrFilterPaymentList = [PaymentList]()
    var searching = false
    var token = String()
    var valSelctedPaymentDate : (String,Int) = ("",-1)
    var arrSelctedCustomers = [(String,String)]()
    var arrSelctedUsers = [(String,String)]()
    var arrSelctedPaymnetType = [(String,String)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        hideKeyboardWhenTappedAround()
        tblPaymentHistory.tableFooterView = UIView()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callPaymentListAPI()
    }
    
    
    
    func setInitially() {
        vw_searchBar.layer.borderWidth = 0.5
        vw_searchBar.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_searchBar.layer.cornerRadius = 8.0
        searchBar.delegate = self
//        vw_Main.layer.borderWidth = 1.0
//        vw_Main.layer.borderColor = UIColor.init("#15B0DA").cgColor
//        vw_Main.layer.cornerRadius = 10.0
    }
    
    @IBAction func btn_filter_click(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentHistoryFilterVC") as! PaymentHistoryFilterVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.isFromPaymentHistory = true
       VC.delegateOfPaymentHistory = self
        VC.arrSelctedCustomers = self.arrSelctedCustomers
        VC.arrSelctedUsers = self.arrSelctedUsers
        VC.arrSelctedPaymnetType = self.arrSelctedPaymnetType
        VC.valSelctedPaymentDate = self.valSelctedPaymentDate
        self.present(VC, animated: true, completion: nil)
    }
    
    func callPaymentListAPI(isFilter : Bool? = false) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        if isFilter! {
            var dict :[String:String] = [:]
            if valSelctedPaymentDate != ("",-1) {
                dict["selectDateRange"] = valSelctedPaymentDate.0
            }
            if arrSelctedUsers.count > 0 {
                dict["user"] = arrSelctedUsers.map{$0.1}.joined(separator:",")
            }
            if arrSelctedCustomers.count > 0 {
                dict["customer"] = arrSelctedCustomers.map{$0.1}.joined(separator:",")
            }
            if arrSelctedPaymnetType.count > 0 {
                dict["payment_status"] = arrSelctedPaymnetType.map{$0.0}.joined(separator:",")
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + PAYMENT_LIST, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrPaymentList.removeAll()
                            self.arrFilterPaymentList.removeAll()
                            for dict in response {
                                self.arrPaymentList.append(PaymentList(dictionary: dict)!)
                            }
                            self.arrFilterPaymentList = self.arrPaymentList
                            
                            DispatchQueue.main.async {
                                self.tblPaymentHistory.reloadData()
                            }
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            print(response)
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrPaymentList.removeAll()
                            self.arrFilterPaymentList.removeAll()
                            self.tblPaymentHistory.reloadData()
                         }
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        arrFilterPaymentList = arrPaymentList.filter({ (paymentList: PaymentList) -> Bool in
            let username = paymentList.username
            let Username = username?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let name = paymentList.client_Fullname
            let Name = name?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let invoice = paymentList.invoiceNumber
            let Invoice = invoice?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let paymentStatus = paymentList.payment_status
            let PaymentStatus = paymentStatus?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let paymentType = paymentList.paymentType
            let PaymentType = paymentType?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            let paymentDetail = PaymentDetail(dict: paymentList.paymentDetail ?? [:])
            let chequeNo = "Cheque No.: " + (paymentDetail.ChequeNumber ?? "")
            let ChequeNo = chequeNo.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let bank = "Bank: " + (paymentDetail.Bank ?? "")
            let Bank = bank.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let submitDate = "Submit Date: " + (paymentDetail.submitdate ?? "")
            let SubmitDate = submitDate.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let amount = "Amount: $" + (paymentDetail.Amount ?? "")
            let Amount = amount.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            let orderDate = paymentList.orderdate
            let OrderDate = orderDate?.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            let amt = "$" + (paymentList.amount ?? "")
            let Amt = amt.range(of: searchText, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)
            
            return Username != nil || Name != nil || Invoice != nil || PaymentStatus != nil || PaymentType != nil || ChequeNo != nil || Bank != nil || SubmitDate != nil || Amount != nil || OrderDate != nil || Amt != nil
        })
    }
}

//MARK:- TableView Delegate and Datasource Methods
extension PaymentHistoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return arrFilterPaymentList.count
        } else {
            return arrPaymentList.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPaymentHistory.dequeueReusableCell(withIdentifier: "PaymentHistoryCell", for: indexPath) as! PaymentHistoryCell
        if searching {
            cell.model = arrFilterPaymentList[indexPath.row]
        } else {
            cell.model = arrPaymentList[indexPath.row]
        }
        cell.setCell(index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension PaymentHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

//MARK:- SearchBar Delegate Methods
extension PaymentHistoryVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
            searching = true
            if searchText == "" {
                arrFilterPaymentList = arrPaymentList
            }
            tblPaymentHistory.reloadData()
        }
    }
     
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblPaymentHistory.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
}

extension PaymentHistoryVC: PaymentHistoryCellProtocol{
   func editEventListView(index: Int) {}
    
    func showUserDetail() {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailVC") as! UserDetailVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func showClientDetail(clientId: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientDetailVC") as! ClientDetailVC
        VC.selectedId = clientId
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func viewInvoice(orderId: Int) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "InvoiceVC") as! InvoiceVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.orderId = orderId
        self.present(VC, animated: true, completion: nil)
    }
}

extension PaymentHistoryVC:FilterPaymentHistoryProtocol {
    func updatePaymentHistory(PaymentDatas: (String, Int)?, userDatas: [(String, String)]?, CustomerDatas: [(String, String)]?, PaymentsDatas: [(String, String)]?, filterBadgeCount: Int) {
        valSelctedPaymentDate = PaymentDatas ?? ("",-1)
        arrSelctedUsers = userDatas ?? []
        arrSelctedCustomers = CustomerDatas ?? []
        arrSelctedPaymnetType = PaymentsDatas ?? []
        lblBadgeCount.text = "\(filterBadgeCount)"
        callPaymentListAPI(isFilter: true)
     }
   
}
