//
//  ImportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 06/07/22.
//

import UIKit

class ImportVC: UIViewController {

    @IBOutlet weak var tblImport: UITableView!
    
    var arrImport = [ClientAction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrImport = [ClientAction(title: "Excel", image: UIImage(named: "excel") ?? UIImage())]
        tblImport.register(UINib(nibName: "ImportExportCell", bundle: nil), forCellReuseIdentifier: "ImportExportCell")
        tblImport.tableFooterView = UIView()
    }
}

extension ImportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrImport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblImport.dequeueReusableCell(withIdentifier: "ImportExportCell", for: indexPath) as! ImportExportCell
        cell.lblName.text = arrImport[indexPath.row].title
        cell.imgview.image = arrImport[indexPath.row].image
        return cell
    }
}

extension ImportVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
