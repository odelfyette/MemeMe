//
//  MemeSentCollectionViewController.swift
//  MemeMe
//
//  Created by Octavius Delfyette on 9/19/17.
//  Copyright © 2017 Delfyette Designs. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeSentCollectionViewCell"

class MemeSentCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak  var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet var memeCollectionView: UICollectionView!
    
    var memes:[Meme]!
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let widthDimension = (self.view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (self.view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memes = appDelegate.memes
        memeCollectionView.reloadData()
    }
    

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeSentCollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage

        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        detailController.setMeme = memes[indexPath.row]
        self.present(detailController, animated: true, completion: nil)
    }

}
