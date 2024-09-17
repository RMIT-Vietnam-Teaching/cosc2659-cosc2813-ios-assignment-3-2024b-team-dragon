//
//  ImagePickerViewModel.swift
//  Roadify
//
//  Created by Lê Phước on 17/9/24.
//

import SwiftUI
import Photos

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?  // Selected image
    @Published var images: [UIImage] = []  // List of fetched images

    init() {
        requestPhotoLibraryAccess()  // Ask for permission at initialization
    }
    
    // Request access to the photo library
    func requestPhotoLibraryAccess() {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized:
            loadPhotos()  // Load photos if already authorized
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
            // Handle denied or restricted status if necessary
            break
        }
    }
    
    // Load photos from the photo library
    func loadPhotos() {
        DispatchQueue.global(qos: .userInitiated).async {
            let fetchOptions = PHFetchOptions()
            let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            
            var tempImages: [UIImage] = []  // Temporary array to avoid duplicate entries

            fetchResult.enumerateObjects { asset, _, _ in
                let imageManager = PHImageManager.default()
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = true
                requestOptions.deliveryMode = .highQualityFormat  // Ensure high-quality images
                
                imageManager.requestImage(for: asset,
                                          targetSize: PHImageManagerMaximumSize,  // Request maximum size for higher quality
                                          contentMode: .aspectFill,
                                          options: requestOptions) { image, _ in
                    if let image = image {
                        // Check for duplicates
                        if !tempImages.contains(image) {
                            tempImages.append(image)  // Append to temporary array
                        }
                    }
                }
            }
            
            // Ensure that UI updates happen on the main thread
            DispatchQueue.main.async {
                self.images = tempImages  // Assign the filtered array to the published variable
            }
        }
    }
}
