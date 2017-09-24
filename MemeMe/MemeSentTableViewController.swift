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
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}

extension MemeSentTableViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell")!
        let meme = memes[indexPath.row]
        cell.setupCellWith(meme: meme)
        return cell
    }
}

extension  UITableViewCell{
    func setupCellWith(meme: Meme){
        self.textLabel?.text = "\(meme.topText!)...\(meme.bottomText!)"
        self.imageView?.image = meme.memedImage
    }
}
