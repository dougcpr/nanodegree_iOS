//
//  MemeCollectionViewController.swift
//  MemeMe 2.0 
//
//  Created by Douglas Cooper on 11/1/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var memes: [Meme]!
    var plusButton = UIBarButtonItem()
    var editButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MemeCollectionViewController.anotherMeme))
        editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(MemeCollectionViewController.edit))

        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationItem.leftBarButtonItem = editButton
        
        self.isEditing = false
        
        updateMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateMemes()
        self.collectionView?.reloadData()
    }

    //Load the memes from App Delegate
    func updateMemes(){
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Select an cell item. When edit mode is on select deletes the meme. When off, displays Meme Detail View
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        if(self.isEditing){// If the edit mode is on display the delete icon.
            cell.deleteImageView.isHidden = false
        }else{
            cell.deleteImageView.isHidden = true
        }
        
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        
        return cell
    }
    
    //It is used for deletion and viewing the meme. When in the edit mode we delete the saved Meme on Select.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath){
        if(!self.isEditing){//Display Meme
            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
            detailController.meme   = self.memes[indexPath.row]
            self.navigationController!.pushViewController(detailController, animated: true)
        }else{//Delete meme
            let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
            memes.remove(at: indexPath.row)
            
            applicationDelegate.memes = memes
            self.collectionView?.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat{
            return CGFloat(10.0)
    }
    
    //Distance between cells in a row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(-8.0)
    }
    //sets the border of the collection cell
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    }
    
    //Action to create another Meme
    func anotherMeme(){
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "anotherMeme", sender: self)
        
        //Reset Editor View.
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        applicationDelegate.editorMeme = Meme(topText: "TOP", bottomText: "BOTTOM", image: UIImage(), memedImage: UIImage())
    }
    
    //Toggles the edit and reloads the data for the delete icon to be displayed or hid.
    func edit(){
        self.isEditing = !self.isEditing
        self.collectionView?.reloadData()
    }

}

