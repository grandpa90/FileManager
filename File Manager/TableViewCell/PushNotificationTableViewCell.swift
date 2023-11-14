//
//  PushNotificationTableViewCell.swift
//  File Manager
//
//  Created by Zakaria Darwish on 12/11/2023.
//

import UIKit
import OneSignalInAppMessages
import OneSignalFramework

class PushNotificationTableViewCell: UITableViewCell {
    
 
    @IBAction func pushNotificationValueChanged(_ sender: UISwitch) {
        if sender.isOn {
        }
        else {
           // OneSignal.Notifications.clearAll()
            //OneSignal.setSubject(<#T##String#>)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
