//
//  SalesGraphVC.swift
//  MySunless
//
//  Created by iMac on 22/02/22.
//

import UIKit
import Alamofire
import Charts

class SalesGraphVC: UIViewController, ChartViewDelegate {

    @IBOutlet var lineChartView: LineChartView!
    @IBOutlet var pieChartView: PieChartView!
    
    var token = String()
    var arrLineSalesGraph = [SalesGraph]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callSalesGraphAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        arrLineSalesGraph.removeAll()
    }
    
    func customizePieChart(productData: SalesGraph) {
        let val1 = (((productData.Service.doubleValue)/(productData.allsum.doubleValue)) * 100)
        let val2 = (((productData.Product.doubleValue)/(productData.allsum.doubleValue)) * 100)
        let val3 = (((productData.Package.doubleValue)/(productData.allsum.doubleValue)) * 100)
        let val4 = (((productData.Gift.doubleValue)/(productData.allsum.doubleValue)) * 100)
 
        let dataPoints = ["Service","Product","Package","Gift"]
        let values = [val1,val2,val3,val4]
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = [UIColor.init("#FF0004"),UIColor.init("#4A54AA"),UIColor.init("#D9C13D"),UIColor.init("#296606")]
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .percent
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        pieChartView.data = pieChartData
    }
    
    func customizeLineChart(arrChartData: [SalesGraph]) {
        lineChartView.delegate = self
        lineChartView.noDataText = "No data available."
        var dataEntries: [ChartDataEntry] = []
        var dataEntries1: [ChartDataEntry] = []
        var dataEntries2: [ChartDataEntry] = []
        var dataEntries3: [ChartDataEntry] = []
        let Months: [String] = arrChartData.map{ $0.month }
        let Service: [String] = arrChartData.map{ $0.Service }
        let Product: [String] = arrChartData.map{ $0.Product }
        let Package: [String] = arrChartData.map{ $0.Package }
        let Gift: [String] = arrChartData.map{ $0.Gift }
        
        //legendfrrsection
        let legend = lineChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 1.0
        legend.xOffset = 10.0
        legend.yEntrySpace = 0.5
        
        let xaxis = lineChartView.xAxis
        // xaxis.valueFormatter = axisFormatDelegate
        xaxis.setLabelCount(12, force: true)
        xaxis.drawGridLinesEnabled = false
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = false
        xaxis.valueFormatter = IndexAxisValueFormatter(values: Months)
        xaxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 4
        
        let yaxis = lineChartView.leftAxis
        yaxis.setLabelCount(11, force: true)
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.axisMaximum = 10
        yaxis.drawGridLinesEnabled = false
    
        lineChartView.rightAxis.enabled = false
        
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
        
        let dataSets: [LineChartDataSet] = [chartDataSet, chartDataSet1, chartDataSet2, chartDataSet3]
        let chartData = LineChartData(dataSets: dataSets)
        
        lineChartView.notifyDataSetChanged()
        lineChartView.data = chartData
        lineChartView.backgroundColor = UIColor.clear
    }
    
    func callSalesGraphAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = [:]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + SALES_GRAPH, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success =  res.value(forKey: "success ") as? String {
                    if success == "1" {
                        if let piechart = res.value(forKey: "piechart") as? [String:Any] {
                            self.customizePieChart(productData: SalesGraph(dict: piechart))
                        }
                        if let barchart = res.value(forKey: "barchart") as? [[String:Any]] {
                            for dict in barchart {
                                self.arrLineSalesGraph.append(SalesGraph(dict: dict))
                            }
                            self.customizeLineChart(arrChartData: self.arrLineSalesGraph)
                        }
                    }
                }
            }
        }
    }
    
}
