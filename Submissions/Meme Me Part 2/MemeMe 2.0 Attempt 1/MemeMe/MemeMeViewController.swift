//
//  MemeMeViewController.swift
//  MemeMe 2.0 
//
//  Created by Douglas Cooper on 11/1/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController,UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    //MARK:- Buttons
    var cameraButton = UIBarButtonItem()
    var flexiblespace = UIBarButtonItem()
    var pickImageButton = UIBarButtonItem()
    var shareButton = UIBarButtonItem()
    var cancelButton = UIBarButtonItem()
    
    //MARK:- Meme data
    var memedImage = UIImage()
    var meme:Meme!

    //MARK:- Keyboard related variables
    var keyboardHidden = true //View starts with the keyboard hidden

    var navandtoolhidden:Bool = false {// variable to keep when the toolbar and navbar are hidden
        didSet{
            hide(navandtoolhidden,animated: true)
        }
    }
    //MARK:-
    //MARK:- View related
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = self.view.frame.size.width;
        _ = self.view.frame.size.height;
        
        self.navigationController?.view.backgroundColor = UIColor.white //When zooming the background should be white.
        bottomTextField.sizeToFit()

        pickImageButton = UIBarButtonItem(title: "Album", style: .done, target: self, action: #selector(MemeMeViewController.pickAnImageFromAlbum(_:)))
        cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(MemeMeViewController.pickAnImageFromCamera(_:)))
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(MemeMeViewController.share))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(MemeMeViewController.cancel))
        flexiblespace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
      
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Impact", size: 40)!, //Uses Custom Impact font.
            NSStrokeWidthAttributeName : -3
        ] as [String : Any]
        
        topTextField.backgroundColor = UIColor.clear
        bottomTextField.backgroundColor = UIColor.clear
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            cameraButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reset previous scaling and position of image.
        self.imagePickerView.transform = CGAffineTransform.identity
        
        //get the current meme for editing purposes
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        self.meme = applicationDelegate.editorMeme
        
        //redraw current meme image
        self.navigationItem.leftBarButtonItem = shareButton
        topTextField.text = meme.topText
        bottomTextField.text = meme.bottomText
        imagePickerView.image = meme.image
        
        //if an image was selected then enable the share button
        if(imagePickerView.image?.size == UIImage().size){
            shareButton.isEnabled = false
        }else{
            shareButton.isEnabled = true
        }

        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = cancelButton
        self.toolbarItems = [flexiblespace,cameraButton,flexiblespace,pickImageButton,flexiblespace]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    //MARK:-

    //Camera button Action
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //Album button.
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //setup editor image and current editor meme.
            self.imagePickerView.image = image
            meme.image = image
            meme.topText = self.topTextField.text
            meme.bottomText = self.bottomTextField.text
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    //Dismiss the Image Picker on Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //After the enter is pressed at we dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.isEqual(bottomTextField){
            self.unsubscribeFromKeyboardNotifications()
        }
        return true
    }
    
    //At the begining of Editing if the default text is written We reset it
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
        if textField.isEqual(bottomTextField){
            self.subscribeToKeyboardNotifications()
        }
    }

    // Shifting view when keyboard covers text field
    
    // Subscribe to keyboard notifications. It will add an observer to the keyboardWillShow function
    // when the keyboardwill show is invoked the height will affect the View Controller
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMeViewController.keyboardWillShow(_:))    , name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeMeViewController.keyboardWillHide(_:))    , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Unsubscribe from keybaord notitfications It will add an observer to the keyboardWillHide function
    // when the keyboardwill show is invoked the height will affect the View Controller

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // gets the keyboard height by looking at the observable
    // returns the keyboard's height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Get and use keyboard height. This sets the keyboard height to negative because
    // when the screen rotates the lifecycle will subscribe again.
    // using -= will shift it up a second time, so you have to multiply by negative 1 to
    // keep the height consistent distance from the origin
    func keyboardWillShow(_ notification: Notification) {
        if(keyboardHidden ){ //If the keyboard was not hidden.(e.g. we change the type of the keyboard on currently displayed keyboard view) there's no need to change the origin.
            self.view.frame.origin.y = -getKeyboardHeight(notification)
            keyboardHidden = false
        }
    }
    
       // sets teh height to 0 or the origin
    func keyboardWillHide(_ notification: Notification) {
        if(!keyboardHidden){//If the keyboard was hidden.(e.g. we change the type of the keyboard on currently displayed keyboard view) there's no need to change the origin.
            self.view.frame.origin.y = 0
            keyboardHidden = true
        }
    }
    
    //Generates the memed image by grabbing a "screenshot" of the screen
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        hide(true,animated: false)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        hide(false,animated: false)
    
        return memedImage
    }
    
    //Function to save the Meme.It is used only by the share method. It saves the Meme to appdelegate
    func save() {
        //Create the meme
        memedImage = generateMemedImage()
        let meme = Meme(topText:topTextField.text!, bottomText: bottomTextField.text!,  image: imagePickerView.image!,  memedImage: memedImage)
        self.meme = meme
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    //Action for the share button. It displayes the activity view and saves the Meme.
    func share(){
        save()
        _ = [UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.message,UIActivityType.saveToCameraRoll]
        let activity = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activity.completionWithItemsHandler = { (activity, success, items, error) in
                let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeTabBarController") as! UITabBarController
            
            self.navigationController!.present(detailController, animated: true, completion: nil)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.setToolbarHidden(true, animated: false) //Set the toolbar hidden so as to enable the table view's toolbar.
            
            //Reset Editor View.
            let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
            applicationDelegate.editorMeme = Meme(topText: "TOP", bottomText: "BOTTOM", image: UIImage(), memedImage: UIImage())
        }

        self.present(activity, animated: true, completion:nil)
        
    }
    
    //MARK: -
    //hide toolbar and navigation bar
    func hide(_ flag:Bool,animated:Bool){
        self.navigationController?.setNavigationBarHidden(flag, animated: animated)
        self.navigationController?.setToolbarHidden(flag, animated: animated)
    }
    
    //Cancel button action. It goes to the Tabbar(table and collection) view
    func cancel(){
        self.navigationController?.dismiss(animated: true, completion: nil)//Dismiss the First-root controller.
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeTabBarController") as! UITabBarController
        self.navigationController?.present(detailController, animated: true,completion:nil)
    }
    
}
