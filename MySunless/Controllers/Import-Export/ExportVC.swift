//
//  ExportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 06/07/22.
//

import UIKit

class ExportVC: UIViewController {

    @IBOutlet weak var tblExport: UITableView!
    
    var arrExport = [ClientAction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrExport = [ClientAction(title: "Excel", image: UIImage(named: "excel") ?? UIImage()), ClientAction(title: "Google", image: UIImage(named: "google") ?? UIImage()), ClientAction(title: "One Drive", image: UIImage(named: "icloud") ?? UIImage()), ClientAction(title: "DropBox", image: UIImage(named: "dropbox") ?? UIImage())]
        tblExport.register(UINib(nibName: "ImportExportCell", bundle: nil), forCellReuseIdentifier: "ImportExportCell")
        tblExport.tableFooterView = UIView()
        
    }
}

extension ExportVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrExport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblExport.dequeueReusableCell(withIdentifier: "ImportExportCell", for: indexPath) as! ImportExportCell
        cell.lblName.text = arrExport[indexPath.row].title
        cell.imgview.image = arrExport[indexPath.row].image
        return cell
    }
}

extension ExportVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
