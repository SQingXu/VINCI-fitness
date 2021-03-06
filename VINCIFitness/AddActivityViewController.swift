//
//  AddActivityViewController.swift
//  VINCIFitness
//
//  Created by David Xu on 8/28/16.
//  Copyright © 2016 David Xu. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlacePicker
import GooglePlaces

class AddActivityViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var searchingField = MapAutoCompleteTextField()
    var dateField = DatePickerTextField()
    @IBOutlet weak var toView: UIView!
    var beginTimeField = TimePickerTextField()
    var endTimeField = TimePickerTextField()
    var notesLabel = UILabel()
    var descriptionField = UITextView()
    var titleField = UITextField()
    var resultTable = UITableView()
    var resultArray = [GMSAutocompletePrediction]()
    
    @IBOutlet weak var finishEditingButton: UIButton!
    @IBOutlet weak var cancelEditingButton: UIButton!
    
    var placeClient = GMSPlacesClient()
    var showResultTable: Bool = true
    var isAnimating: Bool = false
    var previousString = ""
    var fullAddressString = ""
    var placeID = ""
    var dateFormatter = DateFormatter()
    var selectedDate = Date()
    var startTime = Date()
    var endTime = Date()
    var tap:UITapGestureRecognizer = UITapGestureRecognizer()
    var cancelButton = UIBarButtonItem()
    var doneButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainScreenSize = UIScreen.main.bounds
        showResultTable = false
        //set navigation item
        activityIndicator.isHidden = true
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelPressed(_:)))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donePressed(_:)))
        cancelButton.tintColor = UIColor.vinciRed()
        doneButton.tintColor = UIColor.vinciRed()
        self.navigationItem.setLeftBarButton(cancelButton, animated: true)
        self.navigationItem.setRightBarButton(doneButton, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        self.tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //set delegate
        searchingField.delegate = self
        resultTable.delegate = self
        resultTable.dataSource = self
        descriptionField.delegate = self
        
        //set element frame
        cancelEditingButton.backgroundColor = UIColor.vinciRed()
        finishEditingButton.backgroundColor = UIColor.vinciRed()
        
        if ActivityController.sharedInstance.editingActivity == false{
        notesLabel.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.48 * mainScreenSize.height, width: 40, height: 10)
        descriptionField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.5 * mainScreenSize.height, width: 0.8 * mainScreenSize.width, height: 120)
        titleField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.1 * mainScreenSize.height, width: 0.8 * mainScreenSize.width, height: 40)
        dateField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.3 * mainScreenSize.height, width: 0.8 * mainScreenSize.width, height: 40)
        searchingField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.2 * mainScreenSize.height, width: 0.8 * mainScreenSize.width, height: 40)
        beginTimeField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.4 * mainScreenSize.height, width: 120, height: 40)
        endTimeField.frame = CGRect(x: 0.57 * mainScreenSize.width, y: 0.4 * mainScreenSize.height, width: 120, height: 40)
        resultTable.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.2 * mainScreenSize.height + 50, width: 0.8 * mainScreenSize.width, height: 0)
        }else{
            notesLabel.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.48 * mainScreenSize.height + 54, width: 40, height: 10)
            descriptionField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.5 * mainScreenSize.height + 54, width: 0.8 * mainScreenSize.width, height: 120)
            titleField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.1 * mainScreenSize.height + 54, width: 0.8 * mainScreenSize.width, height: 40)
            dateField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.3 * mainScreenSize.height + 54, width: 0.8 * mainScreenSize.width, height: 40)
            searchingField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.2 * mainScreenSize.height + 54, width: 0.8 * mainScreenSize.width, height: 40)
            beginTimeField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.4 * mainScreenSize.height + 54, width: 120, height: 40)
            endTimeField.frame = CGRect(x: 0.57 * mainScreenSize.width, y: 0.4 * mainScreenSize.height + 54, width: 120, height: 40)
            resultTable.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.2 * mainScreenSize.height + 104, width: 0.8 * mainScreenSize.width, height: 0)

        }
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.noFilter
        let callback: GMSAutocompletePredictionsCallback = {(results, error)-> Void in
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            self.resultArray = [GMSAutocompletePrediction]()
            for result in results! {
                //                    print("Result \(result.attributedFullText) with placeID \(result.placeID)")
                //                    self.resultArray.append(NSMutableAttributedString(attributedString: result.attributedFullText).string)
                //                    print(NSMutableAttributedString(attributedString: result.attributedPrimaryText).string)
                self.resultArray.append(result)
            }
            self.resultTable.reloadData()
            self.showResultTableView()

        }

        searchingField.searchingClosure = {(textField) in
             if self.searchingField.text != ""{
            self.placeClient.autocompleteQuery(self.searchingField.text!, bounds: nil, filter: filter, callback: callback)
            }
    }
        self.view.addSubview(notesLabel)
        self.view.addSubview(descriptionField)
        self.view.addSubview(titleField)
        self.view.addSubview(endTimeField)
        self.view.addSubview(beginTimeField)
        self.view.addSubview(dateField)
        self.view.addSubview(resultTable)
        self.view.addSubview(searchingField)
        
        //set up result table
        resultTable.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "resultCell")
        resultTable.rowHeight = 45
        resultTable.bounces = false
        resultTable.layer.borderColor = UIColor.vinciGrey().cgColor
        resultTable.layer.borderWidth = 1
        resultTable.backgroundColor = UIColor.clear
        self.edgesForExtendedLayout = UIRectEdge()
        
        //set up Fields
        notesLabel.text = "Notes:"
        notesLabel.font = UIFont.systemFont(ofSize: 12)
        notesLabel.textColor = UIColor.vinciRed()
        descriptionField.layer.borderWidth = 1
        descriptionField.layer.borderColor = UIColor.vinciGrey().cgColor
        descriptionField.tintColor = UIColor.vinciRed()
        //descriptionField.font = UIFont(name: (descriptionField.font?.fontName)!, size: 17)
        descriptionField.font = UIFont.systemFont(ofSize: 17)
        titleField.layer.borderWidth = 1
        titleField.layer.borderColor = UIColor.vinciGrey().cgColor
        titleField.borderStyle = .roundedRect
        titleField.placeholder = "Title"
        titleField.textAlignment = .center
        titleField.tintColor = UIColor.vinciRed()
        searchingField.layer.borderWidth = 1
        searchingField.layer.borderColor = UIColor.vinciGrey().cgColor
        searchingField.borderStyle = .roundedRect
        dateField.layer.borderWidth = 1
        dateField.layer.borderColor = UIColor.vinciGrey().cgColor
        dateField.borderStyle = .roundedRect
        beginTimeField.layer.borderWidth = 1
        beginTimeField.layer.borderColor = UIColor.vinciGrey().cgColor
        beginTimeField.borderStyle = .roundedRect
        endTimeField.layer.borderWidth = 1
        endTimeField.layer.borderColor = UIColor.vinciGrey().cgColor
        endTimeField.borderStyle = .roundedRect
        
        //set up view
        toView.layer.cornerRadius = 20
        toView.backgroundColor = UIColor.vinciRed()
        
        //if editing is true
        if ActivityController.sharedInstance.editingActivity == false{
            cancelEditingButton.isHidden = true
            finishEditingButton.isHidden = true
        }else{
            let activity = ActivityController.sharedInstance.currentActivity
            titleField.text = activity.name
            dateFormatter.timeStyle = .short
            beginTimeField.text = dateFormatter.string(from: activity.startTime as Date)
            beginTimeField.selectedTime = activity.startTime
            endTimeField.text = dateFormatter.string(from: activity.endTime as Date)
            endTimeField.selectedTime = activity.endTime
            dateFormatter.dateStyle = .medium
            dateField.text = dateFormatter.string(from: activity.date as Date)
            dateField.selectedDate = activity.date
            descriptionField.text = activity.description
            searchingField.text = activity.fullAddress
            fullAddressString = activity.fullAddress
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return resultArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! SearchTableViewCell
        newCell.addressLabel.text = NSMutableAttributedString(attributedString: resultArray[(indexPath as NSIndexPath).row].attributedPrimaryText).string
        newCell.locationLabel.text = NSMutableAttributedString(attributedString: resultArray[(indexPath as NSIndexPath).row].attributedSecondaryText!).string
        newCell.preservesSuperviewLayoutMargins = false
        
        newCell.separatorInset = UIEdgeInsets.zero
        newCell.layoutMargins = UIEdgeInsets.zero
        return newCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.placeID = resultArray[(indexPath as NSIndexPath).row].placeID!
        self.previousString = NSMutableAttributedString(attributedString: resultArray[(indexPath as NSIndexPath).row].attributedPrimaryText).string
        self.fullAddressString = NSMutableAttributedString(attributedString: resultArray[(indexPath as NSIndexPath).row].attributedFullText).string
        self.searchingField.endEditing(true)
    }
    func hideResultTableView(){
        var frame = resultTable.frame
        frame.size.height = 0
        self.animateTableToFrame(frame, completion: {})
        showResultTable = false
    }
    func showResultTableView(){
        var frame = resultTable.frame
        frame.size.height = CGFloat(resultArray.count) * resultTable.rowHeight
        self.animateTableToFrame(frame, completion: {})
        showResultTable = true
    }
    func animateTableToFrame(_ frame: CGRect, completion:() -> Void) {
        if (!isAnimating) {
            isAnimating = true
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in self.resultTable.frame = frame }, completion: { (completed: Bool) -> Void in
                self.isAnimating = false } )
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchingField{
            dateField.isHidden = true
            endTimeField.isHidden = true
            beginTimeField.isHidden = true
            toView.isHidden = true
            titleField.isHidden = true
            descriptionField.isHidden = true
            notesLabel.isHidden = true
        }
        animateViewMoving(true, moveValue: 100)
        showResultTableView()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchingField{
            dateField.isHidden = false
            endTimeField.isHidden = false
            beginTimeField.isHidden = false
            toView.isHidden = false
            titleField.isHidden = false
            descriptionField.isHidden = false
            notesLabel.isHidden = false
        }
        animateViewMoving(false, moveValue: 100)
        hideResultTableView()
        self.searchingField.text = previousString
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.hideKeyboardWhenTappedWithR(tap)
        animateViewMoving(true, moveValue: 100)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.disableKeyboardWhenTappedWithR(tap)
        animateViewMoving(false, moveValue: 100)
    }
    func animateViewMoving (_ up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    func cancelPressed(_ sender: UIBarButtonItem){
        _ = self.navigationController?.popViewController(animated: true)
       //self.navigationController?.popToRootViewController(animated: true)
    }
    func donePressed(_ sender:UIBarButtonItem){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        doneButton.isEnabled = false
        cancelButton.isEnabled = false
        selectedDate = dateField.selectedDate as Date
        startTime = beginTimeField.selectedTime as Date
        endTime = endTimeField.selectedTime as Date
        if (dateField.text == "" || beginTimeField.text == "" || endTimeField.text == ""){
            let alert = UIAlertController(title: "Invalid", message: "Information you entered is incomplete", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            doneButton.isEnabled = true
            cancelButton.isEnabled = true
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            return
        }
        if (endTimeField.selectedTime.compare(beginTimeField.selectedTime) == .orderedAscending){
            let alert = UIAlertController(title: "Invalid", message: "The time your entered is invalid", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            doneButton.isEnabled = true
            cancelButton.isEnabled = true
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            return
        }
        if (dateField.selectedDate.compare(Date()) == .orderedAscending){
            let alert = UIAlertController(title: "Invalid", message: "The date your entered has already passed", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            doneButton.isEnabled = true
            cancelButton.isEnabled = true
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            return
        }
        let newActivity = Activity()
        newActivity.date = selectedDate
        newActivity.startTime = startTime
        newActivity.endTime = endTime
        newActivity.description = descriptionField.text
        newActivity.name = titleField.text!
        newActivity.fullAddress = fullAddressString
        APIServiceController.sharedInstance.addActivity(newActivity, completeClosure: {
            self.doneButton.isEnabled = true
            self.cancelButton.isEnabled = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            _ = self.navigationController?.popViewController(animated: true)})
        }
    override func viewWillDisappear(_ animated: Bool) {
        ActivityController.sharedInstance.editingActivity = false
    }

    
    @IBAction func cancelEdPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func finishEdPressed(_ sender: AnyObject) {
        dateFormatter.dateFormat = "HH:mm:ss"
        let startTime = dateFormatter.string(from: beginTimeField.selectedTime as Date)
        print(startTime)
        let endTime = dateFormatter.string(from: endTimeField.selectedTime as Date)
        print(endTime)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: dateField.selectedDate as Date)
        if (startTime == "" || endTime == "" || date == ""){
            let alert = UIAlertController(title: "Invalid", message: "Information you entered is incorrect", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let apiService = APIService()
        apiService.createHeaderRequest(URL(string: "https://vinci-server.herokuapp.com/map/app-edit-event"), method: "POST", parameters: ["userId": UserController.sharedInstance.currentUser.userId as AnyObject,"title": titleField.text! as AnyObject, "description": descriptionField.text as AnyObject , "address": fullAddressString as AnyObject, "date":date as AnyObject, "startTime":startTime as AnyObject, "endTime": endTime as AnyObject, "privacy": "public" as AnyObject, "inviteeEmail": "" as AnyObject,"eventId":ActivityController.sharedInstance.currentActivity.activityId as AnyObject], requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print("update activity successfully")
                ActivityController.sharedInstance.currentActivity.fullAddress = self.fullAddressString
                ActivityController.sharedInstance.currentActivity.date = self.dateField.selectedDate
                ActivityController.sharedInstance.currentActivity.startTime = self.beginTimeField.selectedTime
                ActivityController.sharedInstance.currentActivity.endTime = self.endTimeField.selectedTime
                ActivityController.sharedInstance.currentActivity.description = self.descriptionField.text
                ActivityController.sharedInstance.currentActivity.name = self.titleField.text!
                UserController.sharedInstance.updateCurrentUserActivity(event: ActivityController.sharedInstance.currentActivity)
                self.dismiss(animated: true, completion: nil)
            }else{
                print("error")
                let alert = UIAlertController(title: "Invalid", message: "Information you entered is incorrect", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                print(json)
            }
        })

    }

  

}
