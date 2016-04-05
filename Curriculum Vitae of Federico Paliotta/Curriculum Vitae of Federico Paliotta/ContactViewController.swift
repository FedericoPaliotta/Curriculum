//
//  ContactViewController.swift
//  Curriculum
//
//  Created by Federico Paliotta on 12/11/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import UIKit
import ContactsUI

class ContactViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource, UITextFieldDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    weak var addEditTabBarController: AddYoursTabBarViewController!
    
    var editableContact: CNMutableContact?

    var contactToSave: CNContact? {
        didSet {
            editableContact = CNMutableContact()
            if contactToSave != nil {
                editableContact!.givenName = contactToSave!.givenName
                editableContact!.middleName = contactToSave!.middleName
                editableContact!.familyName = contactToSave!.familyName
                editableContact!.postalAddresses = contactToSave!.postalAddresses
                editableContact!.emailAddresses = contactToSave!.emailAddresses
                editableContact!.phoneNumbers = contactToSave!.phoneNumbers
                editableContact!.imageData = contactToSave!.imageData
            }
        }
    }
    
    // MARK: Contact Information
  
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var middleName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var addresses: UITableView!
    @IBOutlet weak var emails: UITableView!
    @IBOutlet weak var telephones: UITableView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func done(sender: AnyObject) {
        editableContact?.givenName = firstName.text!
        editableContact?.middleName = middleName.text!
        editableContact?.familyName = lastName.text!

        view.endEditing(true)
        
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.contact = editableContact
            addEditTabBarController.done()
        }
    }
    
    @IBAction func cancel(sender: AnyObject) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.cancel()
        }
    }
    
    @IBAction func pickImage() {
        startMediaBrowserFromViewController(usingDelegate: self)
    }
 
    
    func startMediaBrowserFromViewController(usingDelegate delegate: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>?) -> Bool {
        if (!UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) || delegate == nil) {
            return false
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = delegate
        
        presentViewController(imagePicker, animated: true, completion: nil)
        return true
    }
    
    
    // MARK: ViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addEditTabBarController = tabBarController as! AddYoursTabBarViewController
        addEditTabBarController.delegate = self
        
        navBar.delegate = addEditTabBarController
        
        // Setting text fields and text views delegates to TabBarController
        firstName.delegate = self
        middleName.delegate = self
        lastName.delegate = self

        // Setting table views datasource and delegate to self
        addresses.dataSource = self
        addresses.delegate = self
        emails.dataSource = self
        emails.delegate = self
        telephones.dataSource = self
        telephones.delegate = self
        
        // Setting outlets
        firstName.text = contactToSave?.givenName
        middleName.text = contactToSave?.middleName
        lastName.text = contactToSave?.familyName
        profileImage.layer.cornerRadius = 60
        if let imgData = contactToSave?.imageData {
            profileImage.image = UIImage(data: imgData)
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        stylist(view)
    }
    
    override func viewWillDisappear(animated: Bool) {
//        editableContact?.givenName = firstName.text!
//        editableContact?.middleName = middleName.text!
//        editableContact?.familyName = lastName.text!
        
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.contact = editableContact
        }
    }
        

    // MARK: TableViews datasource delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        } else {
            if let editableContact = editableContact {
                switch tableView {
                case addresses:
                    return editableContact.postalAddresses.count
                case emails:
                    return editableContact.emailAddresses.count
                case telephones:
                    return editableContact.phoneNumbers.count
                default: break
                }
            }
        return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return nil
        }
        switch tableView {
        case addresses:
            return Tables.Addresses
        case emails:
            return Tables.Emails
        case telephones:
            return Tables.Telephones
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch tableView {
        case addresses: // Addresses
            if indexPath.section == 1 {
                let adderCell = tableView.dequeueReusableCellWithIdentifier(CellIds.addAddress) as! AddNewCell
                adderCell.parentTable = tableView
                cell = adderCell
            } else {
                let addressCell = tableView.dequeueReusableCellWithIdentifier(CellIds.address)! as! AddressCell
                // Setting the cell's index property
                addressCell.rowIndex = indexPath.row
                // Setting the textFields' delegates
                addressCell.street.delegate = self
                addressCell.city.delegate = self
                addressCell.state.delegate = self
                addressCell.country.delegate = self
                addressCell.postCode.delegate = self
                // Setting the addresses' data
                if let postalAddress = editableContact?.postalAddresses[indexPath.row].value as? CNPostalAddress
                {
                    addressCell.street.text = postalAddress.street
                    addressCell.city.text = postalAddress.city
                    addressCell.state.text = postalAddress.state
                    addressCell.country.text = postalAddress.country
                    addressCell.postCode.text = postalAddress.postalCode
                }
                cell = addressCell
            }
        case emails: // Emails
            if indexPath.section == 1 {
                let adderCell = tableView.dequeueReusableCellWithIdentifier(CellIds.addEmail) as! AddNewCell
                adderCell.parentTable = tableView
                cell = adderCell
            } else {
                let emailCell = tableView.dequeueReusableCellWithIdentifier(CellIds.email) as! EmailCell
                // Setting the cell's index property
                emailCell.rowIndex = indexPath.row
                let emailAddress = editableContact?.emailAddresses[indexPath.row].value as? String
                emailCell.email.delegate = self
                emailCell.email.text = emailAddress
                cell = emailCell
            }
        case telephones: // Telephones
            if indexPath.section == 1 {
                let adderCell = tableView.dequeueReusableCellWithIdentifier(CellIds.addTelephone) as! AddNewCell
                adderCell.parentTable = tableView
                cell = adderCell
            } else {
                let telephoneCell = tableView.dequeueReusableCellWithIdentifier(CellIds.telephone) as! TelephoneCell
                // Setting the cell's index property
                telephoneCell.rowIndex = indexPath.row
                let phoneNumber = editableContact?.phoneNumbers[indexPath.row].value as? CNPhoneNumber
                telephoneCell.telephone.delegate = self
                telephoneCell.telephone.text = phoneNumber?.stringValue
                cell = telephoneCell
            }
        default:
            return UITableViewCell()
        }
        stylist(cell)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == addresses {
            if indexPath.section == 0 {
                return 123
            }
        }
        return 44
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
            switch tableView {
            case self.addresses:
                let addressCell = tableView.cellForRowAtIndexPath(indexPath) as! AddressCell
                // Set delegate to nil or get a crush !!
                addressCell.street.delegate = nil
                addressCell.city.delegate = nil
                addressCell.state.delegate = nil
                addressCell.country.delegate = nil
                addressCell.postCode.delegate = nil
                self.editableContact?.postalAddresses.removeAtIndex(indexPath.row)
            case self.emails:
                let emailCell = tableView.cellForRowAtIndexPath(indexPath) as! EmailCell
                // Set delegate to nil or get a crush !!
                emailCell.email.delegate = nil
                self.editableContact?.emailAddresses.removeAtIndex(indexPath.row)
            case self.telephones:
                let telephoneCell = tableView.cellForRowAtIndexPath(indexPath) as! TelephoneCell
                // Set delegate to nil or get a crush !!
                telephoneCell.telephone.delegate = nil
                self.editableContact?.phoneNumbers.removeAtIndex(indexPath.row)
            default: break
            }
           tableView.reloadData()
        }
        
        deleteAction.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.8)
        
        return [deleteAction]
    }
 
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
            addEditTabBarController.textFieldDidBeginEditing(textField)
        }
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        editableContact?.givenName = firstName.text!
        editableContact?.middleName = middleName.text!
        editableContact?.familyName = lastName.text!
        
        if let cell = textField.superview?.superview as? UITableViewCell {
            switch cell {
            case is AddressCell:
                let addressCell = cell as! AddressCell
                if var editingAddress = editableContact?.postalAddresses[addressCell.rowIndex].value as? CNPostalAddress {
                    let label = editableContact!.postalAddresses[addressCell.rowIndex].label
                    let tempAddress = CNMutablePostalAddress()
                    tempAddress.street = addressCell.street.text ?? editingAddress.street
                    tempAddress.city = addressCell.city.text ?? editingAddress.city
                    tempAddress.state = addressCell.state.text ?? editingAddress.state
                    tempAddress.country = addressCell.country.text ?? editingAddress.country
                    editingAddress = tempAddress
                    editableContact!.postalAddresses[addressCell.rowIndex] = CNLabeledValue(label: label, value: editingAddress)
                    
                    if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
                        addEditTabBarController.contact = editableContact
                    }
                }
            case is EmailCell:
                let emailCell = cell as! EmailCell
                if var editingEmail = editableContact!.emailAddresses[emailCell.rowIndex].value as? String {
                    let label = editableContact!.emailAddresses[emailCell.rowIndex].label
                    let tempEmail = emailCell.email.text ?? editingEmail
                    editingEmail = tempEmail
                    editableContact!.emailAddresses[emailCell.rowIndex] = CNLabeledValue(label: label, value: editingEmail)
                    
                    if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
                        addEditTabBarController.contact = editableContact
                    }
                }
            case is TelephoneCell:
                let telephoneCell = cell as! TelephoneCell
                if var editingTelephone = editableContact!.phoneNumbers[telephoneCell.rowIndex].value as? CNPhoneNumber {
                    let label = editableContact!.phoneNumbers[telephoneCell.rowIndex].label
                    let tempTelephone = telephoneCell.telephone.text ?? editingTelephone.stringValue
                    editingTelephone = CNPhoneNumber(stringValue: tempTelephone)
                    editableContact!.phoneNumbers[telephoneCell.rowIndex] = CNLabeledValue(label: label, value: editingTelephone)
                    
                    if let addEditTabBarController = tabBarController as? AddYoursTabBarViewController {
                        addEditTabBarController.contact = editableContact
                    }
                }
            default: break
            }
        }
    }



    // MARK: UIImagePickerControllerDelegate methods

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedEditedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage.image = pickedEditedImage
        }
        else if let pickedOriginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = pickedOriginalImage
        }
        
        // Here the imageData property on the editableContact gets set
        if let img = profileImage.image {
            editableContact?.imageData = UIImagePNGRepresentation(img)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
