//
//  Curriculum
//
//  Created by Federico Paliotta on 10/11/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import UIKit
import Contacts

class AddNewCell: UITableViewCell
{
    weak var parentTable: UITableView?
    
    @IBOutlet var addButtons: [UIButton]! {
        didSet {
            for butt in addButtons! {
                butt.tintColor = UIColor(colorLiteralRed: 72 / 255.0,
                    green: 10 / 255.0,
                    blue: 2 / 255.0,
                    alpha: 1)
            }
        }
    }
    
    @IBAction func addNewCell(sender: AnyObject) {
        if let table = parentTable {
            if let contacVc = table.delegate as? ContactViewController {
                switch table {
                case contacVc.addresses:
                    contacVc.editableContact?.postalAddresses.append(CNLabeledValue(label: nil,  value: CNMutablePostalAddress()))
                case contacVc.emails:
                    contacVc.editableContact?.emailAddresses.append(CNLabeledValue(label: nil, value: ""))
                case contacVc.telephones:
                    contacVc.editableContact?.phoneNumbers.append(CNLabeledValue(label: nil, value: CNPhoneNumber(stringValue: "")))
                default: break
                }
            }
            if let jobVC = table.delegate as? JobsViewController {
                if table == jobVC.jobs {
                    let newJob = Job(employer: "", title: "", since: "", to: "", duties: "", specifications: [String]())
                    jobVC.jobExperiences.append(newJob)
                } else {
                    let newJobSpec = ""
                    if let parentJobCell = parentTable?.superview?.superview as? JobCell {
                        let jobIndex = parentJobCell.rowIndex
                        jobVC.jobExperiences[jobIndex].specifications?.append(newJobSpec)
                    }
                }
            }
            if let skillVc = table.delegate as? KeySkillsViewController {
                if table == skillVc.skillSets {
                    let newSkillSet = SkillsSet(level: SkillLevel.WellKnown(""), skills: [String]())
                    skillVc.keySkills.append(newSkillSet)
                } else {
                    let newSkill = ""
                    if let parentSkillSetCell = parentTable?.superview?.superview as? SkillSetCell {
                        let skillSetIndex = parentSkillSetCell.rowIndex
                        skillVc.keySkills[skillSetIndex].skills.append(newSkill)
                    }

                }
            }
            if let eduVC = table.delegate as? EducationViewController {
                if table == eduVC.educations {
                    let calendar = NSCalendar.currentCalendar()
                    let todaysYear = calendar.component(.Year, fromDate: NSDate())
                    let newEdu = Education(istitute:"", degree: "",
                        yearOfGraduation: todaysYear, accademicCurriculum: nil,
                        thesis: nil, advisor: nil)
                    eduVC.educs.append(newEdu)
                }
            }
            
            table.reloadData()
        }
    }
}


class AddressCell: UITableViewCell
{
    var rowIndex: Int!
    
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var postCode: UITextField!
}

class EmailCell: UITableViewCell
{
    var rowIndex: Int!

    @IBOutlet weak var email: UITextField!
}

class TelephoneCell: UITableViewCell
{
    var rowIndex: Int!

    @IBOutlet weak var telephone: UITextField!
}


class JobCell: UITableViewCell
{
    var rowIndex: Int!
    
    @IBOutlet weak var employer: UITextField!
    @IBOutlet weak var jobTitle: UITextField!
    @IBOutlet weak var since: UITextField!
    @IBOutlet weak var until: UITextField!
    @IBOutlet weak var duties: UITextField!
    
    @IBOutlet weak var specs: UITableView!
}

class JobSpecCell: UITableViewCell
{
    var rowIndex: Int!
    
    @IBOutlet weak var jobSpecification: UITextView!
}

class EducationCell: UITableViewCell
{
    var rowIndex: Int!
    
    @IBOutlet weak var istitute: UITextField!
    @IBOutlet weak var degree: UITextField!
    @IBOutlet weak var year: UIPickerView!
    @IBOutlet weak var accademicCurriculum: UITextView!
    @IBOutlet weak var thesis: UITextField!
    @IBOutlet weak var advisor: UITextField!
    
}

class SkillSetCell: UITableViewCell
{
    var rowIndex: Int!
    
    @IBOutlet weak var skillSetTitle: UITextField!
    
    @IBOutlet weak var skillSetQualification: UIPickerView!
    
    @IBOutlet weak var skills: UITableView!
}

class SkillCell: UITableViewCell
{
    var rowIndex: Int!
    
    @IBOutlet weak var skill: UITextField!
    
}



class TemplateCell: UICollectionViewCell
{    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var templatePreview: UIWebView!
}

////