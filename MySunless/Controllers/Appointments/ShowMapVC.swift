//
//  ShowMapVC.swift
//  MySunless
//
//  Created by Daydream Soft on 07/05/22.
//

import UIKit
import MapKit

class ShowMapVC: UIViewController {

    @IBOutlet var vw_mainView: UIView!
    @IBOutlet var vw_top: UIView!
    @IBOutlet var vw_bottom: UIView!
    @IBOutlet weak var showMapView: MKMapView!
    @IBOutlet weak var lblAddress: UILabel!
    var addressText : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setInitially()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    func setInitially() {
        vw_mainView.layer.borderWidth = 1.0
        vw_mainView.layer.borderColor = UIColor.init("#005CC8").cgColor
        vw_top.layer.cornerRadius = 12
        vw_top.layer.masksToBounds = true
        vw_top.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        vw_bottom.layer.cornerRadius = 12
        vw_bottom.layer.masksToBounds = true
        vw_bottom.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        lblAddress.text = addressText
 }
 
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}


