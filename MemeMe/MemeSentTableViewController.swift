//
//  MemeSentTableViewController.swift
//  MemeMe
//
//  Created by Octavius Delfyette on 9/19/17.
//  Copyright © 2017 Delfyette Designs. All rights reserved.
//

import UIKit

class MemeSentTableViewController: UIViewController {
    
    var memes: [Meme]!
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    @IBOutlet weak var MemeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
        MemeTableView.reloadData()
    }
}

extension MemeSentTableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        detailController.setMeme = memes[indexPath.row]
        self.present(detailController, animated: true, completion: nil)
    }
}

extension MemeSentTableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell")!
        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = "\(meme.topText!)...\(meme.bottomText!)"
        cell.imageView?.image = meme.memedImage
        
        return cell
    }

}
