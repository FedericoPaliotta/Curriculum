//
//  ViewController.swift
//  Curriculum
//
//  Created by Federico Paliotta on 27/10/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import UIKit
import MessageUI

class CurriculumViewController: UIViewController, MFMailComposeViewControllerDelegate, CurriculumEditorDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()
    var isTheDefaultModel = true
    var selectedTemplate = Templates.omero
    var curriculumModel: CurriculumVitae {
        get {
            // Here I return the persistent curriculum if there's any, othewise I'm just 
            // going to teturn the default "Curriculum Vitae of Federico Paliotta"
            if let unarchivedObject = defaults.objectForKey(Constants.persistentCv) as? NSData {
                if let persistentCurriculumModel = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? CurriculumVitae {
                    isTheDefaultModel = false
                    return persistentCurriculumModel
                } else {
                    isTheDefaultModel = true
                    return CurriculumVitae()
                }
            } else {
                isTheDefaultModel = true
                return CurriculumVitae()
            }
        }
        set { // Here I save it when the property gets set
            let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(newValue)
            defaults.setObject(archivedObject, forKey: Constants.persistentCv)
            defaults.synchronize()
            isTheDefaultModel = false
        }
    }
   
    @IBOutlet weak var webViewer: UIWebView!
    
    @IBAction func action(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(
            title: "Send Via Email",
            style: .Default,
            handler: { (alertAction) -> Void in
                self.emailCurriculum()
        }))
        
        alert.addAction(UIAlertAction(
            title: "Preview Pdf",
            style: .Default,
            handler: { (alertAction) -> Void in
                self.printToPdf()
        }))
        
        alert.addAction(UIAlertAction(
            title: isTheDefaultModel ? "Delete and Add Yours" : "Edit Curriculum",
            style: .Destructive,
            handler: { (alertAction) -> Void in
                self.showAddYoursViewController()
        }))
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .Cancel,
            handler: nil))
        
        alert.modalPresentationStyle = .Popover
        let ppc = alert.popoverPresentationController
        ppc?.barButtonItem = sender
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func loadCurriculum(sender: UIBarButtonItem? = nil) {
        let mainBundle = NSBundle.mainBundle()
//        var htmlString = ""
//        if let indexURL = mainBundle.pathForResource("index-william", ofType: "html") {
//            do {
//                htmlString = try NSString(contentsOfFile: indexURL, encoding: NSUTF8StringEncoding) as String
//            } catch {
//                print("Couldn't parse index.html file")
//            }
//            webViewer.loadHTMLString(htmlString, baseURL: NSURL(fileURLWithPath: mainBundle.bundlePath))
//        }

        let htmlString = CvWebMaster.composeHtml(curriculumModel, withTemplate: selectedTemplate)
        //print(htmlString) // Todo: take this out
        webViewer.loadHTMLString(htmlString, baseURL: NSURL(fileURLWithPath: mainBundle.bundlePath))
    }

    
    func printToPdf() {
        let pdfFormatter = webViewer.viewPrintFormatter()
        let pdfRenderer = UIPrintPageRenderer()
        pdfRenderer.addPrintFormatter(pdfFormatter, startingAtPageAtIndex: 0)
        //let printablePage = CGRectInset(webViewer.frame, 0, 0)
        pdfRenderer.setValue(NSValue(CGRect: webViewer.frame), forKey: "paperRect")
        pdfRenderer.setValue(NSValue(CGRect: webViewer.frame), forKey: "printableRect")
        let pdfData = NSMutableData()
       
        UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil)
        for var i = 0; i < pdfRenderer.numberOfPages(); i++ {
            UIGraphicsBeginPDFPageWithInfo(view.bounds, nil)
//            print("outer rect: \n\(webViewer.bounds)")
//            print("inner rect: \n\(UIGraphicsGetPDFContextBounds())")
            pdfRenderer.drawPageAtIndex(i, inRect: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        
        if var docURL = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last {
            docURL = docURL.URLByAppendingPathComponent("fpcv.pdf")
            pdfData.writeToURL(docURL, atomically: true)
            let request = NSURLRequest(URL: docURL)
            webViewer.loadRequest(request)
        }
    }
    
    func emailCurriculum() {
        if( MFMailComposeViewController.canSendMail() ) {
            let htmlString = CvWebMaster.composeHtml(curriculumModel, withTemplate: selectedTemplate)
            let mailComposer = MFMailComposeViewController()
            mailComposer.setSubject("Curriculm Vitae of \(curriculumModel.me.fullName)")
            mailComposer.setMessageBody(htmlString, isHTML: true)
            if var docURL = (NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)).last {
                docURL = docURL.URLByAppendingPathComponent("fpcv.pdf")
                if let fileData = NSData(contentsOfURL: docURL) {
                    mailComposer.addAttachmentData(fileData,
                                        mimeType: "application/pdf",
                                        fileName: "Curriculm Vitae of \(curriculumModel.me.fullName)")
                }
                presentViewController(mailComposer, animated: true, completion: nil)
                mailComposer.mailComposeDelegate = self
            }
        }
    }
    
    func showAddYoursViewController() {
        performSegueWithIdentifier(SegueIds.showAddEditVc, sender: nil)
    }
    
    override func viewDidLoad() {
        loadCurriculum()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let addEditTabBarController = segue.destinationViewController as? AddYoursTabBarViewController {
            if let id = segue.identifier {
                switch id {
                case SegueIds.showAddEditVc:
                    if !isTheDefaultModel {
                        addEditTabBarController.curriculumToSave = curriculumModel
                    }
                    addEditTabBarController.curriculumEditorDelegate = self
                default: break
                }
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editorDidEndEditingCurriculum(curriculum: CurriculumVitae?, withStateDone state: Bool) {
        if let cv = curriculum where state { // is Done
            curriculumModel = cv
            loadCurriculum()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else { // Cancel
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

