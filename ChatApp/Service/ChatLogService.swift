//
//  ChatLogService.swift
//  ChatApp
//
//  Created by Antonio Ivcec on 24/9/18.
//  Copyright © 2018 Antonio Ivcec. All rights reserved.
//

import AVFoundation

class ChatLogService: BaseService {
    
    func observeMessagesFor(id: String?, onMessageReceived: @escaping MessageCompletionBlock) {
        guard let uid = authRef.currentUser?.uid, let partnerId = id else { return }
        
        let userMessagesRef = databaseRef.child(Node.userMessages).child(uid).child(partnerId)
        userMessagesRef.observe(.childAdded) { snapshot in
            let messageRef = self.databaseRef.child(Node.messages).child(snapshot.key)
            messageRef.observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                
                onMessageReceived(message)
            }
        }
    }
    
    func sendMessageWithText(_ text: String, toId: String?, completion: @escaping EmptyCompletionBlock) {
        let values: [String : Any] = ["text": text]
        
        sendMessageWithProperties(values, toId: toId, completion: completion)
    }
    
    func sendMessageWithImage(_ image: UIImage, toId: String, completion: @escaping (() -> ())) {
        
        uploadToFirebaseStorageUsingImage(image) { imageUrl in
            self.sendMessageWithImageUrl(imageUrl: imageUrl, size: image.size, toId: toId, completion: completion)
        }
    }
    
    private func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping StringCompletionBlock) {
        
        let imageName = NSUUID().uuidString
        let ref = storageRef.child(Node.messageImages).child("\(imageName).png")
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil) { metadata, error in
                if let error = error {
                    print(error)
                    return
                }
                
                ref.downloadURL { url, error in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    if let url = url?.absoluteString {
                        completion(url)
                    }
                }
            }
        }
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, size: CGSize, toId: String, completion: @escaping EmptyCompletionBlock) {
        let values: [String : Any] = [
            "imageUrl": imageUrl,
            "imageWidth": size.width,
            "imageHeight": size.height
        ]
        
        sendMessageWithProperties(values, toId: toId, completion: completion)
    }
    
    func sendMessageWith(videoUrl: URL, toId: String, onUploadProgress: @escaping ((String) -> ()), onUploadSuccess: @escaping EmptyCompletionBlock) {
        let filename = NSUUID().uuidString + ".mov"
        let ref = storageRef.child(Node.messageMovies).child(filename)
        let uploadTask = ref.putFile(from: videoUrl, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print(error)
                    return
                }
                
                
                if let remoteVideoURL = url, let thumbnailImage = self.thumbnailImageForFileUrl(videoUrl) {
                    
                    self.uploadToFirebaseStorageUsingImage(thumbnailImage) { imageURL in
                        let values: [String : Any] =
                            ["videoUrl": remoteVideoURL.absoluteString,
                             "imageUrl": imageURL,
                             "imageWidth": thumbnailImage.size.width,
                             "imageHeight": thumbnailImage.size.height]
                        self.sendMessageWithProperties(values, toId: toId)
                    }
                }
            }
        }
        
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else {
                print("error")
                return
            }
            
            let progressString = String(format: "%0.f %%", (Float64(progress.completedUnitCount) / Float64(progress.totalUnitCount) * 100).rounded())
            onUploadProgress(progressString)
        }
        
        uploadTask.observe(.success) { snapshot in
            onUploadSuccess()
        }
    }
    
    private func thumbnailImageForFileUrl(_ videoUrl: URL) -> UIImage? {
        let asset = AVAsset(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTime(seconds: 1, preferredTimescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func sendMessageWithProperties(_ properties: Parameters, toId: String?, completion: EmptyCompletionBlock? = nil) {
        guard let toId = toId, let fromId = authRef.currentUser?.uid else { return }
        
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values: Parameters = [
            "toId": toId,
             "fromId": fromId,
             "timestamp": timestamp
        ]
        
        properties.forEach { property in values[property.key] = property.value }
        
        let ref = databaseRef.child(Node.messages).childByAutoId()
        ref.updateChildValues(values) { error, ref in
            if let error = error {
                self.delegate?.service(self, didFailWithErrorTitle: error.localizedDescription)
                return
            }
            
            let userMessagesRef = self.databaseRef.child(Node.userMessages).child(fromId).child(toId)
            userMessagesRef.updateChildValues([ref.key: 1])
            
            let recipientMessagesRef = self.databaseRef.child(Node.userMessages).child(toId).child(fromId)
            recipientMessagesRef.updateChildValues([ref.key: 1])
            
            completion?()
        }
    }
}
