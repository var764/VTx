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
            Research Description
            """
        
        /*
         
         You are invited to participate in a research study of activity in patients who are considering having an operation. We hope to learn how activity changes over time in people who undergo procedures and how changes in activity could predict your speed to recovery. You are eligible for this study if you are older than 18 years old and speak English. Health information provided by you and by reviewing your health records will be used to identify trends between physical fitness, participant demographics and outcomes. Furthermore, certain non-personally identifying information collected and analyzed in this study may be shared with external research partner(s). This research study is looking for 1000 participants.
         */
        
        researchPurpose.content = """
        You are invited to participate in a research study investigating the use of a smartphone app to monitor activity data and to help observe recovery following surgery when combined with electronic health record data. You will undergo routine standard of care for your diagnosis and present to your surgeon’s office. Based on your surgeon’s determination, you will be scheduled for elective surgery. Following the mutual decision to proceed with surgery, you will be approached during check-in for your scheduled pre-operative outpatient appointment at Stanford or during the same appointment.

        You will be informed about the purpose of the study, the research procedures and asked if you would like to enroll. If you would like to enroll, Informed consent will be obtained through VascTrac X smartphone application. You will download the application, create an account and accept the consent and end user license agreement.

        The smartphone application will then be used to administer two surveys before surgery. The Walking Impairment Questionnaire (WIQ) survey will be used to assess your physical activity. The Risk Analysis Index (RAI) will be used to assess patient pre-operative risk. Activity data (step count, walking and running) of at least 30 days duration prior to surgery will be collected by VascTrac X.

        You will self-report data that enables calculation of a surgical risk score to establish baseline peri-operative clinical risk. The surgical risk score is based upon age, gender, comorbidities (acute and chronic) as well as characteristics of the surgery itself. A digital 6 minute walking test, or how far you are able to walk in 6 minutes, will be used to test your exercise capacity before surgery. The test will be performed by you, unobserved by study stuff. The test may be performed indoors or outdoors. Indoor tests should be performed in long unobstructed hallways and by walking laps. Walk at a comfortable pace and you may slow down, lean on a wall or stop and rest as necessary. Resume walking when able. If you have recently fainted, have worsening shortness of breath or have developed any new medical condition that may prevent walking or be worsened by walking, please contact the study team before performing the test. You will then undergo surgery.

        On post discharge day 1, activity and post-operative outcomes will be monitored and collected via the mobile application and research team follow-up. On post discharge day 30, an additional WIQ and RAI survey will be conducted. The study duration for patients will be 3.5 months. An additional digital 6-minute walking test will be conducted 30 and 60 days after surgery.

        The total time commitment from the patient perspective is two hours. Once total study enrollment is concluded, we will then aggregate all patient data in a de-identified format and run our models and evaluate how well they predict post-operative outcomes. Stanford University is providing financial support and/or material for this study.

        Future Use of Private Information:
        Research using private information is an important way to try to understand human disease.  You are being given this information because the investigators want to save private information for future research.

        Identifiers might be removed from identifiable private information and, after such removal, the information could be used for future research studies or distributed to another investigator for future research studies without additional informed consent from you.
        """
        
        researchPurpose.summary = "VascTrac is a research study of activity in patients who are considering having an operation. We hope to learn how activity changes over time in people who undergo procedures and how changes in activity could predict your recovery."
        researchPurpose.customImage = UIImage(named: "Research")!
        
        let risks = ORKConsentSection(type: .onlyInDocument)
        risks.title = "Risks and Benefits"
        risks.content = "The primary risks associated with this study are breach of privacy and confidentiality and injury during the digital 6-minute walking test. However, due to the self-limited nature of the test, injury risk is minimal. There are no benefits expected to result from this study. We cannot and do not guarantee or promise that you will receive any benefits from this study. However, your participation in this study may help care for future patients with your condition. There are no alternative procedures as such the alternative is not to participate. Your decision whether or not to participate in this study will not affect your medical care."
        
        /*"This study involves the following risks, and possible inconveniences: Your health information related to this study may be used or disclosed in connection with this research study, including, but not limited to name, email, gender, ethnicity, and previous medical and surgical treatments as described in the Confidentiality section below. Although we will take steps to maintain the confidentiality of your Study Data, complete confidentiality cannot be assured. In addition, users will be asked to perform a 6-minute walk test if capable, and users’ smartphones will record physical activity data that will be used to determine the relation between activity and outcomes." */
        
       /* let benefits = ORKConsentSection(type: .onlyInDocument)
        benefits.title = "Potential Benefits"
        benefits.content = " We hope to learn more about the relationship between physical fitness and surgical outcomes and hope to become better at determining how to personalize follow up visit and surveillance in patients post-operatively." */
        
        /*
         TIME COMMITMENT IN CONFIG FILE
         */
        
        let financials = ORKConsentSection(type: .onlyInDocument)
        //"Financial Considerations"
        //" There will be no costs to you for any of the testing done as part of this research study. However, medical care and services provided by your health care provider are not part of this study (e.g., normal hospital and prescription expenses which are not part of the research study) may require co-payments. You will not have to pay anything to be in this study. Support: Stanford Department of Surgery Innovation Grant
        
        financials.title = "Payments"
        //financials.summary = "There will be no costs to you for testing done as part of this research study."
        financials.content = "You will receive no reimbursement for your participation."
        //financials.customImage = UIImage(named: "Financials")!
        
        let participantRights = ORKConsentSection(type: .custom)
        participantRights.title = "Participants' Rights"
        participantRights.content = """
            If you have read this form and have decided to participate in this project, please understand your participation is voluntary and you have the right to withdraw your consent or discontinue participation at any time without penalty or loss of benefits to which you are otherwise entitled.

            The results of this research study may be presented at scientific or professional meetings or published in scientific journals.  However, your identity will not be disclosed. You have the right to refuse to answer particular questions.
        """
        participantRights.summary = "Your participation in this study is entirely voluntary, and you may choose to not participate or withdraw from this study without loss or negative effects on medical care. There will be no costs to you for testing done as part of this research study."
        participantRights.customImage = UIImage(named: "Participation")!
        
        //"You should not feel obligated to agree to participate.  Your questions should be answered clearly and to your satisfaction. You will be told of any important new information that is learned during the course of this research study, which might affect your condition or your willingness to continue participation in this study."
        
        
        let contactInfo = ORKConsentSection(type: .onlyInDocument)
        contactInfo.title = "Contact Information"
        contactInfo.content = """
        Questions, Concerns, or Complaints: If you have any questions, concerns or complaints about this research study, its procedures, risks and benefits, or alternative courses of treatment, you should ask the Protocol Director, Elsie G. Ross. You may contact her now or later at 650-723-5477.
        
        Independent Contact: If you are not satisfied with how this study is being conducted, or if you have any concerns, complaints, or general questions about the research or your rights as a participant, please contact the Stanford Institutional Review Board (IRB) to speak to someone independent of the research team at (650)-723-5244 or toll free at 1-866-680-2906. You can also write to the Stanford IRB, Stanford University, 1705 El Camino Real, Palo Alto, CA 94306.

        If you have any questions, concerns or complaints about this research study, its procedures, risks and benefits, or alternative courses of treatment, you should ask the Protocol Director, Elsie G. Ross, 650-723-5477. You should also contact her at any time if you feel you have been hurt by being a part of this study.
        """
        
        let dataAuth = ORKConsentSection(type: .onlyInDocument)
        dataAuth.title = "Authorization To Use Your Health Information For Research Purposes"
        dataAuth.content = """
        Because information about you and your health is personal and private, it generally cannot be used in this research study without your written authorization.  If you sign this form, it will provide that authorization.  The form is intended to inform you about how your health information will be used or disclosed in the study.  Your information will only be used in accordance with this authorization form and the informed consent form and as required or allowed by law.  Please read it carefully before signing it.

        What is the purpose of this research study and how will my health information be utilized in the study?
        
        The purpose of this study is to develop a model to predict outcomes following vascular, hepato-pancreatico-biliary and colorectal surgery based on peri-operative mobility trends collected via smartphone application and survey data. Your health information will be utilized to construct and validate the statistical model.

        The Walking Impairment Questionnaire (WIQ) survey data will be used to assess your physical activity. The Risk Analysis Index (RAI) data will be used to assess your pre-operative risk. Activity data (step count, walking and running) of at least 30 days duration prior to surgery will be collected by VascTrac X.

        You will self-report data that enables calculation of a surgical risk score to establish baseline peri-operative clinical risk. The surgical risk score is based upon age, gender, comorbidities (acute and chronic) as well as characteristics of the surgery itself. A digital 6 minute walking test, or how far you are able to walk in 6 minutes, will be used to test your exercise capacity before surgery

        Do I have to sign this authorization form?
        
        You do not have to sign this authorization form.  But if you do not, you will not be able to participate in this research study.  Signing the form is not a condition for receiving any medical care outside the study.

        If I sign, can I revoke it or withdraw from the research later?
        
        If you decide to participate, you are free to withdraw your authorization regarding the use and disclosure of your health information (and to discontinue any other participation in the study) at any time.  After any revocation, your health information will no longer be used or disclosed in the study, except to the extent that the law allows us to continue using your information (e.g., necessary to maintain integrity of research).  If you wish to revoke your authorization for the research use or disclosure of your health information in this study, you must write to: Elsie G. Ross, MD Stanford University Medical Center, Department of Surgery, Division of Vascular Surgery, 780 Welch Road, Suite CJ350, MC5639, Palo Alto, CA 94305.

        What Personal Information Will Be Obtained, Used or Disclosed?
        
        Your health information related to this study, may be used or disclosed in connection with this research study, including, but not limited to, patient name, date of birth, date of enrollment, medical record number, demographics (age and gender). In merging collected survey data with their electronic health record data, these EHR data will include lab or test results, diagnosis and procedure codes and medical history.

        Who May Use or Disclose the Information?
        
        The following parties are authorized to use and/or disclose your health information in connection with this research study:
         • The Protocol Director, Elsie G. Ross, MD
         • The Stanford University Administrative Panel on Human Subjects in Medical Research and any other unit of Stanford University as necessary
         • Research Staff

        Who May Receive or Use the Information?
        
        The parties listed in the preceding paragraph may disclose your health information to the following persons and organizations for their use in connection with this research study:
         • The Office for Human Research Protections in the U.S. Department of Health and Human Services

        Your information may be re-disclosed by the recipients described above, if they are not required by law to protect the privacy of the information.

        When will my authorization expire?
        
        Your authorization for the use and/or disclosure of your health information will end on December 31, 2050 or when the research project ends, whichever is earlier.
        """
        
        let timeDoc = ORKConsentSection(type: .onlyInDocument)
        timeDoc.title = "Time Involvement"
        timeDoc.content = "Your participation in this experiment will take approximately 2 hours."
        
        let withdrawDoc = ORKConsentSection(type: .onlyInDocument)
        withdrawDoc.title = "Withdrawal From Study"
        withdrawDoc.content = """
        If you first agree to participate and then change your mind, you are free to withdraw your consent and discontinue your participation at any time.

        If you decide to withdraw your consent to participate in this study, you should notify Elsie G. Ross at 650-723-5477. After your withdrawal from the study is confirmed, you may delete the smartphone application.

        The Protocol Director may also withdraw you from the study without your consent for one of more of the following reasons:
         • Failure to follow the instructions of the Protocol Director and study.
         • The Protocol Director decides that continuing your participation could be harmful to you.
        """
        
            
        /* "Questions, Concerns, or Complaints:  If you have any questions, concerns or complaints about this research study, its procedures, risks and benefits, or alternative courses of treatment, you should ask the principal investigator Dr. Oliver Aalami. (650) 315-3236. 3801 Miranda Avenue (112), Palo Alto, CA 94304-1290. You should also contact him at any time if you feel you have been hurt by being a part of this study. Independent Contact:  If you are not satisfied with how this study is being conducted, or if you have any concerns, complaints, or general questions about the research or your rights as a participant, please contact the Stanford Institutional Review Board (IRB) to speak to someone independent of the research team at (650) 723-5244 or toll free at 1-866-680-2906.  You can also write to the Stanford IRB, Stanford University, 3000 El Camino Real, Five Palo Alto Square, 4th Floor, Palo Alto, CA 94306."
         */
        
        
        /*
         WITHDRAWAL IN CONFIG FILE
         */
        

        
       /* let voluntaryParticipation = ORKConsentSection(type: .custom)
        voluntaryParticipation.title = """
            Voluntary Participation
            """
        voluntaryParticipation.summary = "Your participation in this study is entirely voluntary, and you may choose to not participate or withdraw from this study without loss or negative effects on medical care. There will be no costs to you for testing done as part of this research study."
        voluntaryParticipation.content = "Your participation in this study is entirely voluntary.  Your decision not to participate will not have any negative effect on you or your medical care.  You can decide to participate now but withdraw your consent later and stop being in the study without any loss of benefits or medical care you are entitled to."
        
        voluntaryParticipation.customImage = UIImage(named: "Participation")! */
        
      /*  let alternatives = ORKConsentSection(type: .onlyInDocument)
        alternatives.title = "Alternatives"
        alternatives.content = "The alternative to this study is not to participate." */
        
    /*    let clinicalTrials = ORKConsentSection(type: .onlyInDocument)
        clinicalTrials.title = "ClinicalTrials.gov"
        clinicalTrials.content = "A description of this clinical trial will be available on http://www.ClinicalTrials.gov, as required by U.S. Law.  This Web site will not include information that can identify you.  At most, the Web site will include a summary of the results.  You can search this Web site at any time." */

        
       /* let expBill = ORKConsentSection(type: .onlyInDocument)
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
            """ */
        
        let sectionTypes: [ORKConsentSectionType] = [
            // see ORKConsentSectionType.description for CKConfiguration.plist keys
            .overview, // "Overview"
            .dataGathering, // "DataGathering"
            .privacy, // "Privacy"
            .timeCommitment, // "TimeCommitment"
            .studySurvey, // "StudySurvey"
            .studyTasks, // "StudyTasks"
            .dataUse, // "DataUse"
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
                section.omitFromDocument = true
                
                sections?.append(section)
            }
        }
        
        sections?.remove(at: 0)
        sections?.insert(researchPurpose, at: 0)
        sections?.insert(risks, at: 1)
        sections?.insert(participantRights, at: 2)
        sections?.insert(timeDoc, at: 3)
        sections?.insert(financials, at: 4)
        sections?.insert(contactInfo, at: 5)
        sections?.insert(withdrawDoc, at: 6)
        sections?.insert(dataAuth, at: 7)
        //sections?.insert(voluntaryParticipation, at: 1)
        //sections?.append(financials)
        //sections?.append(risks)
        //sections?.append(benefits)
        //sections?.append(alternatives)
        //sections?.append(participantRights)
        //sections?.append(clinicalTrials)
        //sections?.append(contactInfo)
        //sections?.append(dataAuth)
        //sections?.append(expBill)
        
        
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

