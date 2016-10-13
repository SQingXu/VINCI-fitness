//
//  ActivityListViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 9/22/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit

class ActivityListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var ActivityList = [Activity]()
    var dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.tintColor = UIColor.vinciRed()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ActivityListCell",bundle: nil), forCellReuseIdentifier: "ActivityCell")
        ActivityList = ActivityController.sharedInstance.currentShownActivities
        
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityListCell
        let cellDate = ActivityList[(indexPath as NSIndexPath).row].date
        dateFormatter.dateStyle = .medium
        newCell.titleCell.text = dateFormatter.string(from: cellDate as Date)
        newCell.userLabel.text = ActivityList[(indexPath as NSIndexPath).row].name
        return newCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ActivityController.sharedInstance.currentActivity = ActivityList[(indexPath as NSIndexPath).row]
        self.present(ActivityProfileViewController(), animated: true, completion: nil)
    }
    
}
