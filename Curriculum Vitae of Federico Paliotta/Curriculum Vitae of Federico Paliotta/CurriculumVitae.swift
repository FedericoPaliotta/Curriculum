//
//  CurriculumVitae.swift
//  Curriculum
//
//  Created by Federico Paliotta on 27/10/15.
//  Copyright © 2015 Federico Paliotta. All rights reserved.
//

import Foundation
import Contacts


class CurriculumVitae : NSObject, NSCoding
{
    
    var me: CNContact!
    var title: String!
    var profile: String?
    var jobs: [Job]!
    var education: [Education]!
    var skills: [SkillsSet]!

    
    required override init() {
        // MARK: About Me
        
        // Name
        let contact = CNMutableContact()
            contact.givenName  = "Federico"
            contact.familyName = "Paliotta"
        
        // Addresses
        let mainAddress = CNMutablePostalAddress()
            mainAddress.street = "976 E. 61st Street, Apt. 9H"
            mainAddress.city = "Tulsa"
            mainAddress.state = "Oklahoma"
            mainAddress.postalCode = "74136"
            mainAddress.country = "United States"
        
        let otherAddress = CNMutablePostalAddress()
            otherAddress.street = "Via Giuseppe Verdi 97c"
            otherAddress.city = "Albano Laziale"
            otherAddress.state = "RM"
            otherAddress.postalCode = "00041"
            otherAddress.country = "Italy"
        
        contact.postalAddresses = [CNLabeledValue(label: CNLabelHome,  value: mainAddress),
                                   CNLabeledValue(label: CNLabelOther, value: otherAddress)]
        
        // Telephones
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain,
                                               value: CNPhoneNumber(stringValue: "+1 (918) 998 2674")),
                                CNLabeledValue(label: CNLabelOther,
                                               value: CNPhoneNumber(stringValue: "+39 (349) 4757 977"))]
        
        // Emails
        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: "federico.paliotta@gmail.com")]
        
        let dateOfBirth = NSDateComponents()
            dateOfBirth.day = 11
            dateOfBirth.month = 12
            dateOfBirth.year = 1986
        
        contact.birthday = dateOfBirth
        
        me = contact
        
        // MARK: Title
        title = "iOS Developer"
        
       
        // MARK: Jobs
        jobs = [
            Job(employer: "Freelance iOS Developer and Solution Consultant",
                title: "",
                since: "January 2013",
                to: "Present",
                duties: "Mainly iOS Developement",
                specifications: ["Available on the major freelancers networks. ::link:: https://www.upwork.com :: Upwork :;, ::link:: http://www.freelance.com/ :: Freelance :;, ::link:: https://www.craigslist.org :: Craigslist :;"]),
            Job(employer: "Hot Coffey Design llc",
                title: "Software Developer",
                since: "March 2015",
                to: "October 2015",
                duties: "iOS, Web, and Crossplatform Desktop Developement",
                specifications: ["::link:: http://www.hotcoffeydesign.com/ :: H.C.D. :; is one of the most successful web and mobile design and development companies in the United States",
                    "Endlessly elarged my knowledge of multiple aspects of developing by working with and learnig from top developers and designers, on many challenging projects",
                    "Had a vast and precious experience on working closely with the clients, in an agile process of collecting the inputs and delivering a fine product"]),
            Job(employer: "Icona Management srl",
                title: "Software Developer",
                since: "February 2009",
                to: "August 2010",
                duties: "CMS (Alfresco) and Desktop Developement",
                specifications: ["::link:: http://www.iconamanagement.com/ :: Icona :; provides enterprice buisness solutions and outsourcing services of IT support and systems management to many important ::link:: http://www.iconamanagement.com/index-2.html :: clients :; like ::link:: http://www.freshfields.com/en/italy/ :: Freshfields Bruckhaus Deringer :;, or ::link:: http://www.regione.lazio.it/ :: Regione Lazio :;",
                    "Started working in a helpdesk service delivered to a client and quickly switched into the development branch of the company",
                    "Took part in developing several projects in C#, Java, MySql and maintained different websites",
                    "Led a project of customizing an Open Source Content Management System, Alfresco, for one of the biggest company's clients"])]
        
     
        // MARK: Education
        // In chronological order: education.last returns the most recent
        education = [
            Education(
                istitute: "Scientific Liceum \"Alberto Romita\" Campobasso, Italy",
                degree: "Highschool Diploma",
                yearOfGraduation: 2005,
                accademicCurriculum: nil,
                thesis: nil,
                advisor: nil),
            Education(
                istitute: "\"La Sapienza\", First University of Rome",
                degree: "Bachelor of Science in Computer Systems & Information Technology Engineering",
                yearOfGraduation: 2013,
                accademicCurriculum: "As an engineer, I'm ready to embrace any challenge to solve complex computational problems and find the appropriate system architecture to cope with tecnology’s boundaries. Thanks to the preparation required to achieve the above degree, not only did I grasp a lot of knowledge of both basic sciences (such as math, physics, etc.) and state-of-the-art information technologies and patterns, but I also gained that fundamental \"Divide and Conquer\" state of mind, which allows me to confidently face and eventually solve even the most complex problems while the only unknown is, unavoidably, time. \n Moreover, having participated as an activist in the process of organizing groups of people throughout the years, on many occasions I have experienced the true meaning of a collective work environment where my tendencies toward self-motivation and good discipline are crucial.",
                thesis: "Bonsai Due - Growing Assistant for Bonsai Lovers",
                advisor: "Prof. Luigi Laura")]


        // MARK: Skills
        skills = [SkillsSet(level: SkillLevel.WellKnown("Well Known And Most Relevant Programming Languages And Frameworks"),
                           skills: ["Swift","Objective C", "Java", "Javascript", "XML", "HTML", "CSS",
                                   "MySql/SQlite", "C", "Foundation", "UIKit", "MapKit", "AVFoundation", "OpenVC"]),
                  SkillsSet(level: SkillLevel.AlsoKnown("Also Known Programming Languages And Frameworks"),
                           skills: ["Basic","C++", "C#", "Lisp", "JQuiry", "AngularJS"]),
                  SkillsSet(level: SkillLevel.SpokenLanguages("Known Spoken Languages"),
                           skills: ["English", "Italian", "Spanish"]),
                  SkillsSet(level: SkillLevel.Others("Other additional skills"),
                           skills: ["Adobe CS", "Nikon ViewNX", "Light composition and photograpy",
                         "Good basic hardware knowledge", "Good knowledge in general Assembly concepts",
                         "Very good knowledge in general networking, dbms, and security concepts and practices",
                         "Basic knowledge and familiarity with iOS reverse engineering concepts and practices"])]
        
       
        // MARK: Personal Profile
        profile = "In just three words I'd say I'm a dreamer, an intense perfectionist, and a software engineer. Above all, I like to think of software developing as an art, and of myself, as a bit of an artist. My emphasis when developing is on elegance and clarity in implementation, decoupling and code reusability, robust architecture, and extensive testing on both funcionality and perfomance, especially regarding worst case scenarios. \n\n I graduated in \(education.last!.yearOfGraduation) from \(education.last!.istitute). After graduating with a \(education.last!.degree), I decided to leave Italy and start over in the heart of North America, the mid-west United States. \n Since working on my graduation thesis project, in which I embedded calls to C functions from a computer vision framework (OpenCV) into an iOS App through the usage of C/Objective-C custom bridging classes, I've become more interested in iOS development and, as the time goes by, increaingly knowledgeable as well. [::link:: https://www.dropbox.com/sh/bofeirz2kuf90v9/AADZ1MfokqYlIKFbP3KMJOY5a?dl=0 :: Thesis Project in Italian :;] \n\n During my time in North America, I've been employed full time at ::link:: http://hotcoffeydesign.com :: Hot Coffey Design :;, one of the most successful web and mobile design and development companies in the continental US. While working at HCD I’ve largely improved my skills in UI design and the architectural aspects of developing, and gained experience in working closely with the client in order to meet the exact user experience desired."

        super.init()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        me = aDecoder.decodeObjectForKey("me") as? CNContact
        title = aDecoder.decodeObjectForKey("title") as? String
        profile = aDecoder.decodeObjectForKey("profile") as? String
        jobs = aDecoder.decodeObjectForKey("jobs") as? [Job]
        education = aDecoder.decodeObjectForKey("education") as? [Education]
        skills = aDecoder.decodeObjectForKey("skills") as? [SkillsSet]
        super.init()
        if me == nil && title == nil && profile == nil && jobs == nil && education == nil && skills == nil {
            return nil
        }
    }
    
    
    required init(me: CNContact?, title: String?,
                  profile: String?, jobs: [Job]?,
                  education: [Education]?,
                  skills: [SkillsSet]?) {
        self.me = me
        self.title = title
        self.profile = profile
        self.jobs = jobs
        self.education = education
        self.skills = skills
        super.init()
    }
    

    
//    override var description: String {
//        return describe()
//    }
//
//    private func describe() -> String {
//        var description = me.name + "\n"
//        description += "Addresses \n"
//        for (key, value) in me.addresses {
//            description += "\(key)) \(value) \n"
//        }
//        description += "\nTelephones \n"
//        for (key, value) in me.telephones {
//            description += "\(key)) \(value)"
//        }
//        for job in jobs {
//            description += "\(job.description)"
//        }
//        return description
//    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(me, forKey: "me")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(jobs, forKey: "jobs")
        aCoder.encodeObject(education, forKey: "education")
        aCoder.encodeObject(skills, forKey: "skills")
        aCoder.encodeObject(profile, forKey: "profile")
    }
    
    
}


// MARK: The Job type

// A struct that serve to represent a Job in a CurriculumVitae istance.
class Job : NSObject, NSCoding
{
    let employer: String!
    let title: String!
    let since: String!
    let to: String!
    let duties: String?
    let specifications: [String]?
    
    required init(employer: String, title: String, since: String, to: String, duties: String, specifications: [String]) {
        self.employer = employer
        self.title = title
        self.since = since
        self.to = to
        self.duties = duties
        self.specifications = specifications
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        employer = aDecoder.decodeObjectForKey("employer") as! String
        title = aDecoder.decodeObjectForKey("title") as! String
        since = aDecoder.decodeObjectForKey("since") as! String
        to = aDecoder.decodeObjectForKey("to") as! String
        duties = aDecoder.decodeObjectForKey("duties") as! String?
        specifications = aDecoder.decodeObjectForKey("specifications") as! [String]?
        super.init()
        if employer == nil || title == nil || since == nil || to == nil {
            return nil
        }
    }
    
    override var description: String {
        return
            "\(title) at \(employer)\n" +
            "From: \(since)\n" +
            "To: \(to)\n" +
            "Duties: \(duties)"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(employer, forKey: "employer")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(since, forKey: "since")
        aCoder.encodeObject(to, forKey: "to")
        aCoder.encodeObject(duties, forKey: "duties")
        aCoder.encodeObject(specifications, forKey: "specifications")
    }
    
}


// MARK: The Education type

// A struct that serve to represent an Ecucation in a CurriculumVitae istance.
class Education : NSObject, NSCoding
{
    let istitute: String!
    let degree: String!
    let yearOfGraduation: Int!
    let accademicCurriculum: String?
    let thesis: String?
    let advisor: String?
    
    required init(istitute: String, degree: String, yearOfGraduation: Int, let accademicCurriculum: String?, thesis: String?, advisor: String?) {
        self.istitute = istitute
        self.degree = degree
        self.yearOfGraduation = yearOfGraduation
        self.accademicCurriculum = accademicCurriculum
        self.thesis = thesis
        self.advisor = thesis
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        istitute = aDecoder.decodeObjectForKey("istitute") as! String
        degree = aDecoder.decodeObjectForKey("degree") as! String
        yearOfGraduation = aDecoder.decodeObjectForKey("yearOfGraduation") as! Int
        accademicCurriculum = aDecoder.decodeObjectForKey("accademicCurriculum") as! String?
        thesis = aDecoder.decodeObjectForKey("thesis") as! String?
        advisor = aDecoder.decodeObjectForKey("advisor") as! String?
        super.init()
        if istitute == nil || degree == nil || yearOfGraduation == nil {
                return nil
        }
    }
    
    override var description: String {
        return
            "Istitute: \(istitute)\n" +
            "Degree: \(degree)\n" +
            "Year: \(yearOfGraduation)\n" +
            "Accademic Curriculum: \(accademicCurriculum ?? "")\n" +
            "Thesis: \(thesis ?? "")" +
            "Advisor: \(advisor ?? "")"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(istitute, forKey: "istitute")
        aCoder.encodeObject(degree, forKey: "degree")
        aCoder.encodeObject(yearOfGraduation, forKey: "yearOfGraduation")
        aCoder.encodeObject(accademicCurriculum, forKey: "accademicCurriculum")
        aCoder.encodeObject(thesis, forKey: "thesis")
        aCoder.encodeObject(advisor, forKey: "advisor")
    }

}


// MARK: The Skill Set type

class SkillsSet : NSObject, NSCoding
{
    let level: SkillLevel!
    let skills: [String]!
    
    required init(level: SkillLevel, skills: [String]) {
        self.level = level
        self.skills = skills
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let serializedLevel = (aDecoder.decodeObjectForKey("level") as! NSString).componentsSeparatedByString("[^|^]")
        if let l = NSNumberFormatter().numberFromString(serializedLevel.first ?? "") {
            switch l {
            case 0: level = SkillLevel.WellKnown("\(serializedLevel.last ?? "")")
            case 1: level = SkillLevel.AlsoKnown("\(serializedLevel.last ?? "")")
            case 2: level = SkillLevel.SpokenLanguages("\(serializedLevel.last ?? "")")
            case 3: level = SkillLevel.Others("\(serializedLevel.last ?? "")")
            default: level = SkillLevel.Others("")
            }
        }
        else { level = nil }
        skills = aDecoder.decodeObjectForKey("skills") as? [String]
        super.init()
        if level == nil || skills == nil {
                return nil
        }
    }
    
    override var description: String {
        var descr = ""
        for skill in skills {
            descr += skill + ", "
        }
        var characters = descr.characters
        characters.removeLast()
        characters.removeLast()
        return String(characters)
    }
    
    var descriptionWithLevel: (String, String) {
        return (level.description, description)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        let (level, value) = self.level.serializedDescription
        aCoder.encodeObject("\(level)[^|^]\(value)", forKey: "level")
        aCoder.encodeObject(skills, forKey: "skills")
    }
    
    func hasHigherLevelThan(otherSkillsSet: SkillsSet) -> Bool {
        return self.level.isHigherThan(otherSkillsSet.level)
    }
    
    func hasSameLavelThan(otherSkillsSet: SkillsSet) -> Bool {
        return self.level == otherSkillsSet.level
    }

}

// An enumeration that serve to represent a level of knowledge of a certain skill.
enum SkillLevel : CustomStringConvertible, Hashable {
    case WellKnown(String)
    case AlsoKnown(String)
    case SpokenLanguages(String)
    case Others(String)
    
    var description: String {
        switch self {
        case WellKnown(let associatedDescription):
            return associatedDescription
        case AlsoKnown(let associatedDescription):
            return associatedDescription
        case .SpokenLanguages(let associatedDescription):
            return associatedDescription
        case .Others(let associatedDescription):
            return associatedDescription
        }
    }
    
    var serializedDescription: (Int, String) {
        switch self {
        case WellKnown(let associatedDescription):
            return (0, associatedDescription)
        case AlsoKnown(let associatedDescription):
            return (1, associatedDescription)
        case .SpokenLanguages(let associatedDescription):
            return (2, associatedDescription)
        case .Others(let associatedDescription):
            return (3, associatedDescription)
        }
    }
    
    var hashValue: Int {
        switch self {
        case WellKnown(let associatedDescription):
            return associatedDescription.hashValue
        case AlsoKnown(let associatedDescription):
            return associatedDescription.hashValue
        case .SpokenLanguages(let associatedDescription):
            return associatedDescription.hashValue
        case .Others(let associatedDescription):
            return associatedDescription.hashValue

        }
    }
    
    func isHigherThan(otherLevel: SkillLevel) -> Bool {
        var value = 0
        var otherValue = value
        switch self {
        case WellKnown: value = 100
        case AlsoKnown: value = 80
        case SpokenLanguages: value = 50
        case Others: value = 30
        }
        switch otherLevel {
        case WellKnown: otherValue = 100
        case AlsoKnown: otherValue = 80
        case SpokenLanguages: otherValue = 50
        case Others: otherValue = 30
        }
        return value > otherValue
    }
    
    
}

func == (left: SkillsSet, right: SkillsSet) -> Bool {
    let (leftLvel, leftSet) = left.descriptionWithLevel
    let (rightLvel, rightSet) = left.descriptionWithLevel
    return leftLvel == rightLvel && leftSet == rightSet
}

func == (left: SkillLevel, right: SkillLevel) -> Bool {
    return left.description == right.description
}


extension CNContact {
    var fullName: String {
        return givenName + "\(middleName != "" ? " \(middleName) " : " ")" + familyName
    }
}

