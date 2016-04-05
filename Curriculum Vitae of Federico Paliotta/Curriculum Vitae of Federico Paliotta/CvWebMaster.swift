//
//  WebMaster.swift
//  Curriculum
//
//  Created by Federico Paliotta on 02/11/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import Foundation
import Contacts
// Mark: Page Composer

struct CvWebMaster {
    static var htmlDeclaration = HtmlTagGenerator.doctype
    
    static func composeHtml(cv: CurriculumVitae, template: String) -> String {
        var htmlCode = htmlDeclaration
        
        // MARK: Page header
        
        let docTitle = HtmlTagGenerator.title("\(cv.me != nil ? cv.me!.fullName : "" ) - Curriculum Vitae")
        let me =
            "<meta name=\"viewport\" content=\"width=device-width\"/> \n" +
            "<meta name=\"description\" content=\"The Curriculum Vitae of Federico Paliotta.\"/> \n"
        let ta =
            "<meta charset=\"UTF-8\"> \n"
        let cssFile = "   -+=*!INJECT_CSS_HERE!*=+-   "
        let da = HtmlTagGenerator.style(cssFile)
//            "<link type=\"text/css\" rel=\"stylesheet\" href=\"\(withTemplate ?? Templates.defaultStyle).css\"> \n"
        let ti =
            "<link type=\"text/css\" rel=\"stylesheet\" href=\"http://fonts.googleapis.com/css?family=Rokkitt:400,700|Lato:400,300\"> \n"
        
        
        let metadata = me + ta + da + ti 
        
        let pageHeader = HtmlTagGenerator.head(docTitle + metadata)
        
        htmlCode += pageHeader

        
        
        // MARK: Page body
        
        
        // MARK: --- Main Details
        var imgPath = ""
        
        if isTheDefaultModel {
            imgPath = "myProfilePicture.jpg"
        }
        else {
            imgPath = getDocumentsDirectory().stringByAppendingPathComponent("myProfilePicture.jpg")
        }
        let headShotImg = HtmlTagGenerator.img(imgPath, alt: cv.me != nil ? cv.me!.fullName : "" )
        let headShotDiv = HtmlTagGenerator.div(headShotImg, id: "headshot", cssClass: "quickFade")
        
        // Main Details Composition
        let name    = HtmlTagGenerator.h(1, content: cv.me != nil ? cv.me!.fullName : "" , cssClass: "quickFade delayTwo")
        let title   = HtmlTagGenerator.h(2, content: cv.title ?? "", cssClass: "quickFade delayThree")
        let nameDiv = HtmlTagGenerator.div(name + title, id: "name")
        
        let emailAddress = cv.me?.emailAddresses.first?.value as? String ?? ""
        let email = HtmlTagGenerator.a("mailto:\(emailAddress)",
                            anchorText: emailAddress.stringByReplacingOccurrencesOfString("@", withString: " AT "),
                                inLine: true,
                                target: "_blank")
        let emailItem = HtmlTagGenerator.li("e: \(email)")
    
        let telephoneNumber = cv.me?.phoneNumbers.first?.value as? CNPhoneNumber ?? CNPhoneNumber(stringValue: "")
        let telephoneItem = HtmlTagGenerator.li("m: \(telephoneNumber.stringValue)")
        
        var listContent = emailItem + telephoneItem
        
        
        if let blog = cv.blog where blog != "" {
            let blogItem = HtmlTagGenerator.li("b: \(blog)")
            listContent += blogItem
        }
        
        let contactDetails = HtmlTagGenerator.ul(listContent)
        let contactDetailsDiv = HtmlTagGenerator.div(contactDetails, id: "contactDetails", cssClass: "quickFade delayFour")
        
        let clearDiv = HtmlTagGenerator.div("", cssClass:"clear")
        
        let mainDetails = headShotDiv + nameDiv + contactDetailsDiv + clearDiv
        let mainDetailsDiv = HtmlTagGenerator.div(mainDetails, cssClass: "mainDetails")
        
        
 
        // MARK: --- Main Area
        
        
        // MARK: --- --- Section Personal Profile
        var sectionPersonalProfile = ""
        if let profile = cv.profile {
            let sectionTitle1 = HtmlTagGenerator.h(1, content: "Personal Profile")
            let sectionTitleDiv1 = HtmlTagGenerator.div(sectionTitle1, cssClass: "sectionTitle")
            var sectionContent1 = profile
                sectionContent1 = formatParagraphText(sectionContent1)
            let sectionContentDiv1 = HtmlTagGenerator.div(sectionContent1, cssClass: "sectionContent")
            let profileArticleContent = sectionTitleDiv1 + sectionContentDiv1
            let profileArticle = HtmlTagGenerator.article(profileArticleContent)
            let section1Content = profileArticle + clearDiv
                sectionPersonalProfile = HtmlTagGenerator.section(section1Content)
        }
        

        // MARK: --- --- Section Profssional Experience
        let sectionTitle2 = HtmlTagGenerator.h(1, content: "Professional Experience")
        let sectionTitleDiv2 = HtmlTagGenerator.div(sectionTitle2, cssClass: "sectionTitle")
        
        var sectionContent2 = ""
        for i in 0 ..< (cv.jobs?.count ?? 0) {
            var jobArticle = HtmlTagGenerator.h(2, content: cv.jobs[i].employer) +
                             HtmlTagGenerator.p("\(cv.jobs[i].since) - \(cv.jobs[i].to)", cssClass: "subDetails")
            let duties = cv.jobs[i].duties
            if let specs = cv.jobs[i].specifications where specs.count > 0 {
                jobArticle += "\(duties != nil ? HtmlTagGenerator.h(3, content: duties!) + "\n" : "")" +
                              HtmlTagGenerator.ul(specs, cssClass: "jobSpecifics")
            } else if duties != nil {
                jobArticle += HtmlTagGenerator.p(duties!)
            } else {
                jobArticle += HtmlTagGenerator.p("")
            }
            sectionContent2 += jobArticle
        }
        let sectionContentDiv2 = HtmlTagGenerator.div(sectionContent2, cssClass: "sectionContent")
        
        let section2Content = sectionTitleDiv2 + sectionContentDiv2 + clearDiv
        let sectionProfessionalExperience  = HtmlTagGenerator.section(section2Content)
        

        // MARK: --- --- Section Key Skills
        let sectionTitle3 = HtmlTagGenerator.h(1, content: "Key Skills")
        let sectionTitleDiv3 = HtmlTagGenerator.div(sectionTitle3, cssClass: "sectionTitle")
        
        var sectionContent3 = ""
        
        let skills = cv.skills?.sort { (aSkillsSet, anotherSkillsSet) -> Bool in
                                        aSkillsSet.hasHigherLevelThan(anotherSkillsSet) }
        
        var firstSkillsSet = ""
        var secondSkillsSet = ""
        var thirdSkillsSet = ""
        var fourthSkillsSet = ""
//        if let template = withTemplate {
            switch template {
            case Templates.william:
                firstSkillsSet = HtmlTagGenerator.h(2, content: skills?[0].level.description ?? "") +
                                 HtmlTagGenerator.p(skills?[0].description ?? "")
                secondSkillsSet = HtmlTagGenerator.h(2, content: skills?[1].level.description ?? "") +
                                  HtmlTagGenerator.p(skills?[1].description ?? "")
                thirdSkillsSet = HtmlTagGenerator.h(2, content: skills?[2].level.description ?? "") +
                                 HtmlTagGenerator.p(skills?[2].description ?? "")
                fourthSkillsSet = HtmlTagGenerator.h(2, content: skills?[3].level.description ?? "") +
                                  HtmlTagGenerator.p(skills?[3].description ?? "")
                
                sectionContent3 = firstSkillsSet + secondSkillsSet + thirdSkillsSet
            case Templates.omero:
                // This is the default template's configuration of the Key Skills Section
                fallthrough
            default:
                // If the template passed doesn't really exist, then use the default template's configuration
                if skills?.count > 0 {
                    firstSkillsSet = HtmlTagGenerator.h(2, content: skills?[0].level.description ?? "") +
                    "\(skills?[0].skills != nil ? HtmlTagGenerator.ul((skills?[0].skills)!, cssClass: "keySkills") : "" )"
                }
                if skills?.count > 1 {
                    secondSkillsSet = HtmlTagGenerator.h(2, content: skills?[1].level.description ?? "") +
                    "\(skills?[1].skills != nil ? HtmlTagGenerator.ul((skills?[1].skills)!, cssClass: "keySkills") : "" )"
                }
                if skills?.count > 2 {
                    thirdSkillsSet = HtmlTagGenerator.h(2, content: skills?[2].level.description ?? "") +
                    "\(skills?[2].skills != nil ? HtmlTagGenerator.ul((skills?[2].skills)!, cssClass: "keySkills") : "" )"
                }
                if skills?.count > 3 {
                    fourthSkillsSet = HtmlTagGenerator.h(2, content: skills?[3].level.description ?? "") +
                    "\(skills?[3].skills != nil ? HtmlTagGenerator.ul((skills?[3].skills)!, cssClass: "keySkills") : "" )"
                }
                
                sectionContent3 = firstSkillsSet + secondSkillsSet + thirdSkillsSet + fourthSkillsSet
            }
//        }
        
        let sectionContentDiv3 = HtmlTagGenerator.div(sectionContent3, cssClass: "sectionContent")
        
        let section3Content = sectionTitleDiv3 + sectionContentDiv3 + clearDiv
        let sectionKeySkills  = HtmlTagGenerator.section(section3Content)
        
        
        // MARK: --- --- Section Education
        let highestEducation = cv.education?.last
        let sectionTitle4 = HtmlTagGenerator.h(1, content: "Education")
        let sectionTitleDiv4 = HtmlTagGenerator.div(sectionTitle4, cssClass: "sectionTitle")
        let educationArticleTitle = HtmlTagGenerator.h(2, content: highestEducation != nil ? highestEducation!.istitute : "" )
        let educationArticleSubtitle = HtmlTagGenerator.p(highestEducation != nil ? "\(highestEducation!.degree), YR \(highestEducation!.yearOfGraduation)." : "", cssClass: "subDetails")
        let educationArticleContent = HtmlTagGenerator.p(formatParagraphText((highestEducation?.accademicCurriculum) ?? ""))
        let educationArticle = educationArticleTitle + educationArticleSubtitle + educationArticleContent
        let sectionContent4 = HtmlTagGenerator.article(educationArticle)
        let sectionContentDiv4 = HtmlTagGenerator.div(sectionContent4, cssClass: "sectionContent")
        let section4Content = sectionTitleDiv4 + sectionContentDiv4 + clearDiv
        let sectionEducation  = HtmlTagGenerator.section(section4Content)
        
        
        // Main Area Composition
        var mainAreaContent = ""
        // If any template's name is passed
//        if let template = withTemplate {
            switch template {
            case Templates.william:
                mainAreaContent = sectionProfessionalExperience  + sectionKeySkills + sectionEducation
            case Templates.omero:
                // This is the default template's configuration of the Main Area Content
                fallthrough
            default:
                // If the template passed doesn't really exist, then use the default template's configuration
                mainAreaContent = sectionPersonalProfile + sectionProfessionalExperience  + sectionKeySkills  + sectionEducation
            }
//        }
        let mainAreaDiv = HtmlTagGenerator.div(mainAreaContent, id: "mainArea", cssClass: "quickFade delayFive")
        
        
        // Main Content Composition
        let mainContent = mainDetailsDiv + mainAreaDiv
        let mainDiv = HtmlTagGenerator.div(mainContent, id: "cv", cssClass: "instaFade")
        let body = HtmlTagGenerator.body(mainDiv, id: "top")
        let html = HtmlTagGenerator.html(body)
        htmlCode += html
        
        // MARK: Return the "well formatted" Html Code to display in the Curriculum Web View
        let wellFormated = estractAndReplaceLinkWithHtmlFormat(
            from: htmlCode.stringByReplacingOccurrencesOfString("&",
                withString: "&amp;",
                options: .LiteralSearch),
            startingWithMarker: "::link:: ",
            separatedBy: " :: ",
            terminatedWith: " :;")
        let style = pasteStyleForTemplate(template)
        return injectStyle(style, inHtml:wellFormated)
    }
    
    static func injectStyle(style:String, inHtml:String) -> String {
        return inHtml.stringByReplacingOccurrencesOfString("   -+=*!INJECT_CSS_HERE!*=+-   ", withString: style)
    }
    
    static func estractAndReplaceLinkWithHtmlFormat(from string: String, startingWithMarker: String, separatedBy: String, terminatedWith: String) -> String {
        
        let workingString = NSString(string: string)
        
        let linkHeader = workingString.rangeOfString(startingWithMarker, options: .LiteralSearch)
        let linkHeaderStartIndex = linkHeader.location
        let linkHeaderEndIndex = linkHeaderStartIndex + linkHeader.length
        
        let linkSeparator = workingString.rangeOfString(separatedBy, options: .LiteralSearch)
        let linkSeparatorStartIndex = linkSeparator.location
        let linkSeparatorEndIndex = linkSeparatorStartIndex + linkSeparator.length

        let linkTerminator = workingString.rangeOfString(terminatedWith, options: .LiteralSearch)
        let linkTerminatorStartIndex = linkTerminator.location
        let linkTerminatorEndIndex = linkTerminatorStartIndex + linkTerminator.length
        
        if  linkHeaderStartIndex != NSNotFound &&
            linkSeparatorStartIndex != NSNotFound &&
            linkTerminatorStartIndex != NSNotFound
        {
            
            let linkUrlString = (workingString.substringToIndex(linkSeparatorStartIndex) as NSString).substringFromIndex(linkHeaderEndIndex)
            
            let linkAnchorString = (workingString.substringToIndex(linkTerminatorStartIndex) as NSString).substringFromIndex(linkSeparatorEndIndex)
            
            let a = HtmlTagGenerator.a(linkUrlString, anchorText: linkAnchorString, inLine: true)
            
            let nextString = string.stringByReplacingCharactersInRange(string.startIndex.advancedBy(linkHeaderStartIndex)...string.startIndex.advancedBy(linkTerminatorEndIndex - 1), withString: a)
            
            return estractAndReplaceLinkWithHtmlFormat(from: nextString, startingWithMarker: startingWithMarker, separatedBy: separatedBy, terminatedWith: terminatedWith)
        } else {
            return string
        }
    }
    
    static func formatParagraphText(text: String) -> String {
        var returnText = ""
        let paragraphs = NSString(string: text).componentsSeparatedByString(" \n\n ")
        for p in paragraphs {
            returnText += HtmlTagGenerator.p(p.stringByReplacingOccurrencesOfString("\n", withString: "<br>", options: .LiteralSearch))
        }
        return returnText
    }
    
    
    static func pasteStyleForTemplate(template:String) -> String {
        let mainBundle = NSBundle.mainBundle()
        let filename = mainBundle.pathForResource(template, ofType: "css")
        do {
            let css = try String(contentsOfFile: filename!, encoding: NSUTF8StringEncoding)
            //print(css)
            return css
        } catch let error as NSError {
            print(error.localizedDescription)
            return ""
        }
    }
}



// Mark: Html Tag Generator

private struct HtmlTagGenerator
{
    static let doctype = "<!DOCTYPE html>\n"
    
    static func html (content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<html\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\n\(content)\n</html>\n"
    }
    
    static func body (content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<body\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\n\(content)\n</body>\n"
    }
    
    static func head (content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<head\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\n\(content)\n</head>\n"
    }
    
    static func title (content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<title\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\(content)</title>\n"
    }
    
    static func style (content: String) -> String {
        return "<style>\(content)</style>\n"
    }
    
    static func h (level: Int, content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<h\(level)\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\(content)</h\(level)>\n"
    }
    
    static func a (href: String, anchorText: String, inLine: Bool = false, target: String? = nil, id: String? = nil, cssClass: String? = nil) -> String {
        return "<a href=\"\(href)\"\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")\(target != nil ? " target=\"" + target! + "\"" : "")>\(anchorText)</a>\(inLine ? "" : "\n")"
    }
    
    static func img (src: String, alt: String? = nil, id: String? = nil, cssClass: String? = nil) -> String {
        return "<img\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! : "") src=\"\(src)\"\(alt != nil ? " alt=\"" + alt! + "\"" : "")/>\n"
    }
    
    static func p (content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<p\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\n\(content)\n</p>\n"
    }
    
    static func div (content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<div\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\(content != "" ? "\n" + content + "\n" : "")</div>\n"
    }
    
    static func section (content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<section\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\n\(content)\n</section>\n"
    }
    
    static func article (content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<article\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\n\(content)\n</article>\n"
    }
    
    static func ul (content: String, id: String? = nil, cssClass: String? = nil) -> String {
        return "<ul\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\n\(content)\n</ul>\n"
    }
    
    static func li (content: String, bullets: Bool = false, id: String? = nil, cssClass: String? = nil) -> String {
        return "<li\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\(bullets ? "∙" : "")\(content)</li>\n"
    }

    static func ul (content: [String], bullets: Bool = false, id: String? = nil, cssClass: String? = nil) -> String {
        var returnValue = "<ul\(id != nil ? " id=\"" + id! + "\"" : "")\(cssClass != nil ? " class=\"" + cssClass! + "\"" : "")>\n"
        for li in content {
            returnValue += self.li(li, bullets: bullets)
        }
        returnValue += "</ul>\n"
        return returnValue
    }

}

