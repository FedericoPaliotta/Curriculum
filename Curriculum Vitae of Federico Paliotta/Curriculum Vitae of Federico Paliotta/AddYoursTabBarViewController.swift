//
//  TabBarViewController.swift
//  Curriculum
//
//  Created by Federico Paliotta on 07/11/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import UIKit
import Contacts



protocol CurriculumEditorDelegate
{
    func editorDidEndEditingCurriculum(cv: CurriculumVitae?, withStateDone state: Bool)
}


class AddYoursTabBarViewController: UITabBarController, UITextFieldDelegate, UITextViewDelegate, UINavigationBarDelegate
{
    
    var curriculumEditorDelegate: CurriculumEditorDelegate?
    
    var curriculumToSave: CurriculumVitae!
//        { didSet { print("I GOT SET") } }
    
    var contact: CNContact?
    
    var curriculumTitle: String?
    var curriculumProfile: String?

    var curriculumJobs: [Job]?
    
    var curriculumSkills: [SkillsSet]?
    
    var curriculumEdus: [Education]?
    
    
    @IBOutlet weak var cvTabBar: UITabBar! {
        didSet {
            cvTabBar.tintColor = UIColor(colorLiteralRed: 72 / 255.0,
                green: 10 / 255.0,
                blue: 2 / 255.0,
                alpha: 1)
        }
    }
    
    
    func done() {
        let cv = CurriculumVitae(me: contact, title: curriculumTitle,
            profile: curriculumProfile, jobs: curriculumJobs,
            education: curriculumEdus, skills: curriculumSkills)
        
        curriculumEditorDelegate?.editorDidEndEditingCurriculum(cv, withStateDone: true)
    }
    
    func cancel() {
        let alert = UIAlertController(
            title: "Are you sure you want to exit editing mode?",
            message: "All changes will be lost.",
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "No",
            style: .Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes",
            style: .Destructive, handler: {
                (alertAction) -> Void in
                self.curriculumEditorDelegate?.editorDidEndEditingCurriculum(nil, withStateDone: false)
            }
        ))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        jobs = CurriculumVitae().jobs
        
        if let tabs = viewControllers {
            for tab in tabs {
                switch tab {
                case is ContactViewController:
                    let contactCv = tab as! ContactViewController
                        contactCv.contactToSave = curriculumToSave?.me
                        stylist(contactCv.view)
                        contactCv.viewWillDisappear(false)
                case is ProfileViewController:
                    let profileCv = tab as! ProfileViewController
                        profileCv.cvTitle = curriculumToSave?.title
                        profileCv.profile = curriculumToSave?.profile
                        stylist(profileCv.view)
                        profileCv.viewWillDisappear(false)
                case is JobsViewController:
                    let jobCv = tab as! JobsViewController
                    if let jobs = curriculumToSave?.jobs {
                        jobCv.jobExperiences = jobs
                    }
                    stylist(jobCv.view)
                    selectedViewController = jobCv
                    // jobCv.viewWillDisappear(true) not necessary,
                    // since the view appears by default.
                case is KeySkillsViewController:
                    let keySkillCv = tab as! KeySkillsViewController
                    if let keySkills = curriculumToSave?.skills {
                        keySkillCv.keySkills = keySkills
                        stylist(keySkillCv.view)
                        keySkillCv.viewWillDisappear(false)
                    }
                case is EducationViewController:
                    let educationCv = tab as! EducationViewController
                    if let educations = curriculumToSave?.education {
                        educationCv.educs = educations
                        stylist(educationCv.view)
                        educationCv.viewWillDisappear(false)
                    }
                default: continue
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
        
    }
    
    
    // TODO: this all below is buggy
    
    // MARK: TextField/TextView delegate
    
    var activeInputOrigin: CGPoint?
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let mainWindow = UIApplication.sharedApplication().keyWindow {
            let pointInWindowCoords = mainWindow.convertPoint(textField.frame.origin, fromView: textField.superview)
            activeInputOrigin = scrollView?.convertPoint(pointInWindowCoords, fromView: mainWindow)
        }
    }
    // TODO: fix on landscape, the scrolling point is calculated wrong!
    func textViewDidBeginEditing(textView: UITextView) {
        let textViewEndPoint = CGPoint(x: textView.frame.origin.x, y: textView.frame.origin.y + textView.frame.height)
        if let mainWindow = UIApplication.sharedApplication().keyWindow {
            let pointInWindowCoords = mainWindow.convertPoint(textViewEndPoint, fromView: textView.superview)
            activeInputOrigin = scrollView?.convertPoint(pointInWindowCoords, fromView: mainWindow)
        }
    }
    
    
    // MARK: Keyboard handling
    
    
    var scrollView: UIScrollView? {
        return selectedViewController?.view.subviews.first as? UIScrollView
    }
    
    func registerKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddYoursTabBarViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddYoursTabBarViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
        let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
        var viewRect = view.frame
        viewRect.size.height -= keyboardSize.height
        print("Visible Rect \(viewRect.size)")
        if activeInputOrigin != nil && !CGRectContainsPoint(viewRect, activeInputOrigin!) {
            scrollView?.contentInset = contentInsets
            scrollView?.scrollIndicatorInsets = contentInsets
            let scrollPoint = CGPointMake(0, activeInputOrigin!.y - keyboardSize.height)
            scrollView?.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView?.contentInset = UIEdgeInsetsZero
        scrollView?.scrollIndicatorInsets = UIEdgeInsetsZero
    }
  
    
    // MARK: UINavigationBarDelegate
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}
