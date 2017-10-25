//
//  MemeDetailViewController.swift
//  MemeMe 2.0 
//
//  Created by Douglas Cooper on 11/1/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import UIKit


class MemeDetailViewController: UIViewController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    var meme: Meme!
    var editButton:UIBarButtonItem!
    var deleteButton:UIBarButtonItem!
    var flexiblespace:UIBarButtonItem! // For viewing purposes only
    let tapRec = UITapGestureRecognizer()
    var navandtoolhidden = false // variable to keep when the toolbar and navbar are hidden
    @IBOutlet weak var detailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapRec.addTarget(self, action: #selector(MemeDetailViewController.tapped))
        tapRec.delegate = self
        view.addGestureRecognizer(tapRec)
        
        //The button of the navigation controller
        flexiblespace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(MemeDetailViewController.editMeme))
        deleteButton = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(MemeDetailViewController.deleteMeme))

        self.navigationItem.rightBarButtonItems = [editButton,deleteButton]

        self.detailImage.image = meme.memedImage

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"{
            if let _ = segue.destination as? MemeMeViewController{
                let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
                applicationDelegate.editorMeme = self.meme // the editor meme is updated so when we go back to Editor View we display the selected meme to edit
                }
            }
    }
    
    //Edit Meme: It goes back to the Edit view screen to edit the meme.
    func editMeme(){
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "edit", sender: self)
    }
    //Deletes the meme
    func deleteMeme(){
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        applicationDelegate.memes.removeLast()
        self.navigationController?.dismiss(animated: true, completion: nil)//Dismiss the First-root controller.
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeTabBarController") as! UITabBarController
        self.navigationController?.present(detailController, animated: true,completion:nil)
        
    }
    
    //hide toolbar and navigation bar when tapped
    func tapped(){
        if(navandtoolhidden){
            hide(false,animated: true)
            navandtoolhidden = false
        }else{
            hide(true,animated: true)
            navandtoolhidden = true
        }
    }
    
    //hide toolbar and navigation bar
    func hide(_ flag:Bool,animated:Bool){
        self.navigationController?.setNavigationBarHidden(flag, animated: animated)
        setTabBarVisible(!flag, animated: true)
    }
    
    //I found this code to enable animated hide an show of tabbar toolbar
    //http://stackoverflow.com/questions/27008737/how-do-i-hide-show-tabbar-when-tapped-using-swift-in-ios8
    //--->
    func setTabBarVisible(_ visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible() == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        let offsetY = (visible ? -height! : height)
        
        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        if frame != nil {
            UIView.animate(withDuration: duration, animations: {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                return
            }) 
        }
    }
    
    func tabBarIsVisible() ->Bool {
        return (self.tabBarController?.tabBar.frame.origin.y)! < self.view.frame.maxY
    }
    //<---


}
