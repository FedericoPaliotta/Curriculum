//
//  AddAddressCell.swift
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
               table.reloadData()
            }
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





////