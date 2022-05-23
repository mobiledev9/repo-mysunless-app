//
//  EmailTemplateDetailVC.swift
//  MySunless
//
//  Created by iMac on 04/01/22.
//

import UIKit

class EmailTemplateDetailVC: UIViewController {
    
    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblSubject: UILabel!
    @IBOutlet var txtVwMessage: UITextView!
    
    var emailTemplate:ShowTemplate = ShowTemplate(dict:[:])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        txtVwMessage.layer.borderColor = UIColor.gray.cgColor
        txtVwMessage.layer.borderWidth = 0.5
        txtVwMessage.layer.cornerRadius = 8
        txtVwMessage.delegate = self
     }
    
    override func viewWillAppear(_ animated: Bool) {
        lblName.text = emailTemplate.Name
        lblSubject.text = emailTemplate.Subject
        txtVwMessage.setHTMLFromString(htmlText: emailTemplate.TextMassage)
        txtVwMessage.textColor = UIColor.init("#6D778E")
    }
    
    @IBAction func btnClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EmailTemplateDetailVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtVwMessage.resignFirstResponder()
    }
}
