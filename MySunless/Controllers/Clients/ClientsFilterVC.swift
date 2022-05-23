//
//  ClientsFilterVC.swift
//  MySunless
//
//  Created by iMac on 17/03/22.
//

import UIKit
import iOSDropDown

class ClientsFilterVC: UIViewController {

    @IBOutlet var vw_main: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet var vw_chooseUser: UIView!
    @IBOutlet var txtChooseUser: DropDown!
    
    //MARK:- Variable Declarations
    var token = String()
    var arrChooseUser = [ChooseUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInitially()
    }
    
    //MARK:- UserDefined Functions
    func setInitially() {
        vw_main.layer.borderWidth = 1.0
        vw_main.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vw_chooseUser.layer.borderWidth = 0.5
        vw_chooseUser.layer.borderColor = UIColor.init("#15B0DA").cgColor
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitClick(_ sender: UIButton) {
    }
    
    @IBAction func btnResetClick(_ sender: UIButton) {
    }
    
}
