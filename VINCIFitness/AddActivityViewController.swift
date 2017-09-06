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

class AddActivityViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, UIPickerViewDelegate, UITextViewDelegate{
    
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
    var privacy = ""
    var invites = ""
    var tap:UITapGestureRecognizer = UITapGestureRecognizer()
    var cancelButton = UIBarButtonItem()
    var doneButton = UIBarButtonItem()
    // var tagPicker = UIPickerView()
    @IBOutlet weak var tagPicker: UIPickerView!
    
    var tagText = UITextField()
    var tagLabel = UILabel()
    var tagArray = [String]()
    var privacySwitch = UISwitch()
    var privacyText = UILabel()
    var inviteLabel = UILabel()
    var inviteText = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainScreenSize = UIScreen.main.bounds
        tagArray = ["Social","Academic","Athletic","Other"]
        //showResultTable = false
        //set navigation item
        activityIndicator.isHidden = true
        tagPicker.isHidden = true
        tagPicker.delegate = self
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelPressed(_:)))
        doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.donePressed(_:)))
        privacySwitch.addTarget(self, action: #selector(self.switchValueDidChange(_:)), for: .valueChanged)
        cancelButton.tintColor = UIColor.vinciRed()
        doneButton.tintColor = UIColor.vinciRed()
        self.navigationItem.setLeftBarButton(cancelButton, animated: true)
        self.navigationItem.setRightBarButton(doneButton, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
        self.tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //set delegate
        searchingField.delegate = self
        tagText.delegate = self
        resultTable.delegate = self
        resultTable.dataSource = self
        descriptionField.delegate = self
        //tagText.delegate = tagPicker as! UITextFieldDelegate
        //privacyText.delegate = self
        inviteText.delegate = self
        //set element frame
        cancelEditingButton.backgroundColor = UIColor.vinciRed()
        finishEditingButton.backgroundColor = UIColor.vinciRed()
        
        privacySwitch.onTintColor = UIColor.vinciRed()
        
        if ActivityController.sharedInstance.editingActivity == false{
        notesLabel.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.48 * mainScreenSize.height, width:0.8 * mainScreenSize.width, height: 10)
        descriptionField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.5 * mainScreenSize.height, width: 0.8 * mainScreenSize.width, height: 40)
        titleField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.1 * mainScreenSize.height, width: 0.8 * mainScreenSize.width, height: 40)
        dateField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.3 * mainScreenSize.height, width: 0.8 * mainScreenSize.width, height: 40)
        searchingField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.2 * mainScreenSize.height, width: 0.8 * mainScreenSize.width, height: 40)
        beginTimeField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.4 * mainScreenSize.height, width: 120, height: 40)
        endTimeField.frame = CGRect(x: 0.57 * mainScreenSize.width, y: 0.4 * mainScreenSize.height, width: 120, height: 40)
        privacySwitch.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.58 * mainScreenSize.height, width: 120, height: 40)
        privacyText.frame = CGRect(x: 0.4 * mainScreenSize.width, y: 0.58 * mainScreenSize.height, width: 120, height: 40)
        tagLabel.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.65 * mainScreenSize.height, width: 120, height: 40)
        tagText.frame = CGRect(x: 0.4 * mainScreenSize.width, y: 0.65 * mainScreenSize.height, width: 120, height: 40)
        inviteLabel.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.72 * mainScreenSize.height, width: 120, height: 10)
        inviteText.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.74 * mainScreenSize.height, width: 0.8 * mainScreenSize.width, height: 40)
        resultTable.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.2 * mainScreenSize.height + 50, width: 0.8 * mainScreenSize.width, height: 0)
        }else{
            notesLabel.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.48 * mainScreenSize.height + 54, width: 40, height: 10)
            descriptionField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.5 * mainScreenSize.height + 54, width: 0.8 * mainScreenSize.width, height: 40)
            titleField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.1 * mainScreenSize.height + 54, width: 0.8 * mainScreenSize.width, height: 40)
            dateField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.3 * mainScreenSize.height + 54, width: 0.8 * mainScreenSize.width, height: 40)
            searchingField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.2 * mainScreenSize.height + 54, width: 0.8 * mainScreenSize.width, height: 40)
            beginTimeField.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.4 * mainScreenSize.height + 54, width: 120, height: 40)
            endTimeField.frame = CGRect(x: 0.57 * mainScreenSize.width, y: 0.4 * mainScreenSize.height + 54, width: 120, height: 40)
            privacySwitch.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.58 * mainScreenSize.height + 54, width: 120, height: 40)
            privacyText.frame = CGRect(x: 0.4 * mainScreenSize.width, y: 0.58 * mainScreenSize.height + 54, width: 120, height: 40)
            tagLabel.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.65 * mainScreenSize.height + 54, width: 120, height: 40)
            tagText.frame = CGRect(x: 0.4 * mainScreenSize.width, y: 0.65 * mainScreenSize.height + 54, width: 120, height: 40)
            inviteLabel.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.72 * mainScreenSize.height + 54, width: 120, height: 10)
            inviteText.frame = CGRect(x: 0.1 * mainScreenSize.width, y: 0.74 * mainScreenSize.height + 54, width: 0.8 * mainScreenSize.width, height: 40)
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
        self.view.addSubview(privacySwitch)
        self.view.addSubview(privacyText)
        self.view.addSubview(tagText)
        self.view.addSubview(tagLabel)
        self.view.addSubview(tagPicker)
        self.view.addSubview(inviteLabel)
        self.view.addSubview(inviteText)
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
        
        tagText.layer.borderWidth = 1
        tagText.layer.borderColor = UIColor.vinciGrey().cgColor
        tagText.borderStyle = .roundedRect
        tagText.textColor = UIColor.vinciRed()
        tagText.text = "Social"
        tagLabel.text = "Tag: "
        tagLabel.textColor = UIColor.vinciRed()
        tagLabel.font = UIFont.systemFont(ofSize: 17)
        //privacyText.layer.borderWidth = 1
        //privacyText.layer.borderColor = UIColor.vinciGrey().cgColor
        privacyText.text = "Public"
        privacyText.font = UIFont.systemFont(ofSize: 17)
        privacyText.textColor = UIColor.vinciRed()
        privacySwitch.setOn(true, animated: true)
        inviteLabel.text = "Invites: "
        inviteLabel.textColor = UIColor.vinciRed()
        inviteLabel.font = UIFont.systemFont(ofSize: 12)
        inviteLabel.textColor = UIColor.vinciRed()
        inviteText.layer.borderWidth = 1
        inviteText.layer.borderColor = UIColor.vinciGrey().cgColor
        //inviteText.borderStyle = .roundedRect
        

        
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
            privacyText.text = activity.privacy
            if(privacyText.text == "Private"){
                privacySwitch.setOn(false, animated: true)
            }
            else{
                privacySwitch.setOn(true, animated: true)
            }
            inviteText.text = activity.invites
            tagText.text = activity.tag
            fullAddressString = activity.fullAddress
            
            
        }
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return tagArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tagArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        tagText.text = tagArray[row]
        tagPicker.isHidden = true
        searchingField.isHidden = false
        dateField.isHidden = false
        endTimeField.isHidden = false
        beginTimeField.isHidden = false
        toView.isHidden = false
        titleField.isHidden = false
        privacySwitch.isHidden = false
        privacyText.isHidden = false
        tagLabel.isHidden = false
        tagText.isHidden = false
        tagPicker.isHidden = true
        inviteLabel.isHidden = false
        inviteText.isHidden = false
        descriptionField.isHidden = false
        notesLabel.isHidden = false
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
            privacySwitch.isHidden = true
            privacyText.isHidden = true
            inviteLabel.isHidden = true
            inviteText.isHidden = true
            tagLabel.isHidden = true
            tagText.isHidden = true
            descriptionField.isHidden = true
            notesLabel.isHidden = true
        }
        animateViewMoving(true, moveValue: 100)
        showResultTableView()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tagText{
            dateField.isHidden = true
            searchingField.isHidden = true
            endTimeField.isHidden = true
            beginTimeField.isHidden = true
            toView.isHidden = true
            titleField.isHidden = true
            privacySwitch.isHidden = true
            privacyText.isHidden = true
            inviteLabel.isHidden = true
            inviteText.isHidden = true
            descriptionField.isHidden = true
            notesLabel.isHidden = true
            tagLabel.isHidden = true
            tagText.isHidden = true
            tagPicker.isHidden = false
            return false
            //animateViewMoving(true, moveValue: 100)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchingField || textField == tagText{
            dateField.isHidden = false
            endTimeField.isHidden = false
            beginTimeField.isHidden = false
            toView.isHidden = false
            titleField.isHidden = false
            privacySwitch.isHidden = false
            privacyText.isHidden = false
            tagLabel.isHidden = false
            tagText.isHidden = false
            tagPicker.isHidden = true
            inviteLabel.isHidden = false
            inviteText.isHidden = false
            descriptionField.isHidden = false
            notesLabel.isHidden = false
        }
        animateViewMoving(false, moveValue: 100)
        hideResultTableView()
        self.searchingField.text = previousString
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.hideKeyboardWhenTappedWithR(tap)
        animateViewMoving(true, moveValue: 200)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.disableKeyboardWhenTappedWithR(tap)
        animateViewMoving(false, moveValue: 200)
    }
    func switchValueDidChange(_ sender: UISwitch) {
        if(privacySwitch.isOn){
            privacyText.text = "Public"
        }
        else{
            privacyText.text = "Private"
        }
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
    
    func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments)
    }
    func donePressed(_ sender:UIBarButtonItem){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        doneButton.isEnabled = false
        cancelButton.isEnabled = false
        selectedDate = dateField.selectedDate as Date
        startTime = beginTimeField.selectedTime as Date
        endTime = endTimeField.selectedTime as Date
        let eventTime = self.combineDateWithTime(date: selectedDate, time: startTime)
        
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
        if (eventTime?.compare(Date()) == .orderedAscending){
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
        newActivity.invites = inviteText.text
        newActivity.tag = tagText.text!
        newActivity.privacy = privacyText.text!.lowercased()
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
        let privacy = self.privacyText.text
        if(privacy == "Private"){
            privacySwitch.setOn(false, animated: true)
        }
        else{
            privacySwitch.setOn(true, animated: true)
        }
        let inviteeEmail = self.inviteText.text
        let description = self.descriptionField.text
        let title = self.titleField.text
        let tag = self.tagText.text
        let date = dateFormatter.string(from: dateField.selectedDate as Date)
        if (startTime == "" || endTime == "" || date == ""){
            let alert = UIAlertController(title: "Invalid", message: "Information you entered is incorrect", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let apiService = APIService()
        apiService.createHeaderRequest(URL(string: "https://vincilive2.herokuapp.com/map/edit-event"), method: "POST", parameters: ["title": title as AnyObject, "description": description as AnyObject , "address": fullAddressString as AnyObject, "date":date as AnyObject, "startTime":startTime as AnyObject, "endTime": endTime as AnyObject, "privacy": privacy?.lowercased() as AnyObject, "inviteeEmail": inviteeEmail as AnyObject,"eventId": ActivityController.sharedInstance.currentActivity.activityId as AnyObject, "tag": tag as AnyObject], requestCompletionFunction: {responseCode, json in
            if responseCode/100 == 2{
                print("update activity successfully")
                ActivityController.sharedInstance.currentActivity.fullAddress = self.fullAddressString
                ActivityController.sharedInstance.currentActivity.date = self.dateField.selectedDate
                ActivityController.sharedInstance.currentActivity.startTime = self.beginTimeField.selectedTime
                ActivityController.sharedInstance.currentActivity.endTime = self.endTimeField.selectedTime
                ActivityController.sharedInstance.currentActivity.description = self.descriptionField.text
                ActivityController.sharedInstance.currentActivity.name = self.titleField.text!
                ActivityController.sharedInstance.currentActivity.privacy = self.privacyText.text!
                ActivityController.sharedInstance.currentActivity.invites = self.inviteText.text!
                ActivityController.sharedInstance.currentActivity.tag = self.tagText.text!
                UserController.sharedInstance.updateCurrentUserActivity(event: ActivityController.sharedInstance.currentActivity)
                self.dismiss(animated: true, completion: nil)
            }else{
                print("error")
                print(responseCode)
                print(json)
                let alert = UIAlertController(title: "Invalid", message: "Information you entered is incorrect", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                print(json)
            }
        })

    }

  

}
