//
//  SalesProfitGraphVC.swift
//  MySunless
//
//  Created by Daydream Soft on 13/04/22.
//

import UIKit
import Charts
import Alamofire

class SalesProfitGraphVC: UIViewController, ChartViewDelegate {
    
    @IBOutlet var vw_Main: UIView!
    @IBOutlet weak var barChartView: BarChartView!
    
    var months = [String]()
    var totalSales = [String]()
    var totalProfit  = [String]()
    
    var token = String()
    var arrSaleProfitGraph = [ShowSaleProfitGraphData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        callSaleProfitGraphAPI()
    }
    
    func setInitially() {
        vw_Main.layer.borderWidth = 1.0
        vw_Main.layer.borderColor = UIColor.init("#15B0DA").cgColor
        vw_Main.layer.cornerRadius = 10.0
    }
    
    func setChartView (arrGraphData: [ShowSaleProfitGraphData]) {
        barChartView.delegate = self
        barChartView.noDataText = "No Data."
        barChartView.chartDescription.text = ""
        self.months = arrGraphData.map{$0.month ?? ""}
        self.totalSales = arrGraphData.map{ $0.finalprise ?? "" }
        self.totalProfit = arrGraphData.map{ $0.finalcost ?? "" }
        
        //legend
        let legend = barChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 10.0;
        legend.xOffset = 10.0;
        legend.yEntrySpace = 0.0;
        
        let xaxis = barChartView.xAxis
        // xaxis.valueFormatter = axisFormatDelegate
        xaxis.setLabelCount(24, force: true)
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.valueFormatter = IndexAxisValueFormatter(values:months)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        
        barChartView.rightAxis.enabled = false
        setChart(arrGraph:arrGraphData)
    }
    
    func setChart(arrGraph:[ShowSaleProfitGraphData]) {
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: totalSales[i].doubleValue )
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: totalProfit[i].doubleValue )
            dataEntries1.append(dataEntry1)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Total Sales")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Profit/Loss")
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
        chartDataSet.colors = [UIColor.init("15B0DA")]
        chartDataSet1.colors = [UIColor.init("0ABB9F")]
        chartDataSet.drawValuesEnabled = false
        chartDataSet1.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSets: dataSets)
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        let groupCount = months.count
        let startYear = 0
        chartData.barWidth = barWidth;
        barChartView.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        print("Groupspace: \(gg)")
        barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        barChartView.data = chartData
        barChartView.backgroundColor = UIColor.clear
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
    
    @IBAction func btnFilterClick(_ sender: UIButton) {
        
    }
    
    func callSaleProfitGraphAPI() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SALE_PROFIT_GRAPH, param: params, header: headers) { [self] (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrSaleProfitGraph.removeAll()
                            for dict in response {
                                self.arrSaleProfitGraph.append(ShowSaleProfitGraphData(dictionary: (dict as NSDictionary) as! [String : Any])!)
                            }
                            setChartView(arrGraphData:arrSaleProfitGraph)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrSaleProfitGraph.removeAll()
                            
                        }
                    }
                }
            }
        }
    }
    
}


