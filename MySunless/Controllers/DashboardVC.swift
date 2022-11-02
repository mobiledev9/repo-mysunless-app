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
import AMProgressBar


class DashboardVC: UIViewController, ChartViewDelegate {
    //2520 2120
   // 560 0
    //MARK:- Outlets
    @IBOutlet weak var heightOfMainView: NSLayoutConstraint!
    @IBOutlet weak var heightOfChecklistView: NSLayoutConstraint!
    @IBOutlet var vw_progressView: UIView!
    @IBOutlet var vw_revenuView: UIView!
    @IBOutlet var vw_productSalesView: UIView!
    @IBOutlet var vw_topSellingView: UIView!
    @IBOutlet var vw_recentTransctionView: UIView!
    @IBOutlet var vw_checklistView: UIView!
    
    @IBOutlet var vw_clientView: UIView!
    @IBOutlet var imgCheckClient: UIImageView!
    @IBOutlet var btnClient: UIButton!
    @IBOutlet var lblClient: UILabel!
    
    @IBOutlet var vw_productView: UIView!
    @IBOutlet var imgCheckProduct: UIImageView!
    @IBOutlet var btnProduct: UIButton!
    @IBOutlet var lblProduct: UILabel!
    
    @IBOutlet var vw_eventView: UIView!
    @IBOutlet var imgCheckEvent: UIImageView!
    @IBOutlet var btnEvent: UIButton!
    @IBOutlet var lblEvent: UILabel!
    
    @IBOutlet var vw_todoView: UIView!
    @IBOutlet var imgCheckTodo: UIImageView!
    @IBOutlet var btnTodo: UIButton!
    @IBOutlet var lblTodo: UILabel!
    
    @IBOutlet var vw_orderView: UIView!
    @IBOutlet var imgCheckOrder: UIImageView!
    @IBOutlet var btnOrder: UIButton!
    @IBOutlet var lblOrder: UILabel!
     
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
   // @IBOutlet weak var revenueBarChatView: BarChartView!
    @IBOutlet weak var revenueLineChatView: LineChartView!
    @IBOutlet weak var productPieChartView: PieChartView!
    @IBOutlet var vw_container: UIView!
    @IBOutlet weak var vw_lock: UIView!
    @IBOutlet weak var lblBadgeCount: UILabel!
    @IBOutlet weak var vw_checklistProgressBar: UIView!
    
    //MARK:- Variable Declarations
   // var arrData = [Category]()
  //  var profileVC: ProfileVC?
    var token = String()
    var clientsVC: ClientsVC?
    var clients = Bool()
    var arrTopSellingProducts = [TopSellingProducts]()
    var arrRecentTransaction = [RecentTransaction]()
    var arrProgressBar = [ProgressBar]()
    var arrRevenueReport = [EventLineChart]()
    var ProductSaleReport : ProductSalesReport?
    var valSelctedDates : (String,Int) = ("",-1)
    let checklistProgressBar = AMProgressBar()
    var progressValue : CGFloat = 0.4
    
    
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
        callprogressbarAPI()
        setChecklistProgressBar(value: progressValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "navClients")
    }
    
    //MARK:- User-Defined Functions
    func setInitially() {
//        vw_Clients.layer.borderWidth = 0.5
//        vw_Clients.layer.borderColor = UIColor.init("#15B0DA").cgColor
//        vw_Clients.layer.cornerRadius = 12
//        vw_Sales.layer.borderWidth = 0.5
//        vw_Sales.layer.borderColor = UIColor.init("#15B0DA").cgColor
//        vw_Sales.layer.cornerRadius = 12
//        vw_UpcomingEvents.layer.borderWidth = 0.5
//        vw_UpcomingEvents.layer.borderColor = UIColor.init("#15B0DA").cgColor
//        vw_UpcomingEvents.layer.cornerRadius = 12
//        vw_ToDoList.layer.borderWidth = 0.5
//        vw_ToDoList.layer.borderColor = UIColor.init("#15B0DA").cgColor
//        vw_ToDoList.layer.cornerRadius = 12
        vw_progressView.layer.borderWidth = 0.5
        vw_progressView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_progressView.layer.cornerRadius = 12
        revenueLineChatView.layer.borderWidth = 0.5
        revenueLineChatView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        revenueLineChatView.layer.cornerRadius = 12
        productPieChartView.layer.borderWidth = 0.5
        productPieChartView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        productPieChartView.layer.cornerRadius = 12
        tblTopSellingList.layer.borderWidth = 0.5
        tblTopSellingList.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblTopSellingList.layer.cornerRadius = 12
        tblRecentTransctionList.layer.borderWidth = 0.5
        tblRecentTransctionList.layer.borderColor = UIColor.init("#15B0DA").cgColor
        tblRecentTransctionList.layer.cornerRadius = 12
        
        vw_clientView.layer.borderWidth = 0.5
        vw_clientView.layer.cornerRadius = 12
        vw_productView.layer.borderWidth = 0.5
        vw_productView.layer.cornerRadius = 12
        
        vw_eventView.layer.borderWidth = 0.5
        vw_eventView.layer.cornerRadius = 12
        
        vw_todoView.layer.borderWidth = 0.5
        vw_todoView.layer.cornerRadius = 12
        
        vw_orderView.layer.borderWidth = 0.5
        vw_orderView.layer.cornerRadius = 12
        
        vw_checklistProgressBar.layer.borderWidth = 0.5
        vw_checklistProgressBar.layer.cornerRadius = 12
        vw_checklistProgressBar.addSubview(checklistProgressBar)
    }
    
    func lockView() {
//        if UserDefaults.standard.bool(forKey: "currentSubscription") == true {
//            vw_lock.isHidden = true
//        } else {
//            vw_lock.isHidden = false
//        }
    }
    func setChecklistProgressBar(value:CGFloat = 0.1) {
        checklistProgressBar.progressValue = value
        checklistProgressBar.frame = vw_checklistProgressBar.bounds
        checklistProgressBar.customize { bar in
            bar.backgroundColor = UIColor.init("E9EAEC")
            bar.cornerRadius = 2.0
            bar.borderColor = UIColor.init("15B0DA")//UIColor.gray
            bar.borderWidth = 0.5//4

            bar.barCornerRadius = 0.5
            bar.barColor = UIColor.init("15B0DA")
            bar.barMode = AMProgressBarMode.determined.rawValue

            bar.hideStripes = false
            bar.stripesColor = UIColor.init("15C0DA").withAlphaComponent(0.5)
            bar.stripesWidth = 6.0
           // bar.stripesSpacing = 10
            bar.stripesDelta = 0.0
            bar.stripesMotion = AMProgressBarStripesMotion.right.rawValue
            bar.stripesOrientation = AMProgressBarStripesOrientation.diagonalLeft.rawValue

            bar.textColor = UIColor.black
            bar.textFont = UIFont(name: "Roboto-Bold", size: 25)!
            bar.textPosition = AMProgressBarTextPosition.topLeft.rawValue
        }
        
    }
    
    func customizeLineChart(arrChartData: [EventLineChart]) {
        revenueLineChatView.delegate = self
        revenueLineChatView.noDataText = "No data available."
        var dataEntries: [ChartDataEntry] = []
        var dataEntries1: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
        var dataEntries3: [ChartDataEntry] = []
        let Months: [String] = arrChartData.map{ $0.month }
        let Service: [String] = arrChartData.map{ $0.servicePrice }
        let Product: [String] = arrChartData.map{ $0.productPrice }
        let Package: [String] = arrChartData.map{ $0.memberPrice }
        let Gift: [String] = arrChartData.map{ $0.giftprice }
        
        //legendfrrsection
        let legend = revenueLineChatView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 1.0
        legend.xOffset = 10.0
        legend.yEntrySpace = 0.5
        
        let xaxis = revenueLineChatView.xAxis
        // xaxis.valueFormatter = axisFormatDelegate
        xaxis.setLabelCount(12, force: true)
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = false
        xaxis.valueFormatter = IndexAxisValueFormatter(values: Months)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 4
        
        let yaxis = revenueLineChatView.leftAxis
        yaxis.setLabelCount(11, force: true)
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
       // yaxis.axisMaximum = 10
        yaxis.drawGridLinesEnabled = false
    
        revenueLineChatView.rightAxis.enabled = false
        
        for i in 0..<Months.count {
            let entry = Service[i].doubleValue
            let dataEntry = ChartDataEntry(x: Double(i) , y: entry)
            dataEntries.append(dataEntry)
            
            let entry1 = Product[i].doubleValue
            let dataEntry1 = ChartDataEntry(x: Double(i) , y: entry1)
            dataEntries1.append(dataEntry1)
            
            let entry2 = Package[i].doubleValue
            let dataEntry2 = ChartDataEntry(x: Double(i) , y: entry2)
            dataEntries2.append(dataEntry2)
            
            let entry3 = Gift[i].doubleValue
            let dataEntry3 = ChartDataEntry(x: Double(i) , y: entry3)
            dataEntries3.append(dataEntry3)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Service")
        let chartDataSet1 = LineChartDataSet(entries: dataEntries1, label: "Product")
        let chartDataSet2 = LineChartDataSet(entries: dataEntries2, label: "Package")
        let chartDataSet3 = LineChartDataSet(entries: dataEntries3, label: "Gift")
        
        chartDataSet.setCircleColor(UIColor.init("FF0004"))
        chartDataSet.lineWidth = 3.0
        chartDataSet.circleRadius = 5.0
        chartDataSet.circleHoleColor = UIColor.init("FF0004")
        chartDataSet.drawCircleHoleEnabled = true
        
        chartDataSet1.setCircleColor(UIColor.init("4A54AA"))
        chartDataSet1.lineWidth = 3.0
        chartDataSet1.circleRadius = 5.0
        chartDataSet1.circleHoleColor = UIColor.init("4A54AA")
        chartDataSet1.drawCircleHoleEnabled = true
        
        chartDataSet2.setCircleColor(UIColor.init("D9C13D"))
        chartDataSet2.lineWidth = 3.0
        chartDataSet2.circleRadius = 5.0
        chartDataSet2.circleHoleColor = UIColor.init("D9C13D")
        chartDataSet2.drawCircleHoleEnabled = true
        
        chartDataSet3.setCircleColor(UIColor.init("296606"))
        chartDataSet3.lineWidth = 3.0
        chartDataSet3.circleRadius = 5.0
        chartDataSet3.circleHoleColor = UIColor.init("296606")
        chartDataSet3.drawCircleHoleEnabled = true
        
        chartDataSet.colors = [UIColor.init("FF0004")]
        chartDataSet1.colors = [UIColor.init("4A54AA")]
        chartDataSet2.colors = [UIColor.init("D9C13D")]
        chartDataSet3.colors = [UIColor.init("296606")]
        chartDataSet.drawValuesEnabled = false
        chartDataSet1.drawValuesEnabled = false
        chartDataSet2.drawValuesEnabled = false
        chartDataSet3.drawValuesEnabled = false
        
        let gradient1 = getGradientFilling(gColor: UIColor.init("FF0004"))
        chartDataSet.fill = LinearGradientFill(gradient: gradient1, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        let gradient2 = getGradientFilling(gColor: UIColor.init("4A54AA"))
        chartDataSet1.fill = LinearGradientFill(gradient: gradient2, angle: 90.0)
        chartDataSet1.drawFilledEnabled = true
        
        let gradient3 = getGradientFilling(gColor: UIColor.init("D9C13D"))
        chartDataSet2.fill = LinearGradientFill(gradient: gradient3, angle: 90.0)
        chartDataSet2.drawFilledEnabled = true
        
        let gradient4 = getGradientFilling(gColor: UIColor.init("296606"))
        chartDataSet3.fill = LinearGradientFill(gradient: gradient4, angle: 90.0)
        chartDataSet3.drawFilledEnabled = true
        
        
        let dataSets: [LineChartDataSet] = [chartDataSet, chartDataSet1, chartDataSet2, chartDataSet3]
        let chartData = LineChartData(dataSets: dataSets)
        
        revenueLineChatView.notifyDataSetChanged()
        revenueLineChatView.data = chartData
        revenueLineChatView.backgroundColor = UIColor.clear
    }
    
    private func getGradientFilling(gColor:UIColor) -> CGGradient {
        let gradientColors = [gColor.cgColor, UIColor.clear.cgColor]
        let colorLocations: [CGFloat] = [0.7, 0.0]
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: colorLocations)!
    }
    
    func customizePieChart(productData: ProductSalesReport) {
        let val1 = (((productData.product?.doubleValue ?? 0.0)/(productData.allsum?.doubleValue ?? 0.0)) * 100)
        let val2 = (((productData.service?.doubleValue ?? 0.0)/(productData.allsum?.doubleValue ?? 0.0)) * 100)
        let val3 = (((productData.service?.doubleValue ?? 0.0)/(productData.allsum?.doubleValue ?? 0.0)) * 100)
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
    
   /* func customizeBarChart(arrChartData :[RevenuReport]) {
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
    */
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
                   // self.lblTotalClients.text = "\(numberOfClient)"
                }
                if let clientGoal = res.value(forKey: "clientGoal") as? Int {
                    self.progressBar_Clients.value = CGFloat(clientGoal)
                }
                if let totalSale = res.value(forKey: "totalSale") as? String {
                  //  self.lblSales.text = totalSale
                }
                if let salesGoalPer = res.value(forKey: "salesGoalPer") as? String {
                    self.progressBar_Sales.value = salesGoalPer.CGFloatValue() ?? 0.00
                }
                if let numberOfEvent = res.value(forKey: "numberOfEvent") as? Int {
                   // self.lblUpcomingEvents.text = "\(numberOfEvent)"
                    self.progressBar_UpcomingEvents.value = CGFloat(numberOfEvent)
                }
                if let numberOfTodo = res.value(forKey: "numberOfTodo") as? Int {
                   // self.lblTodoList.text = "\(numberOfTodo)"
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
                            if response != "No Product is there" {
                                AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            }
                             self.arrRevenueReport.removeAll()
                            
                        }
                    }
                }
            }
        }
    }
    
    func callRevenueReportAPI(isFilter:Bool? = false) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization" : token]
        var params = NSDictionary()
        if isFilter! {
            var dict :[String:String] = [:]
            if valSelctedDates != ("",-1) {
                dict["filterdata"] = valSelctedDates.0
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + REVENUE_REPORT, param: params, header: headers) { [self] (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrRevenueReport.removeAll()
                            for dict in response {
                                self.arrRevenueReport.append(EventLineChart(dict: dict))
//                                self.arrRevenueReport.append(RevenuReport(dictionary: dict as NSDictionary)!)
                            }
                           // customizeBarChart(arrChartData: arrRevenueReport)
                            customizeLineChart(arrChartData: arrRevenueReport)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            if response != "No Product is there" {
                                AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            }
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
                            if response != "No Product is there" {
                                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                            }
                            
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
                            if response != "No Product is there" {
                                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                            }
                          
                        }
                    }
                }
            }
        }
    }
    
    func callprogressbarAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + PROGRESS_BAR, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrProgressBar.removeAll()
                            for dict in response {
                                self.arrProgressBar.append(ProgressBar(dict: dict))
                            }
                            DispatchQueue.main.async {
                                if let progress = res.value(forKey: "progress") as? Int {
                                    self.setCheckListView(progressValue: progress)
                                }
                            }
                        }
                       
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            if response != "No Product is there" {
                                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle: response)
                            }
                           
                        }
                    }
                }
            }
        }
    }
    
    func setCheckListView(progressValue : Int) {
        if progressValue == 100 {
            vw_checklistView.isHidden = true
            heightOfChecklistView.constant = 0.0
            heightOfMainView.constant = 2120
        } else {
            vw_checklistView.isHidden = false
            heightOfChecklistView.constant = 560
            heightOfMainView.constant = 2520
            self.setChecklistProgressBar(value: CGFloat(progressValue)/100)
            
            for progress in arrProgressBar {
                switch progress.type {
                case "client": imgCheckClient.setCheckImage(value:progress.data)
                     progress.data == 1 ? lblClient.strikeThrough(true)       :lblClient.strikeThrough(false)
                    if progress.data == 0 {
                        self.btnClient.isEnabled = true
                    } else {
                        self.btnClient.isEnabled = false
                    }
                    break
                    
                case "product":
                    imgCheckProduct.setCheckImage(value:progress.data)
                    progress.data == 1 ? lblProduct.strikeThrough(true)       :lblProduct.strikeThrough(false)
                    if progress.data == 0 {
                        self.btnProduct.isEnabled = true
                    } else {
                        self.btnProduct.isEnabled = false
                    }
                    break
                    
                case "event":
                    imgCheckEvent.setCheckImage(value:progress.data)
                    progress.data == 1 ? lblEvent.strikeThrough(true):lblEvent.strikeThrough(false)
                    if progress.data == 0{
                        self.btnEvent.isEnabled = true
                     } else {
                       self.btnEvent.isEnabled = false
                    }
                    break
                    
                case "todo":
                    imgCheckTodo.setCheckImage(value:progress.data)
                    progress.data == 1 ? lblTodo.strikeThrough(true)       :lblTodo.strikeThrough(false)
                    if progress.data == 0 {
                        self.btnTodo.isEnabled = true
                    } else {
                        self.btnTodo.isEnabled = false
                    }
                    break
                    
                case "order":
                    imgCheckOrder.setCheckImage(value:progress.data)
                    progress.data == 1 ? lblOrder.strikeThrough(true)       :lblOrder.strikeThrough(false)
                    if progress.data == 0 {
                        self.btnOrder.isEnabled = true
                     } else {
                       self.btnOrder.isEnabled = false
                    }
                    break
                default:
                    print("Default")
                }
            }
            
            
        }
        
    }
    
//    func setCheckImage(value:Int) -> UIImage {
//        var img : UIImage  = UIImage()
//        if value == 1 {
//            img =  UIImage(systemName: "checkmark.circle.fill")!
//            img.withTintColor(UIColor.darkGray)
//        } else {
//            img =  UIImage(systemName: "circle")!
//            img.withTintColor(UIColor.green)
//        }
//        return img
//    }

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
    
    @IBAction func btnFilterRevenuGraphClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "PaymentHistoryFilterVC") as! PaymentHistoryFilterVC
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
       VC.delegateOfRevenuGraphFromDashbord = self
        VC.isRevenuGraphFromDashbord = true
        VC.valSelctedPaymentDate = self.valSelctedDates
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func btnClientClick(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "CustomerDetailsVC") as! CustomerDetailsVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnProductClick(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProductsListVC") as! ProductsListVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnEventClick(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnTodoClick(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ToDoVC") as! ToDoVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @IBAction func btnOrderClick(_ sender: Any) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "AddOrderVC") as! AddOrderVC
        self.navigationController?.pushViewController(VC, animated: true)
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
            cell.setCell(index: indexPath.row)
            return cell
        } else if tableView == tblRecentTransctionList {
            let cell = tblRecentTransctionList.dequeueReusableCell(withIdentifier: "RecentTransctionCell", for: indexPath) as! RecentTransctionCell
            cell.model = arrRecentTransaction[indexPath.row]
            cell.setCell(index: indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableView Delegate Methods
extension DashboardVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblTopSellingList {
            return UITableView.automaticDimension//110
        } else if tableView == tblRecentTransctionList {
            return UITableView.automaticDimension//186
        }
        return UITableView.automaticDimension
    }
}

//MARK:- Filter on revenu graph
extension DashboardVC: FilterdelegateOfRevenuGraphProtocol {
    func filterRevenuGraph(DateDatas: (String, Int)?, filterBadgeCount: Int) {
        valSelctedDates = DateDatas ?? ("",-1)
        self.lblBadgeCount.text = "\(filterBadgeCount)"
        self.callRevenueReportAPI(isFilter: true)
        
    }
    
    
}

protocol FilterdelegateOfRevenuGraphProtocol {
    func filterRevenuGraph(DateDatas : (String,Int)?,
                               filterBadgeCount: Int)
}
