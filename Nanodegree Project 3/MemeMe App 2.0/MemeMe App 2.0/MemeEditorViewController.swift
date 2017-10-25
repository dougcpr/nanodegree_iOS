//
//  MemeEditorViewController.swift
//  MemeMe App 2.0
//
//  Created by Douglas Cooper on 10/16/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var camera: UIBarButtonItem!
    
    //Share Button is an outline to make working with constraints easier
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    //Define default textfield parameters
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3,
        NSBackgroundColorAttributeName: UIColor.clear
        ] as [String : Any]
    
    // Lifecycle Declarations
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        setupInitialView()
    }
    
    func setupInitialView() {
        
        //reset Image Picker View
        imagePickerView.image = nil
        
        setupTextFieldWithDefaultSettings(topText, withText: "TOP")
        setupTextFieldWithDefaultSettings(bottomText, withText: "BOTTOM")
        
        
        //Disable the share button initially
        shareButton.isEnabled = false
    }
    
    func setupTextFieldWithDefaultSettings(_ textField: UITextField, withText text: String) {
        
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
        textField.borderStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        //shows camera source when available
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Unsubscribe from keybaord notitfications It will add an observer to the keyboardWillHide function
    // when the keyboardwill show is invoked the height will affect the View Controller
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    /*
     I tried doing this and was unable to get to work completely
     // Start of IB Actions
     // Select an image from the album y setting a temporary variable
     // to a picker controller and selects the source type as the photo library
     @IBAction func pickImageFromSource(_ source: UIImagePickerControllerSourceType) {
     
     let pickerController = UIImagePickerController()
     pickerController.delegate = self
     
     // created a switch into the UISourceType by looking into the library
     switch source {
     case .camera:
     // Select an Image from the Camera and sets up an image picker with a temporary variable
     // sets the source type to a camera and presents a view controller according to the src type
     pickerController.sourceType = .camera
     present(pickerController, animated: true, completion: nil)
     // Becauase the Album is a Custom class I set it to a default use. The source type is not being
     // affected in the IBAction. When I click Album Button, it only sends the UIImagePickerControllerSourceType
     default:
     pickerController.sourceType = .photoLibrary
     present(pickerController, animated: true, completion: nil)
     break
     }
     }
     
     */
    
    @IBAction func pickAnImageFromAlbums(_ sender: UIBarButtonItem) {
        
        saveImageFromSource(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        
        saveImageFromSource(UIImagePickerControllerSourceType.camera)
    }
    
    func saveImageFromSource(_ source: UIImagePickerControllerSourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
        setupInitialView()
        dismiss(animated: true, completion: nil)
    }
    
    func saveMeme(_ memedImage: UIImage) {
        
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    // Subscribe to keyboard notifications. It will add an observer to the keyboardWillShow function
    // when the keyboardwill show is invoked the height will affect the View Controller
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow  , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Get and use keyboard height. This sets the keyboard height to negative because
    // when the screen rotates the lifecycle will subscribe again.
    // using -= will shift it up a second time, so you have to multiply by negative 1 to
    // keep the height consistent distance from the origin
    func keyboardWillShow(_ notification: Notification) {
        
        //if editing is started in bottom textfield, frame moves up to avoid textfield being covered by the keyboard, if not already moved up
        if bottomText.isFirstResponder && view.frame.origin.y == 0 {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    // gets the keyboard height by looking at the observable
    // returns the keyboard's height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    func keyboardWillHide(_ notification: Notification) {
        if bottomText.isFirstResponder && view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    //Combine image and text using an image context to render the view hierarchy as a UIImage
    func generateMemedImage() -> UIImage {
        
        toolBar.isHidden = true
        navigationBar.isHidden = true
        
        //Render view as an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        navigationBar.isHidden  = false
        return memedImage
    }
    
    // action to generate a memed image that is returned and pass it into the activity item
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        //generate memed image and pass it to activity controller
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed {
                self.saveMeme(memedImage)
                self.dismiss(animated: true, completion: nil)
            }
        }
        //present view controller
        present(activityController, animated: true, completion: nil)
    }
}

