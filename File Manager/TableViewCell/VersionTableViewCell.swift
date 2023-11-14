//
//  VersionTableViewCell.swift
//  File Manager
//
//  Created by Zakaria Darwish on 12/11/2023.
//

import UIKit

class VersionTableViewCell: UITableViewCell {
    @IBOutlet weak var versionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = String(format: "Version:%@", version)
        } else {
            versionLabel.text = "NA"
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
