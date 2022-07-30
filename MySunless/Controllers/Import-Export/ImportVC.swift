//
//  ImportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 06/07/22.
//

import UIKit

class ImportVC: UIViewController {

    @IBOutlet weak var importColview: UICollectionView!
    
    var arrImport = [ClientAction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrImport = [ClientAction(title: "Excel", image: UIImage(named: "excel") ?? UIImage())]
        importColview.register(UINib(nibName: "ImporttExportCell", bundle: nil), forCellWithReuseIdentifier: "ImporttExportCell")
    }
}

extension ImportVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImport.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = importColview.dequeueReusableCell(withReuseIdentifier: "ImporttExportCell", for: indexPath) as! ImporttExportCell
        cell.lblName.text = arrImport[indexPath.row].title
        cell.imgView.image = arrImport[indexPath.row].image
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (importColview.frame.size.width-20) / 2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
