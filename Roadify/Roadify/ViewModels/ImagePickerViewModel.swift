/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2023B
 Assessment: Assignment 3
 Author: Team Dragon
 Created date: 
 Last modified: 22/9/24
 Acknowledgement: Stack overflow, Swift.org, RMIT canvas
 */

import SwiftUI
import Photos

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var images: [UIImage] = []

    init() {
        requestPhotoLibraryAccess()
    }
    
    // Request access to the photo library
    func requestPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            loadPhotos()
        case .notDetermined:
            // Request authorization and then load photos if granted
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    DispatchQueue.main.async {
                        self.loadPhotos()
                    }
                }
            }
        default:
            break
        }
    }
    
    // Load photos from the photo library
    func loadPhotos() {
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var tempImages: [UIImage] = []

            fetchResult.enumerateObjects { asset, _, _ in
                let imageManager = PHImageManager.default()
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                requestOptions.deliveryMode = .highQualityFormat
                
                imageManager.requestImage(for: asset,
                                          targetSize: PHImageManagerMaximumSize,
                                          contentMode: .aspectFill,
                                          options: requestOptions) { image, _ in
                    if let image = image {
                        // Check for duplicates
                        if !tempImages.contains(image) {
                            tempImages.append(image)
                        }
                    }
                }
            }
            
            // Ensure that UI updates happen on the main thread
            DispatchQueue.main.async {
                self.images = tempImages 
            }
        }
    }
}
