//
//  HistoryVC.swift
//  Circle
//
//  Created by Kerby Jean on 2/22/18.
//  Copyright © 2018 Kerby Jean. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseDatabase

class HistoryVC: UITableViewController {

    var user: User?
    
    var titleView: UIView!
    var imageView = UIImageView()
    var label = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        navigationItem.titleView = titleView
        
        titleView.addSubview(imageView)
        titleView.addSubview(label)

        imageView.contentMode = .scaleAspectFill
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
    
        
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.darkText
        
        setup()
        
        let cancel = UIBarButtonItem(image: #imageLiteral(resourceName: "Cancel-20"), style: .done, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = cancel
        
        self.tableView.register(InsightCell.self, forCellReuseIdentifier: "InsightCell")
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageView.center.x = titleView.center.x
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height/2

        label.frame = CGRect(x: 0, y: 25, width: titleView.frame.width, height: 20)

    }
    
    
    func setup() {
        imageView.sd_setImage(with: URL(string: (user?.photoUrl)!))
        label.text = "\(user?.firstName ?? "") history"
    }

    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func getHistory() {
        //DataService.instance.REF_CIRCLES.document(user?.circle).collection("history").
    }
    



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 30
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "InsightCell", for: indexPath) as! InsightCell
//        cell.configure(user!)
        return UITableViewCell()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
