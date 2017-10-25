//
//  ViewController.swift
//  MemeMeApp
//
//  Created by Douglas Cooper on 9/20/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    // Outlets
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var imageSelectionView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    
    //Share Button is an outline to make working with constraints easier
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var memedImage: UIImage!
    var memes: [Meme]!
    
    let editTextFieldDelegate = textFieldDelegate()
    
    // Lifecycle Declarations
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields(topTextField)
        configureTextFields(bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Disable Camera Button if not Available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        if imageSelectionView.image == nil {
            shareButton.isEnabled = false
        } else {
            shareButton.isEnabled = true
        }
        // Subscribe to keybaord notifications
        self.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Unsubscribe from keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
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
 
    
    // action to generate a memed image that is returned and pass it into the activity item
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        // memed image to activity view
        self.memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [self.memedImage!], applicationActivities: nil)
        // Save image to shared
        activityVC.completionWithItemsHandler = {activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // Start of Applicaiton Functions
    // Show image in image view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageSelectionView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Canceled image selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Shifting view when keyboard covers text field
    
    // Subscribe to keyboard notifications. It will add an observer to the keyboardWillShow function
    // when the keyboardwill show is invoked the height will affect the View Controller
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMeViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMeViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    // Unsubscribe from keybaord notitfications It will add an observer to the keyboardWillHide function
    // when the keyboardwill show is invoked the height will affect the View Controller
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    // Get and use keyboard height. This sets the keyboard height to negative because
    // when the screen rotates the lifecycle will subscribe again.
    // using -= will shift it up a second time, so you have to multiply by negative 1 to 
    // keep the height consistent distance from the origin
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    // sets teh height to 0 or the origin
    func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    // gets the keyboard height by looking at the observable
    // returns the keyboard's height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // sets a structure to be called later, if
    struct Meme {
        
        var topTextField: String?
        var bottomTextField: String?
        var originalImage: UIImage?
        let memedImage: UIImage!
    }
    
    func save() {
        let _ = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, originalImage: imageSelectionView.image!, memedImage: memedImage)
    }
    
    // Hides the toolbar, no nav bar is necessary and looks cleaner to have everything on one bar
    func generateMemedImage() -> UIImage {
        
        toolbar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolbar.isHidden = false
        
        return memedImage
    }
    
    
    func configureTextFields(_ textField: UITextField) {
        
        // Controlls the text Attributes when the view loads
        // Talks about color, font, and size
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSStrokeColorAttributeName : UIColor.black,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ] as [String : Any]
        
        // Delegates responsibility to hitting return key
        // and begining editing
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = editTextFieldDelegate
        bottomTextField.text = "BOTTOM"
        topTextField.text = "TOP"
    }

    

    
}

