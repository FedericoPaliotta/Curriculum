//
//  ViewController.swift
//  Curriculum
//
//  Created by Federico Paliotta on 27/10/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import UIKit
import MessageUI

var isTheDefaultModel = true

class CurriculumViewController: UIViewController, MFMailComposeViewControllerDelegate, UIScrollViewDelegate, CurriculumEditorDelegate {

    let defaults = NSUserDefaults.standardUserDefaults()
    var selectedTemplate = Templates.omero 
    var curriculumModel: CurriculumVitae {
        get {
            // Here I return the persistent curriculum if there's any, othewise I'm just 
            // going to return the default "Curriculum Vitae of Federico Paliotta"
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
   
    var underNavBarBottomLine: NSLayoutConstraint!
    var underNavBarTopLine: NSLayoutConstraint!
    
    var menuIsCollapsed = true {
        didSet {
            if menuIsCollapsed {
                self.menuButton.image = UIImage.init(imageLiteral: "Expand Arrow-48")
            }
            else {
                self.menuButton.image = UIImage.init(imageLiteral: "Collapse Arrow-48")
            }
        }
    }
    
    @IBOutlet weak var underNavBar: UIView!
    @IBOutlet weak var webViewer: UIWebView!
    @IBOutlet weak var homeButton: UIBarButtonItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    @IBAction func sendViaEmail() {
        self.emailCurriculum()
        hideUnderNavBar(self)
    }
    @IBAction func previewPdf() {
        self.printToPdf()
        hideUnderNavBar(self)
    }
    @IBAction func addOrEdit() {
        self.showAddYoursViewController()
        hideUnderNavBar(self)
    }
    
//    var omero = true {
//        didSet {
//            if omero {
//                selectedTemplate = Templates.omero
//            }
//            else {
//                selectedTemplate = Templates.william
//            }
//        }
//    }
    
    @IBAction func chooseTemplate() {
        hideUnderNavBar(self)
//        omero = !omero
//        loadCurriculum(curriculumModel)
        if let templateVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChooseTemplateVc") as? TemplateViewController {
            templateVC.cv = curriculumModel
            presentViewController(templateVC, animated: true, completion: nil)
        }
    }
    
    let showHideUnderNavBar = { (cVc: CurriculumViewController) -> () in
        
        cVc.menuIsCollapsed = !cVc.menuIsCollapsed
        
        UIView.animateWithDuration(0.4) { () -> Void in
            cVc.underNavBarBottomLine.active = !cVc.underNavBarBottomLine.active
            cVc.underNavBarTopLine.active = !cVc.underNavBarTopLine.active
            cVc.view.layoutIfNeeded()
        }
    }
    
    let hideUnderNavBar = { (cVc: CurriculumViewController) -> () in
        
        cVc.menuIsCollapsed = true
        
        UIView.animateWithDuration(0.4) { () -> Void in
            cVc.underNavBarTopLine.active = false
            cVc.underNavBarBottomLine.active = true
            cVc.view.layoutIfNeeded()
        }
    }

    @IBAction func action(sender: UIBarButtonItem) {
        showHideUnderNavBar(self)
    }
    
    @IBAction func loadCurriculum(cv: AnyObject) {
        let mainBundle = NSBundle.mainBundle()
        var curriculum = curriculumModel
        if let cv = cv as? CurriculumVitae {
            curriculum = cv
        }
        let htmlString = CvWebMaster.composeHtml(curriculum, template: selectedTemplate)
//        print(htmlString)
        let baseURL = NSURL(fileURLWithPath: mainBundle.bundlePath)
     
        webViewer.loadHTMLString(htmlString, baseURL: baseURL)
        
//        NSURLCache.sharedURLCache().removeAllCachedResponses()
//        let filename = getDocumentsDirectory().stringByAppendingString("/cv.html")
//        do {
//            let success = try Bool(htmlString.writeToURL(NSURL(fileURLWithPath: filename), atomically: true, encoding: NSUTF8StringEncoding))
//            print("\nCREATED? \(success)\n" + filename)
//        } catch let err as NSError {
//            print(err.localizedDescription)
//        }
//        let requ = NSURLRequest(URL: NSURL(fileURLWithPath: filename), cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 60.0)
//        webViewer.loadRequest(requ)
        hideUnderNavBar(self)
    }

    func reloadDefault() {
        loadCurriculum(CurriculumVitae())
        curriculumModel = CurriculumVitae()
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
        for i in 0 ..< pdfRenderer.numberOfPages() {
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
            let htmlString = CvWebMaster.composeHtml(curriculumModel, template: selectedTemplate)
            let mailComposer = MFMailComposeViewController()
            mailComposer.setSubject("Curriculum Vitae of \(curriculumModel.me.fullName)")
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
        webViewer.scrollView.delegate = self
//        let navBar = navigationController!.navigationBar
//        let navBarEndingY = navBar.frame.height + navBar.frame.origin.y
        buttStylist(underNavBar)
        
        underNavBar.heightAnchor.constraintEqualToConstant(80).active = true
        underNavBar.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        underNavBar.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
       
        underNavBarBottomLine = underNavBar.bottomAnchor.constraintEqualToAnchor(view.topAnchor)
        underNavBarBottomLine.active = true
        underNavBarTopLine = underNavBar.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.4 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.underNavBar.hidden = false
        }
        
        loadCurriculum(curriculumModel)

        let tapSequence = UITapGestureRecognizer(target: self, action: #selector(CurriculumViewController.reloadDefault))
            tapSequence.numberOfTapsRequired = 3
            tapSequence.numberOfTouchesRequired = 2
        view.addGestureRecognizer(tapSequence)
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
            saveProfileImageInMainBundle(cv.me.imageData)
            loadCurriculum(curriculumModel)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else { // Cancel
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func saveProfileImageInMainBundle(imgData:NSData?) {
        if let data = imgData {
            let filename = getDocumentsDirectory().stringByAppendingPathComponent("myProfilePicture.jpg")
            do {
                let deleted = try Bool(NSFileManager.defaultManager().removeItemAtPath(filename))
                print("\nDELETED? \(deleted)\n" + filename)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            let success = Bool(data.writeToFile(filename, atomically: true))
            print("\nCREATED? \(success)\n" + filename)
        }
    }
    
     
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
//            print(scrollView.contentOffset.y)
            scrollViewDidScrollToTop(scrollView)
        }
        else {
            hideUnderNavBar(self)
        }
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.navigationController?.navigationBarHidden = false
        }
    }
    
}

func getDocumentsDirectory() -> NSString
{
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func buttStylist(view:UIView) -> ()
{
    if let butt = view as? UIButton {
//        butt.tintColor = UIColor(colorLiteralRed: 174 / 255.0,
//                                 green: 0 / 255.0,
//                                 blue: 4 / 255.0,
//                                 alpha: 1)
        butt.tintColor = UIColor.lightGrayColor()
    }
    else {
        for v in view.subviews {
            buttStylist(v)
        }
    }
}

func stylist(view:UIView) {
    
    let transparent = UIColor.whiteColor().colorWithAlphaComponent(0)
    let shadow = UIColor.whiteColor().colorWithAlphaComponent(0.3)
    let radius: CGFloat = 3
    let borderWidth: CGFloat = 0.2
//    UIColor.blueColor() //
    if let textField = view as? UITextField {
        textField.backgroundColor = shadow
        textField.borderStyle = UITextBorderStyle.None
        textField.layer.cornerRadius = radius
        let h = textField.heightAnchor.constraintEqualToConstant(30)
//            h.priority = 999
            h.active = true
    }
    else if let textView = view as? UITextView {
        textView.layer.backgroundColor = shadow.CGColor
        textView.layer.borderWidth = 0
        textView.layer.cornerRadius = radius
    }
    else if let header = view as? UITableViewHeaderFooterView {
//        let parentRootView = rootSuperView(header)
//        let bgColor = parentRootView.backgroundColor
//        header.backgroundView?.backgroundColor = bgColor
        header.backgroundView?.backgroundColor = transparent
    }
    else if let tableCell = view as? UITableViewCell {
        tableCell.backgroundColor = transparent
        tableCell.contentView.backgroundColor = transparent
        tableCell.layer.cornerRadius = radius
        tableCell.layer.borderWidth = borderWidth
        for subV in tableCell.subviews {
            stylist(subV)
        }
    }
    else if let tableView = view as? UITableView {
        tableView.backgroundColor = transparent
        tableView.tintColor = transparent
        for subV in tableView.subviews {
            stylist(subV)
        }
    }
    else {
        for subV in view.subviews {
            stylist(subV)
        }
    }
}

func rootSuperView(subview: UIView) -> UIView {
    if subview.superview == nil {
        return subview.subviews.first!
    }
    else {
        return rootSuperView(subview.superview!)
    }
}
