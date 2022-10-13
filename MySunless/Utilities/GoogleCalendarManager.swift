//import Foundation
//import GoogleSignIn
//import GoogleAPIClientForREST
//import UIKit
//
//enum GoogleCalendarManagerError: Error {
//    case errorWithText(text: String)
//}
//
//class GoogleCalendarManager: NSObject {
//    static let shared = GoogleCalendarManager()
//     var PresntingVC : UIViewController = UIViewController()
//
//    override private init() {
//        super.init()
//
//        GIDSignIn.sharedInstance().delegate = self
//       // GIDSignIn.sharedInstance()?.uiDelegate = self
//        GIDSignIn.sharedInstance().scopes = authorizationScope
//        GIDSignIn.sharedInstance()?.presentingViewController = PresntingVC
//    }
//
//    fileprivate let authorizationScope = [kGTLRAuthScopeCalendar]
//    fileprivate let service = GTLRCalendarService()
//    fileprivate let calendarTitle = "App Google Calendar"
//}
//
//// MARK: Google authorization
//extension GoogleCalendarManager {
//    //GIDSignIn delegate method will be called and sign in result notification posted
//    func authorize() {
//        GIDSignIn.sharedInstance().signIn()
//    }
//}
//
//// MARK: Public API Events funcs
//extension GoogleCalendarManager {
//    func writeEvents(events: [Event], mode: CalendarService.SyncMode, shouldDeleteOldEvents: Bool) {
//        let eventsToWrite = events.map({ $0.detached() })
//
//        checkCalendar { (exist) in
//            if exist {
//                self.syncEventsToCalendar(events: eventsToWrite, mode: mode, shouldDeleteOldEvents: shouldDeleteOldEvents)
//            } else {
//                self.createCalendar(completion: { (success) in
//                    if success {
//                        self.syncEventsToCalendar(events: eventsToWrite, mode: mode, shouldDeleteOldEvents: shouldDeleteOldEvents)
//                    }
//                })
//            }
//        }
//    }
//
//    func deleteAllEvents(completion: @escaping (_ success: Bool) -> Void) {
//        guard let calID = calendarID else { return }
//        let eventsQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calID)
//
//        service.executeQuery(eventsQuery) { (ticket, response, error) in
//            do {
//                if let error = error {
//                    throw GoogleCalendarManagerError.errorWithText(text: error.localizedDescription)
//                }
//
//                guard let eventsList = response as? GTLRCalendar_Events else {
//                    throw GoogleCalendarManagerError.errorWithText(text: "Cannot cast response to GTLRCalendar_Events")
//                }
//
//                guard let events = eventsList.items else {
//                    throw GoogleCalendarManagerError.errorWithText(text: "no events fetched")
//                }
//
//                if events.isEmpty {
//                    print()
//                    print("GoogleCalendarManager - clearEvents - calendar has no events")
//                    completion(true)
//                    return
//                } else {
//                    //Logger.shared.pr
//                    print("GoogleCalendarManager - clearEvents - Start deleting \(events.count) events")
//                }
//
//                //create array to store event delete operations
//                var deleteOperations = [DeleteEventFromGoogleCalendarOperation]()
//
//                // final operation which triggers when all deletion operations complete
//                let onFinishOperation = BlockOperation(block: {
//                    // trigger completion of clearEvents()
//                    print("GoogleCalendarManager - clearEvents - events deleted")
//                    completion(true)
//                })
//
//                for event in events {
//                    let deleteEventQuery = GTLRCalendarQuery_EventsDelete.query(withCalendarId: calID, eventId: event.identifier!)
//                    let deleteEventOperation = DeleteEventFromGoogleCalendarOperation(service: self.service, eventDeletionQuery: deleteEventQuery)
//                    // add dependency to onFinishOperation to wait all instantiated event delete operations
//                    onFinishOperation.addDependency(deleteEventOperation)
//
//                    deleteOperations.append(deleteEventOperation)
//                }
//
//                let queue = OperationQueue()
//                queue.addOperations(deleteOperations, waitUntilFinished: false)
//                queue.addOperation(onFinishOperation)
//            } catch {
//                print("GoogleCalendarManager - clearEvents - error: \(error.localizedDescription)")
//                completion(false)
//            }
//        }
//    }
//}
//
//// MARK: Private event funcs
//fileprivate extension GoogleCalendarManager {
//    func syncEventsToCalendar(events: [Event], mode: CalendarService.SyncMode, shouldDeleteOldEvents: Bool) {
//        func write(events: [Event], mode: CalendarService.SyncMode) {
//            if mode == .trip {
//                let calendarEvents = createTripEvents(events: events)
//                saveEventsToCalendar(events: calendarEvents)
//            } else {
//                let calendarEvents = createFlightEvents(events: events)
//                saveEventsToCalendar(events: calendarEvents)
//            }
//        }
//
//        if shouldDeleteOldEvents {
//            deleteAllEvents { (success) in
//                if success {
//                    write(events: events, mode: mode)
//                } else {
//                    print("GoogleCalendarManager - syncEventsToCalendar - clearEvents - failed")
//                }
//            }
//        } else {
//            self.fetchEventsFromCalendar(completion: { (calEvents) in
//                let filteredEvents = self.filterEvents(events: events, by: calEvents, mode: mode)
//                self.saveEventsToCalendar(events: filteredEvents)
//            })
//        }
//    }
//
//    func saveEventsToCalendar(events: [GTLRCalendar_Event]) {
//        guard let calID = calendarID else { return }
//        print("GoogleCalendarManager - saveEventsToCalendar - writing \(events.count) events to calendar")
//        for event in events {
//            let eventSaveQuery = GTLRCalendarQuery_EventsInsert.query(withObject: event, calendarId: calID)
//            self.service.executeQuery(eventSaveQuery, completionHandler: nil)
//        }
//    }
//
//    func fetchEventsFromCalendar(completion: @escaping (_ calendarEvents: [GTLRCalendar_Event]) -> Void) {
//        guard let calID = calendarID else {
//            print("GoogleCalendarManager - eventsFromCalendar - no calendar ID!")
//            completion([GTLRCalendar_Event]())
//            return
//        }
//        let eventsQuery = GTLRCalendarQuery_EventsList.query(withCalendarId: calID)
//
//        service.executeQuery(eventsQuery) { (ticket, response, error) in
//            do {
//                if let error = error {
//                    throw GoogleCalendarManagerError.errorWithText(text: "error while executing events query '\(error.localizedDescription)'")
//                }
//                guard let eventsList = response as? GTLRCalendar_Events else {
//                    throw GoogleCalendarManagerError.errorWithText(text: "Cannot cast response to GTLRCalendar_Events")
//                }
//                guard let events = eventsList.items else {
//                    throw GoogleCalendarManagerError.errorWithText(text: "no events fetched")
//                }
//                completion(events)
//            } catch {
//                print("GoogleCalendarManager - eventsFromCalendar - \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
//// MARK: Calendar events creation
//fileprivate extension GoogleCalendarManager {
//    func createTripEvents(events: [Event]) -> [GTLRCalendar_Event] {
//        var calendarEvents = [GTLRCalendar_Event]()
//        for event in events {
//            guard !event.isInvalidated else { continue }
//            guard !event.deleted else { continue }
//            calendarEvents.append(event.makeGTLRCalendar_Event())
//        }
//        return calendarEvents
//    }
//
//    func createFlightEvents(events: [Event]) -> [GTLRCalendar_Event] {
//        var calendarEvents = [GTLRCalendar_Event]()
//        for event in events {
//            guard !event.deleted else { continue }
//
//            if event.type == .trip {
//                guard let trip = event.trip else { continue }
//                calendarEvents.append(contentsOf: trip.makeFlightsGTLRCalendarEvents())
//            } else {
//                guard let vacation = event.vacation else { continue }
//                calendarEvents.append(vacation.makeGTLRCalendar_Event())
//            }
//        }
//        return calendarEvents
//    }
//
//    //create GTLRCalendar_Event's from Events and filter duplicates
//    func filterEvents(events: [Event], by calendarEvents: [GTLRCalendar_Event], mode: CalendarService.SyncMode) -> [GTLRCalendar_Event] {
//        if mode == .trip {
//            let tripEvents = createTripEvents(events: events)
//            return filter(eventsToWrite: tripEvents, by: calendarEvents)
//        } else {
//            let flightEvents = createFlightEvents(events: events)
//            return filter(eventsToWrite: flightEvents, by: calendarEvents)
//        }
//    }
//
//    private func filter(eventsToWrite: [GTLRCalendar_Event], by existingEvents: [GTLRCalendar_Event]) -> [GTLRCalendar_Event] {
//        return eventsToWrite.filter({ (flightEvent) -> Bool in
//            return !existingEvents.contains(where: { (existingCalEvent) -> Bool in
//                guard let baseCalEventTitle = flightEvent.summary, let existingCalEventTitle = existingCalEvent.summary else { return true }
//                return baseCalEventTitle == existingCalEventTitle
//            })
//        })
//    }
//}
//
//// MARK: Calendar check and creation
//fileprivate extension GoogleCalendarManager {
//    var calendarID: String? {
//        get {
//            guard let id = UserDefaults.standard.value(forKey: "GoogleCalendarManager.calendarIdentifier") as? String else { return nil }
//            return id
//        }
//        set(newValue) {
//            UserDefaults.standard.setValue(newValue, forKey: "GoogleCalendarManager.calendarIdentifier")
//            UserDefaults.standard.synchronize()
//        }
//    }
//
//    func checkCalendar(completion: @escaping (_ exist: Bool) -> Void) {
//        let calendarList = GTLRCalendarQuery_CalendarListList.query()
//
//        service.executeQuery(calendarList) { (ticket, response, error) in
//            do {
//                if let error = error {
//                    completion(false)
//                    throw GoogleCalendarManagerError.errorWithText(text: error.localizedDescription)
//                }
//
//                guard let calendarEntryesResponse = response as? GTLRCalendar_CalendarList else {
//                    completion(false)
//                    return
//                }
//
//                guard let entryList = calendarEntryesResponse.items, !entryList.isEmpty else {
//                    completion(false)
//                    return
//                }
//
//                if let calendarEntry = entryList.filter({ $0.summary == self.calendarTitle }).first {
//                    self.calendarID = calendarEntry.identifier
//                    completion(true)
//                } else {
//                    completion(false)
//                }
//            } catch {
//                print("GoogleCalendarManager - checkCalendar - error: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func createCalendar(completion: @escaping (_ created: Bool) -> Void) {
//        let calendar = GTLRCalendar_Calendar()
//        calendar.summary = calendarTitle
//
//        let createCalendarQuery = GTLRCalendarQuery_CalendarsInsert.query(withObject: calendar)
//
//        service.executeQuery(createCalendarQuery) { (ticket, response, error) in
//            do {
//                if let error = error {
//                    completion(false)
//                    throw GoogleCalendarManagerError.errorWithText(text: error.localizedDescription)
//                }
//
//                guard let responseCalendar = response as? GTLRCalendar_Calendar else {
//                    completion(false)
//                    return
//                }
//
//                self.calendarID = responseCalendar.identifier
//
//                let calendarListEntry = GTLRCalendar_CalendarListEntry()
//                calendarListEntry.identifier = responseCalendar.identifier
//
//                var reminders = [GTLRCalendar_EventReminder]()
//                let reminder = GTLRCalendar_EventReminder()
//                reminder.method = "popup"
//                reminder.minutes = 60
//                reminders.append(reminder)
//                calendarListEntry.defaultReminders = reminders
//
//                calendarListEntry.backgroundColor = "#0433FF"
//                calendarListEntry.foregroundColor = "#FFFFFF"
//                calendarListEntry.selected = true
//                calendarListEntry.hidden = false
//
//                let insertCalendarEntryQuery = GTLRCalendarQuery_CalendarListInsert.query(withObject: calendarListEntry)
//                insertCalendarEntryQuery.colorRgbFormat = true
//
//                self.service.executeQuery(insertCalendarEntryQuery, completionHandler: { (_, _, error) in
//                    if let err = error {
//                        completion(false)
//                        print("CalendarManager - createCalendar - error: \(err.localizedDescription)")
//                    } else {
//                        completion(true)
//                    }
//                })
//            } catch {
//                print("CalendarManager - createCalendar - error: \(error.localizedDescription)")
//            }
//        }
//    }
//}
//
//// MARK: GIDSignInDelegate
//extension GoogleCalendarManager: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        let nc = NotificationCenter.default
//        if let err = error {
//            nc.post(name: Constants.NotificationName.googleCalendarManagerDidUnsuccessfullyLoggedInNotification, object: nil, userInfo: ["errorText": err.localizedDescription])
//        } else {
//            service.authorizer = user.authentication.fetcherAuthorizer()
//            nc.post(name: Constants.NotificationName.googleCalendarManagerDidSuccessfullyLoggedInNotification, object: nil)
//        }
//    }
//}
//
//// MARK: GIDSignInUIDelegate
//extension GoogleCalendarManager: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        if var topController = UIApplication.shared.keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//            topController.present(viewController, animated: true, completion: nil)
//        }
//    }
//
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        viewController.dismiss(animated: true, completion: nil)
//    }
//}
//
