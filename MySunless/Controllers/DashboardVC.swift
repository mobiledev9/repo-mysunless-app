//
//  DashboardVC.swift
//  MySunless
//
//  Created by iMac on 06/10/21.
//

import UIKit
import Alamofire
import SideMenu
import Charts
import MBCircularProgressBar

class DashboardVC: UIViewController, ChartViewDelegate {
    
    //MARK:- Outlets
    @IBOutlet var vw_progressView: UIView!
    @IBOutlet var vw_revenuView: UIView!
    @IBOutlet var vw_productSalesView: UIView!
    @IBOutlet var vw_topSellingView: UIView!
    @IBOutlet var vw_recentTransctionView: UIView!
    
    @IBOutlet weak var lblTotalClients: UILabel!
    @IBOutlet weak var progressBar_Clients: MBCircularProgressBarView!
    @IBOutlet weak var vw_Clients: UIView!
    
    @IBOutlet weak var progressBar_Sales: MBCircularProgressBarView!
    @IBOutlet weak var lblSales: UILabel!
   
    @IBOutlet weak var progressBar_UpcomingEvents: MBCircularProgressBarView!
    @IBOutlet weak var vw_Sales: UIView!
    
    @IBOutlet weak var lblUpcomingEvents: UILabel!
    
    @IBOutlet weak var ProgressBar_ToDoList: MBCircularProgressBarView!
    @IBOutlet weak var vw_UpcomingEvents: UIView!
    
    @IBOutlet weak var lblTodoList: UILabel!
    @IBOutlet weak var vw_ToDoList: UIView!
    
    @IBOutlet var tblTopSellingList: UITableView!
    @IBOutlet var tblRecentTransctionList: UITableView!
    @IBOutlet weak var revenueBarChatView: BarChartView!
    @IBOutlet weak var productPieChartView: PieChartView!
    @IBOutlet var vw_container: UIView!
    @IBOutlet weak var vw_lock: UIView!
    
    //MARK:- Variable Declarations
   // var arrData = [Category]()
  //  var profileVC: ProfileVC?
    var token = String()
    var clientsVC: ClientsVC?
    var clients = Bool()
    var arrTopSellingProducts = [TopSellingProducts]()
    var arrRecentTransaction = [RecentTransaction]()
    var arrRevenueReport = [RevenuReport]()
    var ProductSaleReport : ProductSalesReport?
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lockView()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calldisplayInfoFirstRowAPI()
        callTopSellingProductsAPI()
        callRecentTransactionAPI()
        callProductSalesReportAPI()
        callRevenueReportAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "navClients")
    }
    
    //MARK:- User-Defined Functions
    func setInitially() {
        vw_Clients.layer.borderWidth = 0.5
        vw_Clients.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Clients.layer.cornerRadius = 12
        vw_Sales.layer.borderWidth = 0.5
        vw_Sales.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Sales.layer.cornerRadius = 12
        vw_UpcomingEvents.layer.borderWidth = 0.5
        vw_UpcomingEvents.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_UpcomingEvents.layer.cornerRadius = 12
        vw_ToDoList.layer.borderWidth = 0.5
        vw_ToDoList.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_ToDoList.layer.cornerRadius = 12
        revenueBarChatView.layer.borderWidth = 0.5
        revenueBarChatView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        revenueBarChatView.layer.cornerRadius = 12
        productPieChartView.layer.borderWidth = 0.5
        productPieChartView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        productPieChartView.layer.cornerRadius = 12
        tblTopSellingList.layer.borderWidth = 0.5
        tblTopSellingList.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblTopSellingList.layer.cornerRadius = 12
        tblRecentTransctionList.layer.borderWidth = 0.5
        tblRecentTransctionList.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblRecentTransctionList.layer.cornerRadius = 12
    }
    
    func lockView() {
        if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
            vw_lock.isHidden = true
        } else {
            vw_lock.isHidden = false
        }
    }
    
    func customizePieChart(productData: ProductSalesReport) {
        let val1 = (((productData.product?.doubleValue ?? 0.0)/(productData.allsum?.doubleValue ?? 0.0)) * 100)
        let val2 = (((productData.service?.doubleValue ?? 0.0)/(productData.allsum?.doubleValue ?? 0.0)) * 100)
     //   let total = productData.allsum?.doubleValue ?? 0.0
        let dataPoints = ["Product","Service"]
        let values = [val1,val2]
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = [UIColor.init("4A54AA"),UIColor.init("FF0004")]
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .percent
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        productPieChartView.data = pieChartData
    }
    
    func customizeBarChart(arrChartData :[RevenuReport]) {
        // Do any additional setup after loading the view, typically from a nib.
        revenueBarChatView.delegate = self
        revenueBarChatView.noDataText = "No data available."
        var dataEntries: [BarChartDataEntry] = []
        let Months:[String] = arrChartData.map{$0.month!}
        let Sales = arrChartData.map{ $0.finalprice }
        print(Sales)
        
        //legend
        let legend = revenueBarChatView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.5;
        
        let xaxis = revenueBarChatView.xAxis
        // xaxis.valueFormatter = axisFormatDelegate
        xaxis.setLabelCount(25, force: true)
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = false
        xaxis.valueFormatter = IndexAxisValueFormatter(values: Months)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 4
        
        let yaxis = revenueBarChatView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0.000
        
        yaxis.drawGridLinesEnabled = false
        
        revenueBarChatView.rightAxis.enabled = false
        
        for i in 0..<Months.count {
            let entry1 = Sales[i]?.doubleValue
            let dataEntry = BarChartDataEntry(x: Double(i) , y: entry1 ?? 0.0)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Total Sales")
        let dataSets: [BarChartDataSet] = [chartDataSet]
        chartDataSet.colors = [UIColor.init("15B0DA")]
        chartDataSet.drawValuesEnabled = false
        let chartData = BarChartData(dataSets: dataSets)
        
      //  let barSpace = 0.2
        let barWidth = 0.3
        chartData.barWidth = barWidth
        
        revenueBarChatView.notifyDataSetChanged()
        revenueBarChatView.data = chartData
        revenueBarChatView.backgroundColor = UIColor.clear
        
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    func calldisplayInfoFirstRowAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + DISPLAY_INFO_FIRST_ROW, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let numberOfClient = res.value(forKey: "numberOfClient") as? Int {
                    self.lblTotalClients.text = "\(numberOfClient)"
                }
                if let clientGoal = res.value(forKey: "clientGoal") as? Int {
                    self.progressBar_Clients.value = CGFloat(clientGoal)
                }
                if let totalSale = res.value(forKey: "totalSale") as? String {
                    self.lblSales.text = totalSale
                }
                if let salesGoalPer = res.value(forKey: "salesGoalPer") as? String {
                    self.progressBar_Sales.value = salesGoalPer.CGFloatValue() ?? 0.00
                }
                if let numberOfEvent = res.value(forKey: "numberOfEvent") as? Int {
                    self.lblUpcomingEvents.text = "\(numberOfEvent)"
                    self.progressBar_UpcomingEvents.value = CGFloat(numberOfEvent)
                }
                if let numberOfTodo = res.value(forKey: "numberOfTodo") as? Int {
                    self.lblTodoList.text = "\(numberOfTodo)"
                }
                if let todoPer = res.value(forKey: "todoPer") as? Int {
                    self.ProgressBar_ToDoList.value = CGFloat(todoPer)
                }
            }
        }
    }
    
    func callProductSalesReportAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + PRODUCT_SALES_REPORT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [String:Any] {
                            let SalesReport = ProductSalesReport(dictionary: response as NSDictionary)
                            self.customizePieChart(productData: SalesReport!)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrRevenueReport.removeAll()
                            
                        }
                    }
                }
            }
        }
    }
    
    func callRevenueReportAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + REVENUE_REPORT, param: params, header: headers) { [self] (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrRevenueReport.removeAll()
                            for dict in response {
                                self.arrRevenueReport.append(RevenuReport(dictionary: dict as NSDictionary)!)
                            }
                            customizeBarChart(arrChartData: arrRevenueReport)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrRevenueReport.removeAll()
                            
                        }
                    }
                }
            }
        }
    }
    
    func callTopSellingProductsAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + TOP_SELLING_PRODUCTS, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrTopSellingProducts.removeAll()
                            for dict in response {
                                self.arrTopSellingProducts.append(TopSellingProducts(dict: dict))
                            }
                            DispatchQueue.main.async {
                                self.tblTopSellingList.reloadData()
                            }
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
    
    func callRecentTransactionAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        params = [:]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + RECENT_TRANSACTION, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrRecentTransaction.removeAll()
                            for dict in response {
                                self.arrRecentTransaction.append(RecentTransaction(dictionary: dict)!)
                            }
                            DispatchQueue.main.async {
                                self.tblRecentTransctionList.reloadData()
                            }
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

    //MARK:- Actions
    @IBAction func btnTotalClientsClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ClientsVC") as! ClientsVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnTotalSalesClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "OrderListVC") as! OrderListVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnUpcomingEventsClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnToDoListClick(_ sender: UIButton) {
    }
    
}

//MARK:- UITableView Datasource Methods
extension DashboardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblTopSellingList {
            return arrTopSellingProducts.count
        } else if tableView == tblRecentTransctionList {
            return arrRecentTransaction.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblTopSellingList {
            let cell = tblTopSellingList.dequeueReusableCell(withIdentifier: "TopSellingCell", for: indexPath) as! TopSellingCell
            cell.model = arrTopSellingProducts[indexPath.row]
            cell.setCell()
            return cell
        } else if tableView == tblRecentTransctionList {
            let cell = tblRecentTransctionList.dequeueReusableCell(withIdentifier: "RecentTransctionCell", for: indexPath) as! RecentTransctionCell
            cell.model = arrRecentTransaction[indexPath.row]
            cell.setCell()
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableView Delegate Methods
extension DashboardVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblTopSellingList {
            return 110
        } else if tableView == tblRecentTransctionList {
            return 186
        }
        return UITableView.automaticDimension
    }
}
