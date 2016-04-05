//
//  TemplateViewController.swift
//  Curriculum
//
//  Created by Flatiron School on 4/3/16.
//  Copyright © 2016 Federico Paliotta. All rights reserved.
//

import UIKit

class TemplateViewController: UICollectionViewController {

    var cv = CurriculumVitae()
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let templateCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIds.templateCell, forIndexPath: indexPath) as! TemplateCell
        let template = indexPath.row == 0 ?  Templates.omero : Templates.william
        templateCell.title.text = template.stringByReplacingOccurrencesOfString("-", withString: " ")
        let html = CvWebMaster.composeHtml(cv, template: template)
        let mainBundle = NSBundle.mainBundle()
        let baseURL = NSURL(fileURLWithPath: mainBundle.bundlePath)
        templateCell.templatePreview.loadHTMLString(html, baseURL: baseURL)
        templateCell.layer.cornerRadius = 50
        return templateCell
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let nav = presentingViewController as? UINavigationController {
            if let cvVc = nav.viewControllers.first as? CurriculumViewController {
                cvVc.selectedTemplate = indexPath.row == 0 ?  Templates.omero : Templates.william
                cvVc.loadCurriculum(cvVc.curriculumModel)
                nav.dismissViewControllerAnimated(true, completion:nil)
            }
        }
    }
}
