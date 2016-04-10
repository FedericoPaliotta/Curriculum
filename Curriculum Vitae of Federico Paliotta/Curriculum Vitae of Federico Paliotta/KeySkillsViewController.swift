//
//  KeySkillsViewController.swift
//  Curriculum
//
//  Created by Flatiron School on 3/23/16.
//  Copyright © 2016 Federico Paliotta. All rights reserved.
//

import UIKit

class KeySkillsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var keySkills = [SkillsSet]()

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var skillSets: UITableView!
    
    
    @IBAction func done(sender: AnyObject) {
        
        view.endEditing(true)
        
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumSkills = keySkills
            addEditTabBarController.done()
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.cancel()
        }
    }
    
    // MARK: ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        skillSets.delegate = self
        skillSets.dataSource = self
        if let addYoursTabBarVc = tabBarController as? AddYoursTabBarViewController {
            navBar.delegate = addYoursTabBarVc
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        stylist(view)
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumSkills = keySkills
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
        else {
            if tableView == skillSets {
                return keySkills.count
            }
            else if let parentSkillSetCell = tableView.superview?.superview as? SkillSetCell {
                let skillSetIndex = parentSkillSetCell.rowIndex
                return keySkills[skillSetIndex].skills.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.section == 1 {
            let cellId: String
            if tableView == skillSets {
                cellId = CellIds.addSkillSet
            }
            else {
                cellId = CellIds.addSkill
            }
            let adderCell = tableView.dequeueReusableCellWithIdentifier(cellId) as! AddNewCell
            adderCell.parentTable = tableView
            cell = adderCell
        }
        else {
            if tableView == skillSets {
                let skillSetCell = tableView.dequeueReusableCellWithIdentifier(CellIds.skillSet) as! SkillSetCell
                skillSetCell.rowIndex = indexPath.row
                // Setting UITextField delegate
                skillSetCell.skillSetTitle.delegate = self
                // Setting the UITableView delegate and datasource
                skillSetCell.skills.delegate = self
                skillSetCell.skills.dataSource = self
                skillSetCell.skills.reloadData()
                // Setting the pickerView delegate and datasource
                skillSetCell.skillSetQualification.delegate = self
                skillSetCell.skillSetQualification.dataSource = self
                // Setting data
                let skillSet = keySkills[indexPath.row]
                skillSetCell.skillSetTitle.text = skillSet.level.description
                let row = skillSet.level.intValue
                skillSetCell.skillSetQualification.selectRow(row, inComponent: 0, animated: false)
                cell = skillSetCell
            }
            else {
                let skillCell = tableView.dequeueReusableCellWithIdentifier(CellIds.skill) as! SkillCell
                skillCell.rowIndex = indexPath.row
                if let parentSkillSetCell = tableView.superview?.superview as? SkillSetCell {
                    let skillSetIndex = parentSkillSetCell.rowIndex
                    // Setting UITextField delegate
                    skillCell.skill.delegate = self
                    // Setting data
                    skillCell.skill.text = keySkills[skillSetIndex].skills[indexPath.row]
                }
                cell = skillCell
            }
        }
        stylist(cell)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 44
        }
        else {
            if tableView == skillSets {
                return 454
            }
            return 44
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
            if tableView == self.skillSets {
                let skillSetCell = tableView.cellForRowAtIndexPath(indexPath) as! SkillSetCell
                // Set delegate to nil or get a crush !!
                skillSetCell.skillSetTitle.delegate = nil
                self.keySkills.removeAtIndex(indexPath.row)
            } else if let parentSkillSetCell = tableView.superview?.superview as? SkillSetCell {
                let skillSetIndex = parentSkillSetCell.rowIndex
                let skillCell = tableView.cellForRowAtIndexPath(indexPath) as! SkillCell
                // Set delegate to nil or get a crush !!
                skillCell.skill.delegate = nil
                self.keySkills[skillSetIndex].skills.removeAtIndex(indexPath.row)
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
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SkillLevel.allValues[row]("").shortDescr
    }
    
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.textFieldDidBeginEditing(textField)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let skillSetCell = textField.superview?.superview as? SkillSetCell {
            let skillLevelPickerIndex = skillSetCell.skillSetQualification.selectedRowInComponent(0)
            let skillSetTitle = skillSetCell.skillSetTitle.text
            let skillSet = keySkills[skillSetCell.rowIndex]
                skillSet.level = SkillLevel(skillLevelPickerIndex, value: skillSetTitle)
        }
        else if let skillCell = textField.superview?.superview as? SkillCell {
            let skillIndex = skillCell.rowIndex
            if let parentSkillSetCell = skillCell.superview?.superview?.superview?.superview as? SkillSetCell {
                let skillSetIndex = parentSkillSetCell.rowIndex
                let skillSet = keySkills[skillSetIndex]
                skillSet.skills[skillIndex] = textField.text ?? skillSet.skills[skillIndex]
            }
        }
    }
    
}
