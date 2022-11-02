//
//  ImportVC.swift
//  MySunless
//
//  Created by Daydream Soft on 06/07/22.
//

import UIKit
import Alamofire
import GoogleSignIn

class ImportVC: UIViewController, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken {
            getGoogleContacts(token: accessToken)
        }
        
    }

    @IBOutlet weak var importColview: UICollectionView!
    
    var arrImport = [ClientAction]()
    private var accessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrImport = [ClientAction(title: "Google", image: UIImage(named: "google") ?? UIImage()),
                     ClientAction(title: "Outlook", image: UIImage(named: "outlook") ?? UIImage()),
                     ClientAction(title: "Excel", image: UIImage(named: "excel") ?? UIImage())]
        importColview.register(UINib(nibName: "ImporttExportCell", bundle: nil), forCellWithReuseIdentifier: "ImporttExportCell")
        GIDSignIn.sharedInstance().clientID = google_ClientID
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func getGoogleContacts(token: String) {
        
        let urlString = "https://www.google.com/m8/feeds/contacts/default/full?access_token=\(token)&max-results=\(999)&alt=json&v=3.0"
        
        AF.request(urlString, method: .get)
            .responseJSON { response in
                
                switch response.result {
                case .success(let JSON):
                    print(JSON as! NSDictionary)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
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
            var configureError: NSError?
            assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
            GIDSignIn.sharedInstance().clientID = google_ClientID
            GIDSignIn.sharedInstance().scopes =  ["https://www.google.com/m8/feeds","https://www.googleapis.com/auth/user.phonenumbers.read"]
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance()?.presentingViewController = self
            GIDSignIn.sharedInstance().signIn()
        }
}

}
