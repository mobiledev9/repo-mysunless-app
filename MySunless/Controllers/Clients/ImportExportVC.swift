//
//  ImportExportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 17/03/22.
//

import UIKit

class ImportExportVC: UIViewController {
    
     @IBOutlet var tblImportExport: UITableView!
     @IBOutlet var lblHeaderTitle: UILabel!

    var arrImportExport = [ClientAction]()
    var headerTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeaderTitle.text = headerTitle
    }
    
    @IBAction func btnBackClick(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- TableView Delegate and Datasource Methods
extension ImportExportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrImportExport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblImportExport.dequeueReusableCell(withIdentifier: "ImportExportCell", for: indexPath) as! ImportExportCell
        cell.imgView.image = arrImportExport[indexPath.row].image
        cell.lblText.text = arrImportExport[indexPath.row].title
        return cell
    }
}

extension ImportExportVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 //140
    }
}

//MARK:- UITableViewCell Method
class ImportExportCell : UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var cellView: UIView!
    @IBOutlet var lblText: UILabel!
}

  
