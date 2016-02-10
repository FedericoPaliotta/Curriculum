//
//  ProfileViewController.swift
//  Curriculum
//
//  Created by Federico Paliotta on 13/11/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var cvTitle: String!
    @IBOutlet weak var curriculumTitle: UITextField!
    
    var profile: String!
    @IBOutlet weak var personalProfile: UITextView!
    
    
    @IBAction func done(sender: AnyObject) {
        view.endEditing(true)

        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumTitle = curriculumTitle.text
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
        curriculumTitle.text = cvTitle
        personalProfile.text = profile
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.curriculumTitle = curriculumTitle.text
            addEditTabBarController.curriculumProfile = personalProfile.text
        }
    }
}