//
//  CollectionViewController.swift
//  MemeMe1.0
//
//  Created by Ramon Yepez on 3/17/21.
//

import UIKit


class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIContextMenuInteractionDelegate {

    
    //properties
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

    //adding the meme maker button to the toobar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(memeMaker))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //updates data after creating a new memes
        collectionView.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    
        // Configure the cell
        let data = memes[(indexPath as NSIndexPath).row]
        cell.sentMemeImage.image = data.memedImage
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    
    // when cell is selected, we move to a new controller
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Grab the DetailVC from Storyboard'
        
        let data = self.memes[(indexPath as NSIndexPath).row]

        let DetailVC: DetailsViewController
        DetailVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        //sending the select image to DetailVC
        DetailVC.imageToDisplay = data.memedImage
        
        //pushing the controller to top
        self.navigationController!.pushViewController(DetailVC, animated: true)

}
    // method to create a nice grid of 3 pictures per row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let space:CGFloat = 1.0
        let dimension = (collectionView.bounds.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        
        return CGSize(width: dimension, height: dimension)

    }
    // method that makes the layout updates after phone rotates
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
      
        flowLayout.invalidateLayout()
    }

    //method to create a menu when the picture is hold a few secound. Similar to 3d touch but it works with all the devices.
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
                
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
        let share = UIAction(title: "Share", image: UIImage(systemName: "share.and.arrow.up")){
            action in
        }
        return UIMenu(title: "", children: [share])
    }
        
}
  //method to create a preview when the user press the picture for a long time. Similar to 3d touch.
    override func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        //data source
        let dataSource = memes[(indexPath as NSIndexPath).row]
        //creating a indentifier
        if let cellItemIdentifier = dataSource.topText {
            let identifier = NSString(string: cellItemIdentifier)
            // Use the image name for the identifier.
            return UIContextMenuConfiguration(identifier: identifier, previewProvider: {
                if let previewViewController =
                        self.storyboard?.instantiateViewController(identifier: "DetailsViewController") as? DetailsViewController {
                    
                    previewViewController.imageToDisplay =                     dataSource.memedImage

                    return previewViewController
                } else {
                    return nil
                }
            }, actionProvider: { suggestedActions in
                let share = UIAction(title: "Share", image: UIImage(systemName: "share.and.arrow.up")) {
                action in
                    /// showing the activity contoller if the user press share duing the preview mode.
                    let shareController = UIActivityViewController(activityItems: [dataSource.memedImage], applicationActivities: nil)
                //presenting
                self.present(shareController, animated: true, completion: nil)
                //dimissing the activity view controller after the user sent the meme or cancel the operation.
                shareController.completionWithItemsHandler = {
                    (activity, completed, items, error) in
                    if completed {
                    self.dismiss(animated: true, completion: nil)
                    }
                    self.dismiss(animated: true, completion: nil)
                    }
                                        
                }
                return UIMenu(title: "", children: [share])
            })
            
        } else {
            return nil
        }
    }
    
 // method takes the user to new controller when they press on the preview
    override func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let destinationViewController = animator.previewViewController else { return }

        animator.addAnimations {
            self.show(destinationViewController, sender: self)
        }
    }
    
    
    
    //method to take us to the meme maker
    @objc func memeMaker(_ sender: UIButton) {
    
        let controller: ViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
    self.present(controller, animated: true, completion: nil)
        
    }
    
}
