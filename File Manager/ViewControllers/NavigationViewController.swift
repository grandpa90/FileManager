//
//  NavigationViewController.swift
//  File Manager
//
//  Created by Zakaria Darwish on 11/11/2023.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .primary
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        
        self.navigationController?.navigationBar.barTintColor = UIColor.primary

        // Set the tint color for items in the navigation bar (e.g., buttons, titles)
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // Set the title text color in the navigation bar
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        // Make the navigation bar non-translucent
        self.navigationController?.navigationBar.isTranslucent = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

//
//        if #available(iOS 13.0, *) {
//            let appearance = UINavigationBarAppearance()
//            appearance.backgroundColor = Constants.AppColors.blueHeader
//            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
//
//            navigationController?.navigationBar.standardAppearance = appearance
//            navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
