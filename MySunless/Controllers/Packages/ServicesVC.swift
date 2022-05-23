//
//  ServicesVC.swift
//  MySunless
//
//  Created by iMac on 21/01/22.
//

import UIKit

protocol SelectServiceDelegate {
   func didSelectServices(selectedService:[Int])
}

class ServicesVC: UIViewController {
    @IBOutlet var tblServiceList: UITableView!
    
    var token = String()
    var arrOfService = [SelectServiceData]()
    var arrSelectedServiceId  = [Int]()
    var delegate : SelectServiceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblServiceList.allowsMultipleSelection = true
        tblServiceList.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
   
    @IBAction func btnDoneClick(_ sender: Any) {
        self.delegate?.didSelectServices(selectedService:arrSelectedServiceId)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  
}
//MARK:- TableView Delegate and Datasource Methods
extension ServicesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOfService.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = arrOfService[indexPath.row].id
        let cell = tblServiceList.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
            cell.lblServiceName.text = arrOfService[indexPath.row].serviceName
        if arrSelectedServiceId.contains(value) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

extension ServicesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = arrOfService[indexPath.row].id
        if arrSelectedServiceId.contains(value) {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
                arrSelectedServiceId = arrSelectedServiceId.filter{$0 != value }
            }
        } else {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
                arrSelectedServiceId.append(value)
            }
        }
        
     }
    
}
