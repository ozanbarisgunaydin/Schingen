//
//  StorageManager.swift
//  Schingen
//
//  Created by Ozan Barış Günaydın on 12.11.2021.
//

import Foundation
import FirebaseStorage
import RealmSwift

/// Allows to get fetch and upload files to Firebase storage.
final class StorageManager {
    
    /// Shared instance of class (singleton)
    static let shared = StorageManager()
    //    Added for the not instanciate multiple instances.
    private init(){}
    private let storage = Storage.storage().reference()
/*
 /images/ozangunaydin61-gmail-com_profile_picture.png
 */
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void

    /// Uploads picture to Firebase Storage and returns URLString to download.
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard let strongSelf = self else { return }
            
            guard error == nil else {
//                failed
                print("Failed to upload data to Firebase for picture.")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            strongSelf.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failde to get download URL.")
                    completion(.failure(StorageErrors.failedToDownloadToURL))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    /// Uploads image to Firebase Storage and for conversations..
    public func uploadMessagePhoto(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("message_images/\(fileName)").putData(data, metadata: nil, completion: { [weak self] metadata, error in
            guard error == nil else {
//                failed
                print("Failed to upload data to Firebase for chat photo.")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self?.storage.child("message_images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failde to get download URL.")
                    completion(.failure(StorageErrors.failedToDownloadToURL))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    /// Upload video that will be sent in a conversation message
    public func uploadMessageVideo(with fileUrl: URL, fileName: String, completion: @escaping UploadPictureCompletion) {
        
        let metaData = StorageMetadata()
        metaData.contentType = "video/quicktime"
        if let videoData = NSData(contentsOf: fileUrl) as Data? {
            storage.child("message_videos/\(fileName)").putData(videoData, metadata: metaData, completion: { [weak self] metadata, error in
                guard error == nil else {
                    // failed
                    print("Failed to upload video file to firebase for video.")
                    completion(.failure(StorageErrors.failedToUpload))
                    return
                }
                
                self?.storage.child("message_videos/\(fileName)").downloadURL(completion: { url, error in
                    guard let url = url else {
                        print("Failed to get download url.")
                        completion(.failure(StorageErrors.failedToDownloadToURL))
                        return
                    }
                    
                    let urlString = url.absoluteString
                    print("download url returned: \(urlString)")
                    completion(.success(urlString))
                })
            })
        }
        
       
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToDownloadToURL

    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let referance = storage.child(path)
        
        referance.downloadURL(completion: {url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToDownloadToURL))
                return
            }
            completion(.success(url))

        })
    }
}
