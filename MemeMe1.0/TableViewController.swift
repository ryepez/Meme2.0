//
//  TableViewController.swift
//  MemeMe1.0
//
//  Created by Ramon Yepez on 3/17/21.
//

import UIKit

class TableViewController: UITableViewController {

    //properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
       override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes the size of the rows bigger to fit 5 on the view
        self.tableView.rowHeight = (view.frame.height/5)
   
        // Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // Button that segues to the meme maker controllers
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(memeMaker))
    }
    
    override func viewWillAppear(_ animated: Bool) {
       //updates data
        tableView.reloadData()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
        tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as!
            TableViewCell

        let data = self.appDelegate.memes[(indexPath as NSIndexPath).row]
        cell.imageViewD.image = data.memedImage
        cell.topLabel.text = data.topText! + "..." + data.bottomText!
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //data source
        let data = self.appDelegate.memes[(indexPath as NSIndexPath).row]

        let DetailVC: DetailsViewController
        DetailVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        //sending the select image to DetailVC
        DetailVC.imageToDisplay = data.memedImage
        
        //pushing the controller to top
        self.navigationController!.pushViewController(DetailVC, animated: true)
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            appDelegate.memes.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
        return
    }
        
    }

    @objc func memeMaker(_ sender: UIButton) {
    
        let controller: ViewController
        controller = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
    self.present(controller, animated: true, completion: nil)
        
    }
    
}
