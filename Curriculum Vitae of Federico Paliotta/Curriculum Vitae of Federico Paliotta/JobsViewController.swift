//
//  JobsViewController.swift
//  Curriculum
//
//  Created by Federico Paliotta on 21/11/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import UIKit

class JobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate
{
    @IBOutlet weak var jobs: UITableView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    // MARK: Professional Experience

    var jobExperiences = [Job]()
    
    
    @IBAction func done(sender: AnyObject) {
        
        view.endEditing(true)
        
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumJobs = jobExperiences
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
        jobs.delegate = self
        jobs.dataSource = self
        if let addYoursTabBarVc = tabBarController as? AddYoursTabBarViewController {
            navBar.delegate = addYoursTabBarVc
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumJobs = jobExperiences
        }
    }
    
    
    
    // MARK: TableViews datasource delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsInSection = 0
        if section == 1 {
            rowsInSection = 1
        } else {
            if tableView == jobs {
                    rowsInSection = jobExperiences.count
            } else if let parentJobCell = tableView.superview?.superview as? JobCell {
                let jobIndex = parentJobCell.rowIndex
                rowsInSection = jobExperiences[jobIndex].specifications!.count
            }
        }
        return rowsInSection
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if tableView == jobs {
            if indexPath.section == 1 {
                let adderCell = tableView.dequeueReusableCellWithIdentifier(CellIds.addJob) as! AddNewCell
                adderCell.parentTable = tableView
                cell = adderCell
            } else {
                let jobCell = tableView.dequeueReusableCellWithIdentifier(CellIds.job) as! JobCell
                // Setting the cell's index property
                jobCell.rowIndex = indexPath.row
                // Setting the textFields' delegates
                jobCell.employer.delegate = self
                jobCell.jobTitle.delegate = self
                jobCell.since.delegate = self
                jobCell.until.delegate = self
                jobCell.duties.delegate = self
                // Setting the tableView delegate and datasource
                jobCell.specs.delegate = self
                jobCell.specs.dataSource = self
                jobCell.specs.reloadData()
                // Setting the jobs' data
                let job = jobExperiences[indexPath.row]
                jobCell.employer.text = job.employer
                jobCell.jobTitle.text = job.title
                jobCell.since.text = job.since
                jobCell.until.text = job.to
                jobCell.duties.text = job.duties
                
                // MARK: //////////
                jobCell.specs.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
                ///////////////////
                
                cell = jobCell
            }
        } else {
            if indexPath.section == 1 {
                let adderCell = tableView.dequeueReusableCellWithIdentifier(CellIds.addJobSpec) as! AddNewCell
                adderCell.parentTable = tableView
                cell = adderCell
            } else {
                let jobSpecCell = tableView.dequeueReusableCellWithIdentifier(CellIds.jobSpec) as! JobSpecCell
                jobSpecCell.rowIndex = indexPath.row
                jobSpecCell.jobSpecification.delegate = self
                if let parentJobCell = tableView.superview?.superview as? JobCell {
                    let jobIndex = parentJobCell.rowIndex
                    jobSpecCell.jobSpecification.text = self.jobExperiences[jobIndex].specifications?[indexPath.row]
                }
                cell = jobSpecCell
            }
        }
        stylist(cell)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 44
        }
        if tableView != jobs {
            return 128
        }
        return 512
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView != jobs && section == 0 {
            return Tables.JobSpecs
        }
        return nil
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
            if tableView == self.jobs {
                let jobCell = tableView.cellForRowAtIndexPath(indexPath) as! JobCell
                // Set delegate to nil or get a crush !!
                jobCell.employer.delegate = nil
                jobCell.jobTitle.delegate = nil
                jobCell.since.delegate = nil
                jobCell.until.delegate = nil
                jobCell.duties.delegate = nil
                self.jobExperiences.removeAtIndex(indexPath.row)
            } else if let parentJobCell = tableView.superview?.superview as? JobCell {
                let jobIndex = parentJobCell.rowIndex
                let jobSpecCell = tableView.cellForRowAtIndexPath(indexPath) as! JobSpecCell
                // Set delegate to nil or get a crush !!
                jobSpecCell.jobSpecification.delegate = nil
                self.jobExperiences[jobIndex].specifications?.removeAtIndex(indexPath.row)
            }
            tableView.reloadData()
        }
        
        deleteAction.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.8)
        
        return [deleteAction]
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
        if let jobCell = textField.superview?.superview as? JobCell {
            let job = jobExperiences[jobCell.rowIndex]
            job.employer = jobCell.employer.text ?? job.employer
            job.title = jobCell.jobTitle.text ?? job.title
            job.since = jobCell.since.text ?? job.since
            job.to = jobCell.until.text ?? job.to
            job.duties = jobCell.duties.text ?? job.duties
        }
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
        if let jobSpecCell = textView.superview?.superview as? JobSpecCell {
            let specIndex = jobSpecCell.rowIndex
            if let parentJobCell = jobSpecCell.superview?.superview?.superview?.superview as? JobCell {
                let jobIndex = parentJobCell.rowIndex
                let job = jobExperiences[jobIndex]
                job.specifications?[specIndex] = textView.text != nil ? textView.text! : (job.specifications?[specIndex])!
            }
        }
    }
    
    
}
