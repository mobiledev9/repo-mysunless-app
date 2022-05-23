//
//  AppData.swift
//  MySunless
//
//  Created by iMac on 06/10/21.
//

import Foundation
import UIKit
import SVProgressHUD
import SCLAlertView

class AppData: NSObject {
    
    static let sharedInstance = AppData()
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            
            {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
    func isValidpassword(passwordString : String) -> Bool {
        let passwordreg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: passwordString)
    }
    
    func textLimitForPhone(existingText: String?, newText: String, limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }

    func showAlert(title: String, message: String, viewController : UIViewController)->Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (dd) -> Void in
            
        }
        alert.addAction(action1)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func alert(message: String, viewController : UIViewController, completionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let action1 = UIAlertAction(title: "OK", style: .default, handler: completionHandler)
        alert.addAction(action1)
        viewController.self.present(alert, animated: true, completion: nil)
    }
    
    func showSCLAlert(alertMainTitle: String, alertTitle: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertMainTitle, subTitle: alertTitle)
    }
    
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    func dismissLoader() {
        if(SVProgressHUD.isVisible()) {
            SVProgressHUD.dismiss()
        }
    }

    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MMM d, yyyy"
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    func convertToUTC(dateToConvert:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var convertedDate = formatter.date(from: dateToConvert)
        formatter.timeZone = TimeZone(identifier: "UTC")
        let date = formatter.date(from: dateToConvert)
        convertedDate = Calendar.current.date(byAdding: .minute, value: 330, to: date ?? Date())
        return formatter.string(from: convertedDate!)
    }
    
    func dayOfTheWeek(dateString:String) -> String? {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd h:mma"
        
        if let givenDate = dateFormatter.date(from: dateString) {
            let calendar: NSCalendar = NSCalendar.current as NSCalendar
            let components: NSDateComponents = calendar.components(.weekday, from: givenDate) as NSDateComponents
            return weekdays[components.weekday - 1]
        }
        return nil
        
    }
    func converterDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-mm-dd h:mma"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }
        return nil
    }
}
