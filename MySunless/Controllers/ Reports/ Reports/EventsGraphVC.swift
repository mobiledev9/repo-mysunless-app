//
//  EventListVC.swift
//  MySunless
//
//  Created by iMac on 25/01/22.
//

import UIKit
import Charts
import Alamofire

class EventsGraphVC: UIViewController, ChartViewDelegate {

    @IBOutlet var lineChartView: LineChartView!
    @IBOutlet var pieChartView: PieChartView!
    
    var token = String()
    var arrLineChart = [EventLineChart]()
    var arrPieChart = [EventPieChart]()
    var val1 = Double()
    var val2 = Double()
    var val3 = Double()
    var val4 = Double()
    var val5 = Double()
    var val6 = Double()
    var dataEntries: [ChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callEventChartAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        arrLineChart.removeAll()
        arrPieChart.removeAll()
    }
    
    func customizeLineChart(arrChartData: [EventLineChart]) {
        lineChartView.delegate = self
        lineChartView.noDataText = "No data available."
        var dataEntries: [ChartDataEntry] = []
        let Months: [String] = arrChartData.map{ $0.month }
        let Count: [String] = arrChartData.map{ $0.count }
        
        //legend
        let legend = lineChartView.legend
        legend.enabled = true
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 1.0
        legend.xOffset = 10.0
        legend.yEntrySpace = 0.5
        
        lineChartView.setScaleEnabled(false)
        lineChartView.drawGridBackgroundEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = true
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = true
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.legend.enabled = true
        lineChartView.xAxis.enabled = true
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: Months)
        lineChartView.xAxis.setLabelCount(12, force: true)
        lineChartView.leftAxis.setLabelCount(5, force: true)
        lineChartView.leftAxis.axisMinimum = 0
        lineChartView.leftAxis.axisMaximum = 16
        lineChartView.leftAxis.enabled = true
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawLabelsEnabled = true
        
        for i in 0..<Months.count {
            let entry = Count[i].doubleValue
            let dataEntry = ChartDataEntry(x: Double(i) , y: entry)
            dataEntries.append(dataEntry)
        }
        
        let line1 = LineChartDataSet(entries: dataEntries, label: "No of Appointments")
        line1.colors = [UIColor.init("15B0DA")]
        line1.mode = .cubicBezier
        line1.cubicIntensity = 0.2
        
        let gradient = getGradientFilling()
        line1.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
        line1.drawFilledEnabled = true
        
        let data = LineChartData(dataSet: line1)
        //  data.addDataSet(line1)
        lineChartView.data = data
        
    }
    
    /// Creating gradient for filling space under the line chart
    private func getGradientFilling() -> CGGradient {
        // Setting fill gradient color
//        let coloTop = UIColor(red: 141/255, green: 133/255, blue: 220/255, alpha: 1).cgColor
//        let colorBottom = UIColor(red: 230/255, green: 155/255, blue: 210/255, alpha: 1).cgColor
//        // Colors of the gradient
//        let gradientColors = [coloTop, colorBottom] as CFArray
        let gradientColors = [UIColor.cyan.cgColor, UIColor.clear.cgColor]
        // Positioning of the gradient
        let colorLocations: [CGFloat] = [0.7, 0.0]
        // Gradient Object
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: colorLocations)!
    }

    func customizePieChart(event: [EventPieChart]) {
        for dict in event {
            switch dict.eventstatus {
                case "completed":
                    let eventCount = "\(dict.eventcount)"
                    val1 = (((eventCount.doubleValue)/6.0) * 100)
                case "confirmed":
                    let eventCount = "\(dict.eventcount)"
                    val2 = (((eventCount.doubleValue)/6.0) * 100)
                case "in-progress":
                    let eventCount = "\(dict.eventcount)"
                    val3 = (((eventCount.doubleValue)/6.0) * 100)
                case "pending":
                    let eventCount = "\(dict.eventcount)"
                    val4 = (((eventCount.doubleValue)/6.0) * 100)
                case "pending-payment":
                    let eventCount = "\(dict.eventcount)"
                    val5 = (((eventCount.doubleValue)/6.0) * 100)
                case "canceled":
                    let eventCount = "\(dict.eventcount)"
                    val6 = (((eventCount.doubleValue)/6.0) * 100)
                default:
                    print("default")
            }
        }
        
//        let dataPoints = ["Completed","Confirmed","In Progress","Pending","Pending Payment","Canceled"]
//        let values = [val1,val2,val3,val4,val5,val6]
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
//            dataEntries.append(dataEntry)
//        }
        for i in arrPieChart {
            let entry = PieChartDataEntry(value: Double(i.eventcount), label: i.eventstatus.capitalized)
            dataEntries.append(entry)
        }
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = [UIColor.gray,UIColor.init("#296606"),UIColor.init("#FC6B03"),UIColor.init("#D9C13D"),UIColor.init("#800080"),UIColor.init("#A20E06")]
        // 3. Set ChartData8
        
        pieChartDataSet.sliceSpace = 2
        pieChartDataSet.valueLineWidth = 0
        pieChartDataSet.valueLinePart1Length = 0.4
        pieChartDataSet.valueLinePart2Length = 0
        pieChartDataSet.valueTextColor = .black
        pieChartDataSet.yValuePosition = .outsideSlice
        pieChartDataSet.valueLineVariableLength = false
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        // 4. Assign it to the chart’s data
        pieChartView.data = pieChartData
        pieChartData.setValueTextColor(.black)
        pieChartData.setValueFont(UIFont(name: "Roboto-Regular", size: 11) ?? UIFont())
        pieChartDataSet.yValuePosition = .outsideSlice
    }
    
    func callEventChartAPI() {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["service": "all"]
        if (APIUtilities.sharedInstance.checkNetworkConnectivity() == "NoAccess") {
            AppData.sharedInstance.alert(message: "Please check your internet connection.", viewController: self) { (alert) in
                AppData.sharedInstance.dismissLoader()
            }
            return
        }
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + EVENTS_GRAPH, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let barchart = res.value(forKey: "barchart") as? [[String:Any]] {
                    for dict in barchart {
                        self.arrLineChart.append(EventLineChart(dict: dict))
                    }
                    self.customizeLineChart(arrChartData: self.arrLineChart)
                }
                if let piechart = res.value(forKey: "piechart") as? [[String:Any]] {
                    for dict in piechart {
                        self.arrPieChart.append(EventPieChart(dict: dict))
                    }
                    self.customizePieChart(event: self.arrPieChart)
                }
            }
        }
    }
}
