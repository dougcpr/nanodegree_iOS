//
//  MemeMeTableViewController.swift
//  MemeMe 2.0 
//
//  Created by Douglas Cooper on 11/1/16.
//  Copyright © 2016 Douglas Cooper. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController{
    var memes: [Meme]!
    var plusButton = UIBarButtonItem()
    var editButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(MemeTableViewController.anotherMeme))
        editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(MemeTableViewController.edit))

        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = plusButton
        self.navigationItem.leftBarButtonItem = editButton
        updateMemes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateMemes()
        self.isEditing = false
        self.tableView.reloadData() // Reload Data so if a delete was done to get the new data.
    }
    
    //Load the memes from App Delegate
    func updateMemes(){
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Asks the data source whether a given row can be moved to another location in the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true}
    
    //Setup the display of the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")!
        
        
        let meme = self.memes[indexPath.row]
        // Set the name and image
        cell.textLabel?.text = meme.topText! + "-" + meme.bottomText!
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = meme.memedImage

        return cell
    }

    //On select display the Meme in Meme Detail View
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme   = self.memes[indexPath.row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let itemToMove = memes[fromIndexPath.row]
        memes.remove(at: fromIndexPath.row)
        memes.insert(itemToMove, at: toIndexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "anotherMeme"{
            if let _ = segue.destination as? MemeMeViewController{
                //Reset Editor View.
                let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
                applicationDelegate.editorMeme = Meme(topText: "TOP", bottomText: "BOTTOM", image: UIImage(), memedImage: UIImage())
            }
        }
    }
    
    //Button Action. Goes to the Edit View to create another meme.
    func anotherMeme(){
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "anotherMeme", sender: self)

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //For deleting the Meme
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let applicationDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes.remove(at: indexPath.row)

        applicationDelegate.memes = memes
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func edit(){
        self.isEditing = !self.isEditing
    }
    
}
