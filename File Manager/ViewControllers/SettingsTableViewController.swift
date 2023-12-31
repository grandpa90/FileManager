//
//  SettingsTableViewController.swift
//  File Manager
//
//  Created by Zakaria Darwish on 12/11/2023.
//

import UIKit
import MessageUI
import AppLovinSDK

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate,MAAdViewAdDelegate {
    
    var adView: MAAdView!

    
    func didExpand(_ ad: MAAd) {
        
    }
    
    func didCollapse(_ ad: MAAd) {
        
    }
    
    func didLoad(_ ad: MAAd) {
        
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        
    }
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd) {
        
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        
    }
    
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBAction func pushNotificationValueChanged(_ sender: Any) {
    }
    
    
    func createBannerAd()
     {
       adView = MAAdView(adUnitIdentifier: "e51c6268628f38e0")
       adView.delegate = self

       // Banner height on iPhone and iPad is 50 and 90, respectively
       let height: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 50

       // Stretch to the width of the screen for banners to be fully functional
       let width: CGFloat = UIScreen.main.bounds.width

         adView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-225, width: width, height: height)

       // Set background or background color for banners to be fully functional
         adView.backgroundColor = .white

       view.addSubview(adView)

       // Load the first ad
       adView.loadAd()
     }
    
    
    
    @IBOutlet weak var pushNotificationSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        createBannerAd()
        
        tableView.register(VersionTableViewCell.self, forCellReuseIdentifier: "versionCell")
        tableView.register(AboutUsTableViewCell.self, forCellReuseIdentifier: "aboutUsCell")
        tableView.register(ContactUsTableViewCell.self, forCellReuseIdentifier: "contactUsCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return 3
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row",indexPath.row)
        
        if indexPath.section == 0  && indexPath.row == 0{
            
        }
        
        else if indexPath.section == 1 && indexPath.row == 0 {
            
        }
        
        else if indexPath.section == 1 && indexPath.row == 1 {
            let email = "zakaria.safi.darwish@gmail.com"
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([email])
            mailComposerVC.setSubject("Customer Support")
            self.present(mailComposerVC, animated: true, completion: nil)
        }
        
        else if indexPath.section == 1 && indexPath.row == 2 {
            
        }
        
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let versionCell = tableView.dequeueReusableCell(withIdentifier: "versionCell", for: indexPath) as! VersionTableViewCell
//        let aboutUsCell = tableView.dequeueReusableCell(withIdentifier: "aboutUsCell", for: indexPath) as! AboutUsTableViewCell
//        let contactUsCell = tableView.dequeueReusableCell(withIdentifier: "contactUsCell", for: indexPath) as! ContactUsTableViewCell
//        
//        
//        if indexPath.section == 0 {
//            return versionCell
//        }
//        else if indexPath.section == 1 {
//            return aboutUsCell
//        }
//        
//        else if indexPath.section == 2 {
//            return contactUsCell
//        }
//        
//        else {
//            return UITableViewCell()
//        }
//        
//    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
