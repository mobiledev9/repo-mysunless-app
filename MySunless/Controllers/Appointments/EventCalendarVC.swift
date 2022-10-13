//
//  EventCalendarVC.swift
//  MySunless
//
//  Created by Daydream Soft on 04/04/22.
//

import UIKit
import FSCalendar
import Alamofire
import GoogleSignIn
import GoogleAPIClientForREST


class EventCalendarVC: UIViewController, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //
       getEvents(for:"primary")
        
    }
    
    
    //MARK:- Outlets
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var tblCalendarEvent: UITableView!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrEventDate  = [String?]()
    var arrAppointment = [ShowAppointmentList]()
    var arrEvents = [ShowAppointmentList]()
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate lazy var calendarService: GTLRCalendarService? = {
        let service = GTLRCalendarService()
        service.shouldFetchNextPages = true

        service.isRetryEnabled = true
        service.maxRetryInterval = 15

        guard let currentUser = GIDSignIn.sharedInstance().currentUser,
            let authentication = currentUser.authentication else {
                return nil
        }

        service.authorizer = authentication.fetcherAuthorizer()
        return service
    }()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initGoogle()
        token = UserDefaults.standard.value(forKey: "token") as? String ?? ""
        customizedCalendar()
        fsCalendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
        fsCalendar.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callShowListAppointment()
    }
    
    //MARK:- User-Defined Functions
    func customizedCalendar() {
        fsCalendar.appearance.weekdayTextColor = UIColor.red
        fsCalendar.appearance.headerTitleColor = UIColor.init("15B0DA")
        fsCalendar.appearance.selectionColor = UIColor.init("15B0DA")
        fsCalendar.appearance.todayColor = UIColor.orange
        fsCalendar.appearance.borderRadius = 5
        fsCalendar.appearance.subtitleFont = UIFont(name: "Roboto-Bold", size: 10)
        fsCalendar.appearance.subtitleOffset = CGPoint(x: 0, y: 0)
    }
    
    func setEventDate(arrAppointment :[ShowAppointmentList]) {
        let arr = arrAppointment.map({$0.eventDate?.stringBefore(" ")})
        self.arrEventDate = arr
        fsCalendar.reloadData()
        tblCalendarEvent.reloadData()
    }
    
    func callShowListAppointment() {
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
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + LIST_APPOINTMENT, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let response = res.value(forKey: "response") as? [[String:Any]] {
                            self.arrAppointment.removeAll()
                            self.arrEvents.removeAll()
                            for dict in response {
                                self.arrAppointment.append(ShowAppointmentList(dictionary: dict as NSDictionary)!)
                            }
                            self.setEventDate(arrAppointment: self.arrAppointment)
                        }
                    } else {
                        if let response = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: response, viewController: self)
                            self.arrAppointment.removeAll()
                            
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- Actions
    @IBAction func btnBookAppntsClick(_ sender: UIButton) {
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "BookAppointmentVC") as! BookAppointmentVC
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    @IBAction func btnGSync(_ sender: UIButton) {
     
        GIDSignIn.sharedInstance().signIn()
        //initGoogle()
        
}
    func initGoogle() {
        // Initialize sign-in
        var configureError: NSError?
       // GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        GIDSignIn.sharedInstance().clientID = google_ClientID
        GIDSignIn.sharedInstance().scopes = ["https://www.googleapis.com/auth/calendar"]
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    // you will probably want to add a completion handler here
    func getEvents(for calendarId: String) {
        guard let service = self.calendarService else {
            return
        }

        // You can pass start and end dates with function parameters
        let startDateTime = GTLRDateTime(date: Calendar.current.startOfDay(for: Date()))
        let endDateTime = GTLRDateTime(date: Date().addingTimeInterval(60*60*24))

        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarId)
        eventsListQuery.timeMin = startDateTime
        eventsListQuery.timeMax = endDateTime

        _ = service.executeQuery(eventsListQuery, completionHandler: { (ticket, result, error) in
            guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
                return
            }

            if items.count > 0 {
                print(items)
                // Do stuff with your events
            } else {
                // No events
            }
        })
    }
    
    
}

//MARK:- FSCalendar Delegate and Datasource Methods
extension EventCalendarVC: FSCalendarDelegate,FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        return day
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let dateString = self.dateFormatter2.string(from: date)
        if arrEventDate.contains(dateString) {
            let arr = arrAppointment.filter{$0.eventDate?.stringBefore(" ") == dateString}
            let arrstr : [String] = arr.map{$0.title ?? " "}
            return arrstr.joined(separator: ",")
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        return UIImage()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell: FSCalendarCell = calendar.dequeueReusableCell(withIdentifier: "CELL", for: date, at: position)
        return cell;
    }
    
    // This delegate call when date is selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateString = self.dateFormatter2.string(from: date)
        if arrEventDate.contains(dateString) {
            let arr = arrAppointment.filter{$0.eventDate?.stringBefore(" ") == dateString}
            
            if arr.count > 0 {
                self.arrEvents = arr
                DispatchQueue.main.async {
                    self.tblCalendarEvent.reloadData()
                }
                return
            } else {
                self.arrEvents.removeAll()
                tblCalendarEvent.reloadData()
            }
            
        }
        self.arrEvents.removeAll()
        tblCalendarEvent.reloadData()
        
    }
    
    // This delegate call when date is DeSelected
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if arrEventDate.contains(dateString) {
            return arrEventDate.filter{$0 == dateString}.count
        }
        return 0
    }
}

//MARK:- UITableview Delegate and Datasource Methods
extension EventCalendarVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrEvents.count > 0 {
            let cell = tblCalendarEvent.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
            cell.lblEvent.text = arrEvents[indexPath.row].title
            cell.lblTime.text = arrEvents[indexPath.row].eventDate?.stringAfter(" ")
            cell.setViewColor(eventStatus: arrEvents[indexPath.row].eventstatus!)
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
        VC.appointment = arrEvents[indexPath.row]
        navigationController?.pushViewController(VC, animated: true)
    }
    
}

//MARK:- Calendar Tableview Cell
class CalendarCell : UITableViewCell {
    
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    func setViewColor(eventStatus:String) {
        switch eventStatus.lowercased() {
            case "completed" :
                self.cellView.backgroundColor = UIColor.black
            case "pending" :
              //  self.cellView.backgroundColor = UIColor.init("￼#FFE604")
                self.cellView.backgroundColor = UIColor.systemYellow
            case "confirmed" :
              //  self.cellView.backgroundColor = UIColor.init("￼#00D33C")
                self.cellView.backgroundColor = UIColor.systemGreen
            case "canceled" :
             //   self.cellView.backgroundColor = UIColor.init("￼#FF0004")
                cellView.backgroundColor = UIColor.systemPink
            case "pending-payment" :
              //  self.cellView.backgroundColor = UIColor.init("￼#4A54AA")
                self.cellView.backgroundColor = UIColor.systemIndigo
            case "in-progress" :
               // self.cellView.backgroundColor = UIColor.init("￼#FF8224")
                self.cellView.backgroundColor = UIColor.orange
            default:
                // cellView.backgroundColor = UIColor.init("￼#FF0004")
                print("nothing")
        }
    }
}
