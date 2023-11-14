//
//  Extension.swift
//  File Manager
//
//  Created by Zakaria Darwish on 11/11/2023.
//

import Foundation
import UIKit

extension Bundle {
    
      var versionNumber: String? {
          return infoDictionary?["CFBundleShortVersionString"] as? String
      }

      var buildNumber: String? {
          return infoDictionary?["CFBundleVersion"] as? String
      }

      var bundleName: String? {
          return infoDictionary?["CFBundleName"] as? String
      }
    
    var getVersionNumber: Double? {
        let ver = infoDictionary?["CFBundleShortVersionString"] as? String
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "EN") as Locale
        let number = numberFormatter.number(from: ver!)
        let verNb = number?.doubleValue
        return verNb
    }
    
    var appDisplayName: String {
        return (object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
    }
    
    var getBundleNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String ?? "")
    }
}

extension UIApplication {
    static var build:String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String? ?? "x"
    }
    
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String? ?? "x.x"
    }
    
 
}
