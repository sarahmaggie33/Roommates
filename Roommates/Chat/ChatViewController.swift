//
//  ChatViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 10/29/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import Photos
import UIKit

import Firebase
import GoogleSignIn
import Crashlytics

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, InviteDelegate {
    
    // Instance variables
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle?
    
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    
    @IBOutlet weak var clientTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the color for the navigation bar
        self.navigationController!.navigationBar.barTintColor = UIColor.blue
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 238/255, green: 173/255, blue: 30/255, alpha: 1)]
        self.navigationController!.navigationBar.tintColor = UIColor(red: 238/255, green: 173/255, blue: 30/255, alpha: 1)
        self.navigationController!.navigationBar.barStyle = .black
        
        self.clientTable.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        
        configureDatabase()
        configureStorage()
        configureRemoteConfig()
        fetchConfig()
    }
    
    deinit {
        if let refHandle = _refHandle  {
            self.ref.child("messages").removeObserver(withHandle: refHandle)
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.messages.append(snapshot)
            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }
    
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }
    
    func configureRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        // Create Remote Config Setting to enable developer mode.
        // Fetching configs from the server is normally limited to 5 requests per hour.
        // Enabling developer mode allows many more requests to be made per hour, so developers
        // can test different config values during development.
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings
    }
    
    func fetchConfig() {
        var expirationDuration: Double = 3600
        // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
        // the server.
        if self.remoteConfig.configSettings.isDeveloperModeEnabled {
            expirationDuration = 0
        }
        
        // cacheExpirationSeconds is set to cacheExpiration here, indicating that any previously
        // fetched and cached config would be considered expired because it would have been fetched
        // more than cacheExpiration seconds ago. Thus the next fetch would go to the server unless
        // throttling is in progress. The default expiration duration is 43200 (12 hours).
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { [weak self] (status, error) in
            if status == .success {
                print("Config fetched!")
                guard let strongSelf = self else { return }
                strongSelf.remoteConfig.activateFetched()
                let friendlyMsgLength = strongSelf.remoteConfig["friendly_msg_length"]
                if friendlyMsgLength.source != .static {
                    strongSelf.msglength = friendlyMsgLength.numberValue!
                    print("Friendly msg length config: \(strongSelf.msglength)")
                }
            } else {
                print("Config not fetched")
                if let error = error {
                    print("Error \(error)")
                }
            }
        }
    }
    
    @IBAction func didPressFreshConfig(_ sender: AnyObject) {
        fetchConfig()
    }
    
    @IBAction func didSendMessage(_ sender: UIButton) {
        _ = textFieldShouldReturn(textField)
    }
    
    @IBAction func didPressCrash(_ sender: AnyObject) {
        print("Crash button pressed!")
        Crashlytics.sharedInstance().crash()
    }
    
//    @IBAction func inviteTapped(_ sender: AnyObject) {
//        if let invite = Invites.inviteDialog() {
//            invite.setInviteDelegate(self)
//
//            // NOTE: You must have the App Store ID set in your developer console project
//            // in order for invitations to successfully be sent.
//
//            // A message hint for the dialog. Note this manifests differently depending on the
//            // received invitation type. For example, in an email invite this appears as the subject.
//            invite.setMessage("Try this out!\n -\(Auth.auth().currentUser?.displayName ?? "")")
//            // Title for the dialog, this is what the user sees before sending the invites.
//            invite.setTitle("FriendlyChat")
//            invite.setDeepLink("app_url")
//            invite.setCallToActionText("Install!")
//            invite.setCustomImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
//            invite.open()
//        }
//    }
    
//    func inviteFinished(withInvitations invitationIds: [String], error: Error?) {
//        if let error = error {
//            print("Failed: \(error.localizedDescription)")
//        } else {
//            print("Invitations sent")
//        }
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.count + string.count - range.length
        return newLength <= self.msglength.intValue // Bool
    }
    
    // UITableViewDataSource protocol methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = self.clientTable .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:String] else { return cell }
        let name = message[Constants.MessageFields.name] ?? ""
        if let imageURL = message[Constants.MessageFields.imageURL] {
            if imageURL.hasPrefix("gs://") {
                Storage.storage().reference(forURL: imageURL).getData(maxSize: INT64_MAX) {(data, error) in
                    if let error = error {
                        print("Error downloading: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageView?.image = UIImage.init(data: data!)
                        cell.setNeedsLayout()
                    }
                }
            } else if let URL = URL(string: imageURL), let data = try? Data(contentsOf: URL) {
                cell.imageView?.image = UIImage.init(data: data)
            }
            cell.textLabel?.text = "sent by: \(name)"
        } else {
            let text = message[Constants.MessageFields.text] ?? ""
            cell.textLabel?.text = name + ": " + text
            cell.imageView?.image = UIImage(named: "ic_account_circle")
            if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL),
                let data = try? Data(contentsOf: URL) {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    // UITextViewDelegate protocol methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        textField.text = ""
        view.endEditing(true)
        let data = [Constants.MessageFields.text: text]
        sendMessage(withData: data)
        return true
    }
    
    func sendMessage(withData data: [String: String]) {
        var mdata = data
        mdata[Constants.MessageFields.name] = Auth.auth().currentUser?.displayName
        if let photoURL = Auth.auth().currentUser?.photoURL {
            mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }
        
        // Push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }
    
    // MARK: - Image Picker
    
//    @IBAction func didTapAddPhoto(_ sender: AnyObject) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
//            picker.sourceType = .camera
//        } else {
//            picker.sourceType = .photoLibrary
//        }
//        
//        present(picker, animated: true, completion:nil)
//    }
//    
    
//    func imagePickerController(_ picker: UIImagePickerController,
//                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion:nil)
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//
//        // if it's a photo from the library, not an image from the camera
//        if #available(iOS 12.0, *), let referenceURL = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
//            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
//            let asset = assets.firstObject
//            asset?.requestContentEditingInput(with: nil, completionHandler: { [weak self] (contentEditingInput, info
//                ) in
//                let imageFile = contentEditingInput?.fullSizeImageURL
//                let filePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000))/\((referenceURL as AnyObject).lastPathComponent!)"
//                guard let strongSelf = self else { return }
//                strongSelf.storageRef.child(filePath)
//                    .putFile(from: imageFile!, metadata: nil) { (metadata, error) in
//                        if let error = error {
//                            let nsError = error as NSError
//                            print("Error uploading: \(nsError.localizedDescription)")
//                            return
//                        }
//                        strongSelf.sendMessage(withData: [Constants.MessageFields.imageURL: strongSelf.storageRef.child((metadata?.path)!).description])
//                }
//            })
//        } else {
////            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//            guard let image = info[.originalImage] as? UIImage else {
//                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//            }
//            let imageData = UIImage.jpegData(image)
//            let imagePath = "\(uid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/jpeg"
//            self.storageRef.child(imagePath)
//                .putData(imageData, metadata: metadata) { [weak self] (metadata, error) in
//                    if let error = error {
//                        print("Error uploading: \(error)")
//                        return
//                    }
//                    guard let strongSelf = self else { return }
//                    strongSelf.sendMessage(withData: [Constants.MessageFields.imageURL: strongSelf.storageRef.child((metadata?.path)!).description])
//            }
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion:nil)
//    }
    
//    @IBAction func signOut(_ sender: UIButton) {
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//            dismiss(animated: true, completion: nil)
//        } catch let signOutError as NSError {
//            print ("Error signing out: \(signOutError.localizedDescription)")
//        }
//    }
    
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
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
