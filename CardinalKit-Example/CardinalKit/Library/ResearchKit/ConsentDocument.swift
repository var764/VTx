//
//  ConsentDocument.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//

import ResearchKit

class ConsentDocument: ORKConsentDocument {
    // MARK: Properties
    
    override init() {
        super.init()
        
        let config = CKConfig.shared
        let consentTitle = config.read(query: "Consent Title")
        
        title = NSLocalizedString(consentTitle, comment: "")
        sections = []
        
        let researchPurpose = ORKConsentSection(type: .custom)
        researchPurpose.title = """
            Research Purpose
            """
        researchPurpose.content = "You are invited to participate in a research study of activity in patients who are considering having an operation. We hope to learn how activity changes over time in people who undergo procedures and how changes in activity could predict your speed to recovery. You are eligible for this study if you are older than 18 years old and speak English. Health information provided by you and by reviewing your health records will be used to identify trends between physical fitness, participant demographics and outcomes. Furthermore, certain non-personally identifying information collected and analyzed in this study may be shared with external research partner(s). This research study is looking for 1000 participants."
        
        researchPurpose.summary = "VascTrac is a research study of activity in patients who are considering having an operation. We hope to learn how activity changes over time in people who undergo procedures and how changes in activity could predict your recovery."
        researchPurpose.customImage = UIImage(named: "Research")!
        
        let voluntaryParticipation = ORKConsentSection(type: .custom)
        voluntaryParticipation.title = """
            Voluntary Participation
            """
        voluntaryParticipation.summary = "Your participation in this study is entirely voluntary, and you may choose to not participate or withdraw from this study without loss or negative effects on medical care."
        voluntaryParticipation.content = "Your participation in this study is entirely voluntary.  Your decision not to participate will not have any negative effect on you or your medical care.  You can decide to participate now but withdraw your consent later and stop being in the study without any loss of benefits or medical care you are entitled to."
        
        voluntaryParticipation.customImage = UIImage(named: "Participation")!
        
        let financials = ORKConsentSection(type: .custom)
        financials.title = """
            Financial
            Considerations
            """
        financials.summary = "Participants will receive $100 with completion of the study. There will be no costs to you for testing done as part of this research study."
        financials.content = """
            Payment:
            Participants will be paid $100 with completion of the study.
            Payments may only be made to U.S. citizens, legal resident aliens, and those who have a work eligible visa. You may need to provide your social security number to receive payment.
            Costs:
            There will be no costs to you for any of the testing done as part of this research study. However, medical care and services provided by your health care provider are not part of this study (e.g., normal hospital and prescription expenses which are not part of the research study) may require co-payments.
            You will not have to pay anything to be in this study.
            Support:
            Stanford Department of Surgery Innovation Grant
            """
        financials.customImage = UIImage(named: "Financials")!

        let risks = ORKConsentSection(type: .onlyInDocument)
        risks.title = "Possible Risks, Discomforts, and Inconveniences"
        risks.content = "This study involves the following risks, and possible inconveniences: Your health information related to this study may be used or disclosed in connection with this research study, including, but not limited to name, email, gender, ethnicity, and previous medical and surgical treatments as described in the Confidentiality section below. Although we will take steps to maintain the confidentiality of your Study Data, complete confidentiality cannot be assured. In addition, users will be asked to perform a 6-minute walk test if capable, and users’ smartphones will record physical activity data that will be used to determine the relation between activity and outcomes."
        
        let benefits = ORKConsentSection(type: .onlyInDocument)
        benefits.title = "Potential Benefits"
        benefits.content = " We hope to learn more about the relationship between physical fitness and surgical outcomes and hope to become better at determining how to personalize follow up visit and surveillance in patients post-operatively."
        
        let alternatives = ORKConsentSection(type: .onlyInDocument)
        alternatives.title = "Alternatives"
        alternatives.content = "The alternative to this study is not to participate."
        
        let participantRights = ORKConsentSection(type: .onlyInDocument)
        participantRights.title = "Participants' Rights"
        participantRights.content = "You should not feel obligated to agree to participate.  Your questions should be answered clearly and to your satisfaction. You will be told of any important new information that is learned during the course of this research study, which might affect your condition or your willingness to continue participation in this study."
        
        let clinicalTrials = ORKConsentSection(type: .onlyInDocument)
        clinicalTrials.title = "ClinicalTrials.gov"
        clinicalTrials.content = "A description of this clinical trial will be available on http://www.ClinicalTrials.gov, as required by U.S. Law.  This Web site will not include information that can identify you.  At most, the Web site will include a summary of the results.  You can search this Web site at any time."
        
        let contactInfo = ORKConsentSection(type: .onlyInDocument)
        contactInfo.title = "Contact Information"
        contactInfo.content = """
            Questions, Concerns, or Complaints:  If you have any questions, concerns or complaints about this research study, its procedures, risks and benefits, or alternative courses of treatment, you should ask the principal investigator Dr. Oliver Aalami. (650) 315-3236. 3801 Miranda Avenue (112), Palo Alto, CA 94304-1290. You should also contact him at any time if you feel you have been hurt by being a part of this study.
            
            Independent Contact:  If you are not satisfied with how this study is being conducted, or if you have any concerns, complaints, or general questions about the research or your rights as a participant, please contact the Stanford Institutional Review Board (IRB) to speak to someone independent of the research team at (650) 723-5244 or toll free at 1-866-680-2906.  You can also write to the Stanford IRB, Stanford University, 3000 El Camino Real, Five Palo Alto Square, 4th Floor, Palo Alto, CA 94306.
            """
        
        let expBill = ORKConsentSection(type: .onlyInDocument)
        expBill.title = "Experimental Subject's Bill of Rights"
        expBill.content = """
            As a research participant, you have the following rights.  These rights include but are not limited to the participant's right to:
            be informed of the nature and purpose of the experiment;
            be given an explanation of the procedures to be followed in the medical experiment, and any drug or device to be utilized;
            be given a description of any attendant discomforts and risks reasonably to be expected;
            be given an explanation of any benefits to the subject reasonably to be expected, if applicable;
            be given a disclosure of any appropriate alternatives, drugs or devices that might be advantageous to the subject, their relative risks and benefits;
            be informed of the avenues of medical treatment, if any available to the subject after the experiment if complications should arise;
            be given an opportunity to ask questions concerning the experiment or the procedures involved;
            be instructed that consent to participate in the medical experiment may be withdrawn at any time and the subject may discontinue participation without prejudice;
            be given a copy of the signed and dated consent form; and
            be given the opportunity to decide to consent or not to consent to a medical experiment without the intervention of any element of force, fraud, deceit, duress, coercion or undue influence on the subject's decision.
            """
        
        let sectionTypes: [ORKConsentSectionType] = [
            // see ORKConsentSectionType.description for CKConfiguration.plist keys
            .overview, // "Overview"
            .dataGathering, // "DataGathering"
            .privacy, // "Privacy"
            .dataUse, // "DataUse"
            .timeCommitment, // "TimeCommitment"
            .studySurvey, // "StudySurvey"
            .studyTasks, // "StudyTasks"
            .withdrawing, // "Withdrawing"
        ]
        
        guard let consentForm = config.readAny(query: "Consent Form") as? [String:[String:String]] else {
            return
        }
        
        for type in sectionTypes {
            let section = ORKConsentSection(type: type)
            
            if let consentSection = consentForm[type.description] {
                
                let errorMessage = "We didn't find a consent form for your project. Did you configure the CKConfiguration.plist file already?"
                
                if section == ORKConsentSection(type: .overview) {
                    section.customImage = UIImage(named: "Research")!
                }
            
                section.title = NSLocalizedString(consentSection["Title"] ?? ":(", comment: "")
                section.summary = NSLocalizedString(consentSection["Summary"] ?? errorMessage, comment: "")
                section.content = NSLocalizedString(consentSection["Content"] ?? errorMessage, comment: "")
                
                sections?.append(section)
            }
        }
        
        sections?.remove(at: 0)
        sections?.insert(researchPurpose, at: 0)
        sections?.insert(voluntaryParticipation, at: 1)
        sections?.append(financials)
        sections?.append(risks)
        sections?.append(benefits)
        sections?.append(alternatives)
        sections?.append(participantRights)
        sections?.append(clinicalTrials)
        sections?.append(contactInfo)
        sections?.append(expBill)
        
        
        let signature = ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature")
        signature.title = title
        signaturePageTitle = title
        addSignature(signature)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ORKConsentSectionType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .overview:
            return "Overview"
            
        case .dataGathering:
            return "DataGathering"
            
        case .privacy:
            return "Privacy"
            
        case .dataUse:
            return "DataUse"
            
        case .timeCommitment:
            return "TimeCommitment"
            
        case .studySurvey:
            return "StudySurvey"
            
        case .studyTasks:
            return "StudyTasks"
            
        case .withdrawing:
            return "Withdrawing"
            
        case .custom:
            return "Custom"
            
        case .onlyInDocument:
            return "OnlyInDocument"
        }
    }
}
