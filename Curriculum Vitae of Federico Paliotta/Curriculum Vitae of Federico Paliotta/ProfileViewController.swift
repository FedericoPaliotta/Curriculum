//
//  ProfileViewController.swift
//  Curriculum
//
//  Created by Federico Paliotta on 13/11/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var cvTitle: String!
    @IBOutlet weak var curriculumTitle: UITextField!
    
    var cvBlog: String!
    @IBOutlet weak var personalBlog: UITextField!
    
    var profile: String!
    @IBOutlet weak var personalProfile: UITextView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func done(sender: AnyObject) {
        view.endEditing(true)

        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumTitle = curriculumTitle.text
            addEditTabBarController.curriculumBlog = personalBlog.text
            addEditTabBarController.curriculumProfile = personalProfile.text
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
        if let addYoursTabBarVc = tabBarController as? AddYoursTabBarViewController {
            navBar.delegate = addYoursTabBarVc
        }
        curriculumTitle.delegate = self
        personalBlog.delegate = self
        personalProfile.delegate = self
        curriculumTitle.text = cvTitle
        personalBlog.text = cvBlog
        personalProfile.text = profile
    }
    
    override func viewWillAppear(animated: Bool) {
        stylist(view)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumTitle = cvTitle
            addEditTabBarController.curriculumProfile = profile
            addEditTabBarController.curriculumBlog = cvBlog
        }
    }
    
    // MARK: UITextFieldDelegate methods
    
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
    
    func textFieldDidEndEditing(textFild: UITextField) {
        cvTitle = curriculumTitle.text ?? cvTitle
        cvBlog = personalBlog.text ?? cvBlog
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        profile = personalProfile.text ?? profile
    }
}
