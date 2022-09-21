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
    @IBOutlet weak var radarChartView: RadarChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    var token = String()
    var arrLineSalesGraph = [SalesGraph]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callSalesGraphAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        arrLineSalesGraph.removeAll()
    }
    
    func setInitially() {
        lineChartView.layer.borderWidth = 0.5
        lineChartView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        lineChartView.layer.cornerRadius = 12
        
        pieChartView.layer.borderWidth = 0.5
        pieChartView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        pieChartView.layer.cornerRadius = 12
        
        radarChartView.layer.borderWidth = 0.5
        radarChartView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        radarChartView.layer.cornerRadius = 12
        
        barChartView.layer.borderWidth = 0.5
        barChartView.layer.borderColor = UIColor.init("#15B0DA").cgColor
        barChartView.layer.cornerRadius = 12
    }
    
    /* func customizePieChart(productData: SalesGraph) {
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
     }*/
    
    func customizePieChart(productData: SalesGraph) {
        let val1 = (((productData.Service.doubleValue)/(productData.allsum.doubleValue)) * 100)
        let val2 = (((productData.Product.doubleValue)/(productData.allsum.doubleValue)) * 100)
        let dataPoints = ["Service","Product"]
        let values = [val1,val2]
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
    
    /* func customizeLineChart(arrChartData: [SalesGraph]) {
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
     // yaxis.axisMaximum = 10
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
     } */
    func customizeLineChart(arrChartData: [SalesGraph]) {
        lineChartView.delegate = self
        lineChartView.noDataText = "No data available."
        var dataEntries: [ChartDataEntry] = []
        var dataEntries1: [ChartDataEntry] = []
        let Months: [String] = arrChartData.map{ $0.month }
        let Service: [String] = arrChartData.map{ $0.Service }
        let Product: [String] = arrChartData.map{ $0.Product }
        
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
        // yaxis.axisMaximum = 10
        yaxis.drawGridLinesEnabled = false
        
        lineChartView.rightAxis.enabled = false
        
        for i in 0..<Months.count {
            let entry = Service[i].doubleValue
            let dataEntry = ChartDataEntry(x: Double(i) , y: entry)
            dataEntries.append(dataEntry)
            
            let entry1 = Product[i].doubleValue
            let dataEntry1 = ChartDataEntry(x: Double(i) , y: entry1)
            dataEntries1.append(dataEntry1)
            
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Service")
        let chartDataSet1 = LineChartDataSet(entries: dataEntries1, label: "Product")
        
        
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
        
        chartDataSet.colors = [UIColor.init("FF0004")]
        chartDataSet1.colors = [UIColor.init("4A54AA")]
        
        chartDataSet.drawValuesEnabled = false
        chartDataSet1.drawValuesEnabled = false
        
        
        let dataSets: [LineChartDataSet] = [chartDataSet, chartDataSet1]
        let chartData = LineChartData(dataSets: dataSets)
        
        lineChartView.notifyDataSetChanged()
        lineChartView.data = chartData
        lineChartView.backgroundColor = UIColor.clear
    }
    
    func setBarChartView(arrGraphData: [SalesGraph]) {
        barChartView.delegate = self
        barChartView.noDataText = "No Data."
        barChartView.chartDescription.text = ""
        let months = arrGraphData.map{$0.month }
        let totalSales = arrGraphData.map{ $0.Product }
        let totalService = arrGraphData.map{ $0.Service }
        let totalAllSum = arrGraphData.map{ $0.allsum }
        
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
        
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        
        for i in 0..<months.count {
            let dataEntry = BarChartDataEntry(x: Double(i) , y: totalSales[i].doubleValue )
            dataEntries.append(dataEntry)
            
            let dataEntry1 = BarChartDataEntry(x: Double(i) , y: totalService[i].doubleValue )
            dataEntries1.append(dataEntry1)
            
            let dataEntry2 = BarChartDataEntry(x: Double(i) , y: totalAllSum[i].doubleValue )
            dataEntries2.append(dataEntry2)
            
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Product Sales")
        let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: "Service Sales")
        let chartDataSet2 = BarChartDataSet(entries: dataEntries2, label: "All Total ")
        let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1,chartDataSet2 ]
        chartDataSet.colors = [UIColor.init("4A54AA")]
        chartDataSet1.colors = [UIColor.init("FF0004")]
        chartDataSet2.colors = [UIColor.init("FFCA00")]
        chartDataSet.drawValuesEnabled = false
        chartDataSet1.drawValuesEnabled = false
        chartDataSet2.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSets: dataSets)
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.2//0.3
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
    
    func setRaderBarChartView(arrGraphData: [SalesGraph]) {
        let months = arrGraphData.map{$0.month}
        let totalSales = arrGraphData.map{ $0.Product.doubleValue }
        let totalService = arrGraphData.map{ $0.Service.doubleValue }
        
        let chartFormatter = RadarChartFormatter(labels: months)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        radarChartView.xAxis.valueFormatter = xAxis.valueFormatter
        
        radarChartView.noDataText = "no data available."
        var dataEntries: [ChartDataEntry] = []
        var dataEntries1: [ChartDataEntry] = []
        
        for i in 0..<months.count {
            let dataEntry  = ChartDataEntry(x:Double(i) , y:totalService[i] , data: months[i])
            dataEntries.append(dataEntry)
           let dataEntry1  = ChartDataEntry(x:Double(i) , y:totalService[i] , data: months[i])
            dataEntries1.append(dataEntry1)
        }
        let chartDataSet = RadarChartDataSet(entries: dataEntries, label: "Product Sales")
        let chartDataSet1 = RadarChartDataSet(entries: dataEntries1, label: "Service Sales")
        
        chartDataSet.colors = [UIColor.init("4A54AA")]
        chartDataSet1.colors = [UIColor.init("FF0004")]
        let chartData = RadarChartData.init(dataSets:[ chartDataSet,chartDataSet1])
        
        radarChartView.data = chartData
        radarChartView.sizeToFit()
        radarChartView.yAxis.labelCount = 5
        radarChartView.yAxis.axisMinimum = 0.0
        radarChartView.xAxis.drawLabelsEnabled = true
        radarChartView.yAxis.drawLabelsEnabled = false
        radarChartView.xAxis.axisLineWidth = 10.0
        radarChartView.rotationEnabled = false
        chartDataSet.drawFilledEnabled = false
        chartDataSet1.drawFilledEnabled = false
        radarChartView.legend.enabled = false
        radarChartView.xAxis.drawGridLinesEnabled = true
        radarChartView.animate(yAxisDuration: 2.0)
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
                            self.setBarChartView(arrGraphData:self.arrLineSalesGraph)
                            self.setRaderBarChartView(arrGraphData: self.arrLineSalesGraph)
                        }
                    }
                }
            }
        }
    }
    
}

private class RadarChartFormatter: NSObject, AxisValueFormatter {
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if Int(value) < labels.count {
            return labels[Int(value)]
        }else{
            return String("")
        }
    }
    
    init(labels: [String]) {
        super.init()
        self.labels = labels
    }
}
