//
//  HomeViewController.swift
//  File Manager
//
//  Created by Zakaria Darwish on 10/11/2023.
//

import UIKit


import AppLovinSDK
import MBCircularProgressBar
import Foundation
//import RxSwift
//import RxCocoa

class HomeViewController: UIViewController , MAAdViewAdDelegate{
//    let disposeBag = DisposeBag()
//    let viewModel = DataViewModel()
    @IBOutlet weak var memoryUsageLabel: UILabel!
    @IBOutlet weak var cpuUsageLabel: UILabel!
    
    @IBOutlet weak var storageUsageLabel: UILabel!
    
    
    var interstitialAd: MAInterstitialAd!
        var retryAttempt = 0.0
    
    func createInterstitialAd()
        {
            interstitialAd = MAInterstitialAd(adUnitIdentifier: "61107cf9dc941b99")
            interstitialAd.delegate = self
            interstitialAd.load()
        
        }

    func didExpand(_ ad: MAAd) {
        
    }
    
    func didCollapse(_ ad: MAAd) {
        
    }
    
    func didLoad(_ ad: MAAd) {
        retryAttempt = 0
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        printContent(error)
        print("errorAD", error)
        
        retryAttempt += 1
        let delaySec = pow(2.0, min(6.0, retryAttempt))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
            self.interstitialAd.load()
        }
    }
    
    func didDisplay(_ ad: MAAd) {
        
    }
    
    func didHide(_ ad: MAAd) {
        interstitialAd.load()
    }
    
    func didClick(_ ad: MAAd) {
        
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        printContent(error)
        print("errorAD", error)
        interstitialAd.load()
    }
    

    


    
    
    
    
    @IBOutlet weak var memoryProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var cpuProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var storageProgressBar: MBCircularProgressBarView!
    
    @IBOutlet weak var parentStackView: UIStackView!
    
    var adView: MAAdView!

    // labels
    func createBannerAd()
     {
       adView = MAAdView(adUnitIdentifier: "39c296e9e49873e5")
       adView.delegate = self

       // Banner height on iPhone and iPad is 50 and 90, respectively
       let height: CGFloat = (UIDevice.current.userInterfaceIdiom == .pad) ? 90 : 50

       // Stretch to the width of the screen for banners to be fully functional
       let width: CGFloat = UIScreen.main.bounds.width

         adView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-125, width: width, height: height)

       // Set background or background color for banners to be fully functional
         adView.backgroundColor = .white

       view.addSubview(adView)

       // Load the first ad
       adView.loadAd()
     }
    
    
    func cpuUsage() -> Double {
        var kr: kern_return_t
        var task_info_count: mach_msg_type_number_t

        task_info_count = mach_msg_type_number_t(TASK_INFO_MAX)
        var tinfo = [integer_t](repeating: 0, count: Int(task_info_count))

        kr = task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), &tinfo, &task_info_count)

        if kr != KERN_SUCCESS {
            return -1
        }

        var thread_list: thread_act_array_t?
        var thread_count: mach_msg_type_number_t = 0

        kr = task_threads(mach_task_self_, &thread_list, &thread_count)

        if kr != KERN_SUCCESS {
            return -1
        }

        var tot_cpu: Double = 0

        if thread_count > 0 {
            for j in 0 ..< Int(thread_count) {
                var thread_info_count: mach_msg_type_number_t = mach_msg_type_number_t(THREAD_INFO_MAX)
                var thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
                kr = thread_info(thread_list![j], thread_flavor_t(THREAD_BASIC_INFO), &thinfo, &thread_info_count)

                if kr != KERN_SUCCESS {
                    return -1
                }

                let threadBasicInfo = convertThreadInfoToThreadBasicInfo(thinfo)

                if threadBasicInfo.flags != TH_FLAGS_IDLE {
                    tot_cpu += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
                }
            }
        }

        return tot_cpu
    }

    func convertThreadInfoToThreadBasicInfo(_ threadInfo: [integer_t]) -> thread_basic_info {
        var result = thread_basic_info()

        result.user_time = time_value_t(seconds: threadInfo[0], microseconds: threadInfo[1])
        result.system_time = time_value_t(seconds: threadInfo[2], microseconds: threadInfo[3])
        result.cpu_usage = threadInfo[4]
        result.policy = threadInfo[5]
        result.run_state = threadInfo[6]
        result.flags = threadInfo[7]
        result.suspend_count = threadInfo[8]
        result.sleep_time = threadInfo[9]

        return result
    }

    
    
    func getMemoryUsage() -> Double {
        let processInfo = ProcessInfo.processInfo
         let totalMemory = Double(processInfo.physicalMemory)

         var info = mach_task_basic_info()
         var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info_data_t>.size / MemoryLayout<integer_t>.size)

         let kr = withUnsafeMutablePointer(to: &info) {
             $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                 task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
             }
         }

         if kr == KERN_SUCCESS {
             let usedMemory = Double(info.resident_size)
             let usedMemoryPercentage = (usedMemory / totalMemory) * 100.0
             return usedMemoryPercentage
         } else {
             return -1
         }
    }
    
    
    func getStorageInformation() {
        do {
               let fileManager = FileManager.default

               // Get the URL of the document directory
               if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                   
                   // Retrieve the file system attributes of the document directory
                   let attributes = try fileManager.attributesOfFileSystem(forPath: documentDirectory.path)
                   
                   // Total size of the file system in bytes
                   if let totalSize = attributes[.systemSize] as? NSNumber {
                       print("Total Size: \(totalSize.doubleValue / (1024 * 1024)) MB")
                   }

                   // Available size of the file system in bytes
                   if let freeSize = attributes[.systemFreeSize] as? NSNumber {
                       print("Free Size: \(freeSize.doubleValue / (1024 * 1024)) MB")
                   }
                    
                   // Used size of the file system in bytes
                   if let usedSize = attributes[.systemSize] as? NSNumber, let freeSize = attributes[.systemFreeSize] as? NSNumber {
                       let totalSize = attributes[.systemSize] as? NSNumber
                       let totalSizeInBytes = totalSize!.int64Value
                       let usedSizeInBytes = usedSize.int64Value - freeSize.int64Value
                       let usedPercentage = Double(usedSizeInBytes) / Double(totalSizeInBytes) * 100

                       storageProgressBar.value = usedPercentage
                
                       storageUsageLabel.text = String(format: "%.2f", (Double(usedSizeInBytes) / (1024 * 1024 * 1024))) + " GB"

                       print("Used Size: \(Double(usedSizeInBytes) / (1024 * 1024)) MB")
                   }
               }
           } catch {
               print("Error retrieving storage information: \(error)")
           }
    }

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBannerAd()
        getStorageInformation()
        cpuUsageLabel.text = String(format: "%.2f", cpuUsage()) + " %"
        cpuProgressBar.value = cpuUsage()
        memoryUsageLabel.text = String(format: "%.2f", getMemoryUsage()) + " %"
        memoryProgressBar.value = getMemoryUsage()
        createInterstitialAd()
  
//        print("CPU Usage: \(usage)%")

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if interstitialAd.isReady{
            interstitialAd.show()
        }
        
//        viewModel.dataObservable
//                    .subscribe(onNext: { [weak self] data in
//
//                    })
//                    .disposed(by: disposeBag)
    }

    @IBAction func getScreenshotPhoto(_ sender: Any) {
        if interstitialAd.isReady{
            interstitialAd.show()
        }
        UserDefaults.standard.set("SC", forKey: "myKey")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "screenshotSegue", sender: self)

    }
    
    
    @IBAction func getPhoto(_ sender: Any) {
        if interstitialAd.isReady{
            interstitialAd.show()
        }
        UserDefaults.standard.set("PH", forKey: "myKey")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "photoSegue", sender: self)

    }
    // MARK: - Navigation

    @IBAction func getCameraPhoto(_ sender: Any) {
        if interstitialAd.isReady{
            interstitialAd.show()
        }
        UserDefaults.standard.set("CA", forKey: "myKey")
        UserDefaults.standard.synchronize()
        performSegue(withIdentifier: "cameraSegue", sender: self)

    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "photoSegue" || segue.identifier == "cameraSegue"  || segue.identifier == "screenshotSegue" {
            if segue.destination is photosCollectionViewController {
                   // Pass data to the destination view controller
                   //destinationVC.photoType = ""
                   //destinationVC.photoType
                
                   
               }
            
            
           }
    }
    

}
