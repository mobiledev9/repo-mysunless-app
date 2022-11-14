//
//  ImportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 06/07/22.
//

import UIKit
import Alamofire
import MobileCoreServices

class ImportVC: UIViewController {
  @IBOutlet weak var importColview: UICollectionView!
    
    var arrImport = [ClientAction]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrImport = [ClientAction(title: "Google", image: UIImage(named: "google") ?? UIImage()),
                     ClientAction(title: "Outlook", image: UIImage(named: "outlook") ?? UIImage()),
                     ClientAction(title: "Excel", image: UIImage(named: "excel") ?? UIImage())]
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let VC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GoogleContactListVC") as! GoogleContactListVC
            navigationController?.pushViewController(VC, animated: true)
        }
        if indexPath.item == 2 {
            
        }
}

}

//extension ImportVC : UIDocumentPickerDelegate  {
//
//
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//            var selectedFileData = [String:String]()
//        let file = urls[0]
//            do{
//                let fileData = try Data.init(contentsOf: file.absoluteURL)
//
//                selectedFileData["filename"] = file.lastPathComponent
//                selectedFileData["data"] = fileData.base64EncodedString(options: .lineLength64Characters)
//                print(selectedFileData)
//
//                var spreadsheet: BRAOfficeDocumentPackage = BRAOfficeDocumentPackage.open(urls[0].absoluteString)
//                var firstWorksheet: BRAWorksheet = spreadsheet.workbook.worksheets[0] as! BRAWorksheet
//                var string: String = firstWorksheet.cell(forCellReference: "B6").stringValue()
//                 print(string)
//            }catch{
//                print("contents could not be loaded")
//            }
//        }
//
//    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//           controller.dismiss(animated: true, completion: nil)
//       }
//}
