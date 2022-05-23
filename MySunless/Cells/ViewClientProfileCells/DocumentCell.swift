//
//  DocumentCell.swift
//  MySunless
//
//  Created by Daydream Soft on 24/03/22.
//

import UIKit
import Kingfisher
import SCLAlertView

class DocumentCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnDownload: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    var model = ShowDocument(dict: [:])
    var delegate: AddDocumentProtocol?
    var alertTitle = "Are you sure?"
    var alertSubtitle = "Once deleted, you will lost this file!"
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellView.layer.backgroundColor = UIColor.init("#E5E4E2").cgColor
        cellView.layer.cornerRadius = 12
        imgView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func addDeleteAlert() {
        let alert = SCLAlertView()
        alert.addButton("Yes, delete it!", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, target: self, selector: #selector(deleteClick(_:)))
        alert.addButton("Cancel", backgroundColor: UIColor.init("#E95268"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess(alertTitle, subTitle: alertSubtitle)
    }
    
    func addRestoreAlert(message: String) {
        let alert = SCLAlertView()
        alert.addButton("OK", backgroundColor: UIColor.init("#0ABB9F"), textColor: UIColor.white, font: UIFont(name: "Roboto-Bold", size: 20), showTimeout: nil, action: {
            
        })
        alert.iconTintColor = UIColor.white
        alert.showSuccess("", subTitle: message)
    }
    
    func setCell(index: Int) {
        let imgUrl = URL(string: model.document)
        imgView.kf.setImage(with: imgUrl)
        lblName.text = model.fileName
        btnDelete.tag = index
        btnDownload.tag = index
    }

    @IBAction func btnDownloadClick(_ sender: UIButton) {
        guard let image = imgView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func btnDeleteClick(_ sender: UIButton) {
        addDeleteAlert()
    }
    
    @objc func deleteClick(_ sender: UIButton) {
        delegate?.callDeleteDocumentAPI(id: model.id)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            addRestoreAlert(message: error.localizedDescription)
        } else {
            addRestoreAlert(message: "Image Successfully Downloaded!!")
        }
    }
    
}
