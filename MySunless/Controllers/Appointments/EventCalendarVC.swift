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


class EventCalendarVC: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var tblCalendarEvent: UITableView!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrEventDate  = [String?]()
    var arrAppointment = [ShowAppointmentList]()
    var arrEvents = [ShowAppointmentList]()
    let calendarId = "primary"
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
   // private let scopes = [kGTLRAuthScopeCalendar]
    fileprivate lazy var calendarService: GTLRCalendarService? = {
        let service = GTLRCalendarService()
        service.shouldFetchNextPages = true
        service.isRetryEnabled = true
        service.maxRetryInterval = 15

        guard let currentUser = GIDSignIn.sharedInstance()?.currentUser,
              let authentication: GIDAuthentication = currentUser.authentication else {
                return nil
        }
        service.authorizer = authentication.fetcherAuthorizer()
        return service
    }()
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
       // initGoogle()
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
    
    func callUpdateAppointmentStatusAPI(id: Int, sync: Int) {
        AppData.sharedInstance.showLoader()
        let headers: HTTPHeaders = ["Authorization": token]
        var params = NSDictionary()
        params = ["id": id,
                  "sync": sync
        ]
        APIUtilities.sharedInstance.PpOSTAPICallWith(url: BASE_URL + CHANGE_APPOINTMENT_STATUS, param: params, header: headers) { (respnse, error) in
            AppData.sharedInstance.dismissLoader()
            print(respnse ?? "")
            
            if let res = respnse as? NSDictionary {
                if let success = res.value(forKey: "success") as? String {
                    if success == "1" {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                        }
                    } else {
                        if let message = res.value(forKey: "response") as? String {
                            AppData.sharedInstance.showAlert(title: "", message: message, viewController: self)
                            
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
        
    }
    
    //MARK:- Sync function
    // Create an event to the Google Calendar's user
    func addEventoToGoogleCalendar(summary : String, description :String, startTime : String, endTime : String, eventId:Int) {
        guard let service = self.calendarService else {
            return
        }
        let calendarEvent = GTLRCalendar_Event()
        calendarEvent.summary = "\(summary)"
        calendarEvent.descriptionProperty = "\(description)"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mma"
     
        let startDate = dateFormatter.date(from: startTime)
         let endDate = dateFormatter.date(from: endTime)
        print("startTime :\(startDate)")
        print("endTime :\(endTime)")
        
        guard let toBuildDateStart = startDate else {
            print("Error getting start date")
            return
        }
        guard let toBuildDateEnd = endDate else {
            print("Error getting end date")
            return
        }
        calendarEvent.start = buildDate(date: toBuildDateStart)
        calendarEvent.end = buildDate(date: toBuildDateEnd)
        
        let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: self.calendarId)
        
        calendarService?.executeQuery(insertQuery) { (ticket, object, error) in
            if error == nil {
                self.callUpdateAppointmentStatusAPI(id: eventId, sync: 1)
                print("Event inserted")
            } else {
                print(error)
            }
        }
    }
    
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
        let datetime = GTLRDateTime(date: date)
        let dateObject = GTLRCalendar_EventDateTime()
        dateObject.dateTime = datetime
        return dateObject
    }
    
    // Initialize sign-in
//    func initGoogle() {
//        var configureError: NSError?
//        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
//
//        GIDSignIn.sharedInstance.clientID = google_ClientID
//        GIDSignIn.sharedInstance.scopes = [kGTLRAuthScopeCalendar,kGTLRAuthScopeCalendarEvents]
//        GIDSignIn.sharedInstance.delegate = self
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//    }
//
    // you will probably want to add a completion handler here
    func getEvents(for calendarId: String) {
        guard let service = self.calendarService else {
            return
        }
        
        // You can pass start and end dates with function parameters
        let startDateTime = GTLRDateTime(date: Calendar.current.startOfDay(for:Date()))
        let endDateTime = GTLRDateTime(date: Date().addingTimeInterval(60*60*24))
        let oneMonthAfter = GTLRDateTime(date: Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date())
        
        let eventsListQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calendarId)
       // eventsListQuery.timeMin = oneMonthAfter
      eventsListQuery.timeMax = oneMonthAfter
        
        
        _ = service.executeQuery(eventsListQuery, completionHandler: { (ticket, result, error) in
            guard error == nil, let items = (result as? GTLRCalendar_Events)?.items else {
                return
            }
            
            if items.count > 0 {
                print(items)
             } else {
                print("no event in google calendar")
            }
        })
    }
}

//MARK:- FSCalendar Delegate and Datasource Methods
extension EventCalendarVC: FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        return day
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let dateString = self.dateFormatter2.string(from: date)
//        if arrEventDate.contains(dateString) {
//            let arr = arrAppointment.filter{$0.eventDate?.stringBefore(" ") == dateString}
//            let arrstr : [String] = arr.map{$0.title ?? " "}
//            return arrstr.joined(separator: ",")
    //    }
        return nil
    }
   
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell: FSCalendarCell = calendar.dequeueReusableCell(withIdentifier: "CELL", for: date, at: position)
        cell.eventIndicator.color = UIColor.init("15B0DA")
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
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let dateString =  self.dateFormatter2.string(from: date)
        if arrEventDate.contains(dateString) {
            return [UIColor.init("15B0DA")]
        }
        return [UIColor.yellow]
       
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

//MARK:- google sync
extension EventCalendarVC : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.calendarService?.authorizer = nil
        } else {
            self.calendarService?.authorizer = user.authentication.fetcherAuthorizer()
            // getEvents(for: calendarId)
            let arrSyncItem : [ShowAppointmentList] = arrAppointment.filter{$0.sync == 0}
            if arrSyncItem.count > 0 {
                for item in arrSyncItem {
                    if item.sync == 0 {
                        addEventoToGoogleCalendar(summary: item.title ?? "",
                                                  description: item.description ?? "",
                                                  startTime: item.eventDate ?? "",
                                                  endTime: item.end_date ?? "", eventId: item.id!)
                    }
                    
                    if arrSyncItem.last!.id ==  item.id {
                        AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle:"Events Synced Successfully with Google!")
                    }
                }
            } else {
                AppData.sharedInstance.showSCLAlert(alertMainTitle: "", alertTitle:"No new event to Sync!")
            }
        }
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
