//
//  EducationViewController.swift
//  Curriculum
//
//  Created by Flatiron School on 3/23/16.
//  Copyright © 2016 Federico Paliotta. All rights reserved.
//

import UIKit

class EducationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var educations: UITableView!
    
    var educs = [Education]()
    
    @IBAction func done(sender: AnyObject) {
        
        view.endEditing(true)
        
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumEdus = educs
            addEditTabBarController.done()
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        educations.delegate = self
        educations.dataSource = self
        if let addYoursTabBarVc = tabBarController as? AddYoursTabBarViewController {
            navBar.delegate = addYoursTabBarVc
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        stylist(view)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumEdus = educs
        }
    }
    
    
    // MARK: UITableView delegate and datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return educs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if indexPath.section == 1 {
            let adderCell = tableView.dequeueReusableCellWithIdentifier(CellIds.addEducation) as! AddNewCell
            adderCell.parentTable = tableView
            cell = adderCell
        } else {
            let eduCell = tableView.dequeueReusableCellWithIdentifier(CellIds.education) as! EducationCell
            eduCell.rowIndex = indexPath.row
            // Setting UITextFied, UITextView, and UIPickerView delegate
            eduCell.istitute.delegate = self
            eduCell.degree.delegate = self
            eduCell.year.delegate = self
            eduCell.accademicCurriculum.delegate = self
            eduCell.thesis.delegate = self
            eduCell.advisor.delegate = self
            // Setting data
            let educ = educs[indexPath.row]
            eduCell.istitute.text = educ.istitute
            eduCell.degree.text = educ.degree
            eduCell.year.selectRow(educ.yearOfGraduation - 1901, inComponent: 0,
                                                                    animated: false)
//            print(eduCell.year.delegate?.pickerView!(eduCell.year, titleForRow: 116, forComponent: 0))
            eduCell.accademicCurriculum.text = educ.accademicCurriculum
            eduCell.thesis.text = educ.thesis
            eduCell.advisor.text = educ.advisor
        
            cell = eduCell
        }
        stylist(cell)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 44
        }
        else {
            return 520
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 1 {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {
            [unowned self] (action , indexPath) -> Void in
            if tableView == self.educations {
                let eduCell = tableView.cellForRowAtIndexPath(indexPath) as! EducationCell
                // Set delegate to nil or get a crush !!
                eduCell.istitute .delegate = nil
                eduCell.degree.delegate = nil
//                eduCell.year.delegate = nil
                eduCell.accademicCurriculum.delegate = nil
                eduCell.thesis.delegate = nil
                self.educs.removeAtIndex(indexPath.row)
            }
            tableView.reloadData()
        }
        
        deleteAction.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.8)
        
        return [deleteAction]
    }

    
    
    // MARK: UIPickerView delegate and datasource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let todaysYear = calendar.component(.Year, fromDate: NSDate())
        return todaysYear - 1900
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1901)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let eduCell = pickerView.superview?.superview as? EducationCell {
            let educ = educs[eduCell.rowIndex]
            educ.yearOfGraduation = eduCell.year.selectedRowInComponent(0) + 1901
        }
    }
    
    // MARK: UITextFieldDelegate and UITextViewDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.textFieldDidBeginEditing(textField)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.textViewDidBeginEditing(textView)
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if let eduCell = textField.superview?.superview as? EducationCell {
            let educ = educs[eduCell.rowIndex]
            educ.istitute = eduCell.istitute.text ?? educ.istitute
            educ.degree = eduCell.degree.text ?? educ.degree
            educ.thesis = eduCell.thesis.text ?? educ.thesis
            educ.advisor = eduCell.advisor.text ?? educ.advisor
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if let eduCell = textView.superview?.superview as? EducationCell {
            let educ = educs[eduCell.rowIndex]
            educ.accademicCurriculum = eduCell.accademicCurriculum.text ?? educ.accademicCurriculum
        }
    }
    
}