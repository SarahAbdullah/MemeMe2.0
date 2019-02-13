//
//  SentMemesCollectionViewController.swift
//  MemeMe2.0
//
//  Created by Sarah on 11/29/18.
//  Copyright © 2018 Sarah. All rights reserved.
//

 import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
  
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        editLayout()
        collectionView?.reloadData()
    }
    
    func editLayout(){

        let space: CGFloat = 3
        let dimensionForPortrait = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionForLandscape = (view.frame.size.height - (2 * space)) / 3.0

        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        if UIDevice.current.orientation.isLandscape{
            flowLayout.itemSize = CGSize( width: dimensionForLandscape , height: dimensionForLandscape ) }
        else{
            flowLayout.itemSize = CGSize( width: dimensionForPortrait , height: dimensionForPortrait )
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell" , for: indexPath) as! MemesCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImage?.image = meme.memedImage
        return cell
    }
 
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
      let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    
    @IBAction func addNewMeme(_ sender: Any) {
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
      present(vc, animated: true, completion: nil)

    }

}

