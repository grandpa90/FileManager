//
//  photosCollectionViewController.swift
//  File Manager
//
//  Created by Zakaria Darwish on 14/11/2023.
//

import UIKit
import UIKit
import Photos
import FirebaseCoreInternal
import FirebaseStorage
import Firebase

class photosCollectionViewController: UICollectionViewController {
    private let reuseIdentifier = "photoCell"
    var photoType = ""
    var fetchedAssets: [PHAsset] = []
    var image:[UIImage] = []
    var fetchResult: PHFetchResult<PHAsset>!
    var selectedIndexes: [IndexPath] = []
    var selectedImage:[UIImage] = []
    
    
    func uploadImageToFirestore(image: UIImage) {
           guard let imageData = image.jpegData(compressionQuality: 0.8) else {
               return
           }

           // Create a unique filename or use a timestamp for the image
           let filename = "image_\(Date().timeIntervalSince1970).jpg"

           // Create a reference to the Firebase Storage location where you want to upload the image
           let storageRef = Storage.storage().reference().child("images").child(filename)

           // Upload the image data to Firebase Storage
           let uploadTask = storageRef.putData(imageData, metadata: nil) { (_, error) in
               if let error = error {
                   print("Error uploading image: \(error.localizedDescription)")
                   return
               }

               // If successful, get the download URL of the uploaded image
               storageRef.downloadURL { (url, error) in
                   if let downloadURL = url {
                       // Save the downloadURL or other information in Firestore here
                       self.saveImageURLToFirestore(url: downloadURL.absoluteString)
                   } else if let error = error {
                       print("Error getting download URL: \(error.localizedDescription)")
                   }
               }
           }
           
//                // Optionally, you can track the upload progress
//                uploadTask.observe(.progress) { snapshot in
//                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
//                    print("Upload progress: \(percentComplete)%")
//                }
       }

       func saveImageURLToFirestore(url: String) {
           // Save the image URL to Firestore (Add to a collection or document)
           // Here, you can add the URL to a Firestore collection along with other metadata if needed
           let db = Firestore.firestore()
           db.collection("images").addDocument(data: ["imageUrl": url]) { error in
//                    if let error = error {
//                        print("Error adding document: \(error.localizedDescription)")
//                    } else {
//                        print("Document added with ID: \(documentReference!.documentID)")
//                    }
           }
       }
    
     func deleteSelectedPhotos() {
        
         
         
         for img in selectedImage {
             deleteImageFromGallery(image: img)
         }
         
         
         
                        
        
//        guard var selectedIndexPaths = collectionView.indexPathsForSelectedItems else {
//            return
//        }
//        
//        guard !selectedIndexPaths.isEmpty else {
//            // No items selected, handle accordingly
//            return
//        }
//        
//        let assetsToDelete = selectedIndexes.compactMap { indexPath -> PHAsset? in
//                 guard indexPath.item < fetchedAssets.count else { return nil }
//            return self.fetchedAssets[indexPath.item]
//             }
//        
//        PHPhotoLibrary.shared().performChanges({
//            // Create a request to delete assets
//            let assetsToDelete: [PHAsset] = self.selectedIndexes.compactMap { indexPath in
//                guard indexPath.item < self.self.fetchResult.count else { return nil }
//                return self.self.fetchResult[indexPath.item]
//                   }
//            
//            // Optionally add completion block
//            PHAssetChangeRequest.deleteAssets(assetsToDelete as NSFastEnumeration)
//            
//        }, completionHandler: { success, error in
//            if success {
//                print("YOUPIIII")
//                let indexesToRemove = self.selectedIndexes.map { $0.item }.sorted(by: >)
//                for asset in assetsToDelete {
//                    if let index = self.self.fetchResult.firstIndex(of: asset) {
//                        self.fetchResult.remove(at: index)
//                        }
//                }
//                               
//                      self.selectedIndexes.removeAll() // Clear selected indexes
//                               
//                               // Reload collection view on the main queue
//                DispatchQueue.global().async {
//                    // Do some background work...
////                    self.fetchResult = PHAsset.fetchAssets(with: fetchOptions)
//
//                    // Update UI on the main thread
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                    }
//                }
//            }
//            
//            
//            else {
//                print("error",error.debugDescription)
//            }
//            
//        })
        
    }
    
    
    
//    func deleteImageFromGallery(image: UIImage) {
//        // Check for the PHAuthorizationStatus to access the photo library
//        let status = PHPhotoLibrary.authorizationStatus()
//        if status == .authorized {
//            // Access the photo library
//            PHPhotoLibrary.shared().performChanges({
//                // Fetch the asset associated with the provided image
//                if let asset = self.fetchAssetForImage(image: image) {
//                    // Delete the asset
//                    PHAssetChangeRequest.deleteAssets([asset] as NSArray)
//                }
//            }) { [weak self] success, error in
//                if success {
//                    print("Image deleted successfully")
//                                        DispatchQueue.main.async {
//                                            self?.collectionView.reloadData()
//                                        }
//                } else {
//                    print("Error deleting image: \(error?.localizedDescription ?? "")")
//                }
//            }
//        } else {
//            // Handle case where the user has not granted access to the photo library
//            print("Access to photo library denied")
//        }
//    }
    
    func deleteImageFromGallery(image: UIImage) {
           guard let asset = fetchAssetForImage(image: image) else {
               // Handle scenario where asset is not found
               return
           }
           
           PHPhotoLibrary.shared().performChanges({
               PHAssetChangeRequest.deleteAssets([asset] as NSArray)
           }) { [weak self] success, error in
               if success {
                   // Deletion successful, update your data source and reload collection view
                   if let index = self?.selectedImage.firstIndex(of: image) {
                       self?.selectedImage.remove(at: index)
                       DispatchQueue.main.async {
                        self?.fetchAssets(categories: self!.photoType)

                       }
                   }
                   print("Image deleted successfully")
               } else {
                   // Handle deletion failure
                   print("Error deleting image: \(error?.localizedDescription ?? "")")
               }
           }
       }

    func fetchAssetForImage(image: UIImage) -> PHAsset? {
        var asset: PHAsset?
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let result = PHAsset.fetchAssets(with: options)
        
        // Loop through assets to find the one matching the provided image
        result.enumerateObjects { (object, _, _) in
            if let phAsset = object as? PHAsset {
                if phAsset.mediaType == .image {
                    let requestOptions = PHImageRequestOptions()
                    requestOptions.isSynchronous = false
                    PHImageManager.default().requestImage(for: phAsset, targetSize: CGSize(width: image.size.width, height: image.size.height), contentMode: .aspectFit, options: requestOptions) { (result, _) in
                        if let result = result, result.pngData() == image.pngData() {
                            asset = phAsset
                        }
                    }
                }
            }
        }
        return asset
    }
                                               
        // Handle the deletion logic (remove from data source, delete from the photo library, etc.)
    
    @IBAction func deletePhotoAction(_ sender: UIBarButtonItem) {
        
        
        
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {
                return
            }

        
        let alertController = UIAlertController(title: "Deletion Apply", message: "are you sure you want to delete", preferredStyle: .alert)

        // Add actions to the alert controller
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Handle OK button tap (if needed)
            self.deleteSelectedPhotos()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            // Handle Cancel button tap (if needed)
            
            for index in selectedIndexPaths {
                self.collectionView.cellForItem(at: index)?.isSelected = false
            }
        }

        // Add the actions to the alert controller
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        // Present the alert controller
        present(alertController, animated: true, completion: nil)
        
        
//            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), handler: { [weak self] _ in
//                self?.deleteSelectedPhotosConfirmed()
//            })
//
//            let menu = UIMenu(title: "", children: [deleteAction])
//
//            let deleteMenu = UIMenuController.shared
//            deleteMenu.menuItems = [UIMenuItem(title: "Delete", action: #selector(deleteSelectedPhotos))]
//            deleteMenu.showMenu(from: view, rect: CGRect.zero)
        
        
        
        
        
        
    }
    
    @objc func deleteSelectedPhotosConfirmed() {
        // Perform the actual deletion here
    }
    @IBOutlet weak var deletePhoto: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photoCell")
        if let retrievedValue = UserDefaults.standard.value(forKey: "myKey") as? String {
            photoType = retrievedValue
            print("PHoto TYPE: %@",photoType)
        } else {
            print("Value not found in UserDefaults.")
        }
        
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        collectionView.dataSource = self

        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                // Access granted, fetch the assets
                self.fetchAssets(categories: self.photoType)
            } else {
                // Handle access denied
                print("Access to photo library denied.")
            }
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func uploadButtonAction(_ sender: UIBarButtonItem) {
        for img in selectedImage {
            self.uploadImageToFirestore(image: img)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    
    private func fetchAssets(categories:String) {
        let fetchOptions = PHFetchOptions()
        let albumsPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumScreenshots, options: nil)

        switch categories {
            
            
        case "PH":
            fetchOptions.includeAssetSourceTypes = [.typeUserLibrary]
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            break
            
        case "SC":
            albumsPhoto.enumerateObjects({(collection, index, object) in
                if collection.localizedTitle == "Screenshots" && collection.assetCollectionSubtype == .smartAlbumScreenshots{
                        self.fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
                       // print(photoInAlbum.count) //Screenshots albums count
                    }
                })
//            fetchOptions.predicate = NSPredicate(format: "mediaType = %d AND subtype IN %@", PHAssetMediaType.image.rawValue, [PHAssetMediaSubtype.photoScreenshot.rawValue])
//                  fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            break
            
            
        case "CA":
            fetchOptions.includeAssetSourceTypes = [.typeUserLibrary]

            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                   fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

            break
            
            
        default:
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d AND subtype IN %@", PHAssetMediaType.image.rawValue, [PHAssetMediaType.image.rawValue])
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            break
        }
        
        DispatchQueue.global().async {
            // Do some background work...
            self.fetchResult = PHAsset.fetchAssets(with: fetchOptions)

            // Update UI on the main thread
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return fetchResult?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
 
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        if let asset = fetchResult?[indexPath.item] {
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .opportunistic
            
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: requestOptions) { (image, _) in
                self.image.append(image ?? UIImage())
                cell.imageView.image = image
                
    }
            
            
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexes.append(indexPath)
        self.selectedImage.append(self.image[indexPath.item])
        

    }
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
     
            if let index = selectedIndexes.firstIndex(of: indexPath) {
                selectedIndexes.remove(at: index)
               // selectedImage.remove(at: indexPath.)
            }
        }
    
    
    
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
