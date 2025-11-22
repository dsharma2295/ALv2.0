//
//  ContentLoader.swift
//  AL
//
//  Created by Divyanshu Sharma on 11/20/25.
//
import Foundation

class ContentLoader {
    static let shared = ContentLoader()
    
    let scenarios: [Scenario] = [
        // Massachusetts Traffic Scenario
        Scenario(
            id: "ma-traffic",
            title: "Massachusetts Traffic",
            subtitle: "Stops & Checkpoints",
            category: .traffic,
            iconName: "car.fill",
            rights: [
                RightCard(
                    id: "ma-1",
                    title: "Right to Remain Silent",
                    summary: "You only need to provide license & registration.",
                    content: "You have the right to remain silent. You do not have to answer questions about where you are going or where you came from.",
                    legalBasis: "5th Amendment",
                    priority: .critical
                ),
                RightCard(
                    id: "ma-2",
                    title: "Refuse Vehicle Search",
                    summary: "Do not consent to searches.",
                    content: "You can refuse consent to search your vehicle. Clearly state 'I do not consent to searches.' Officers may still search if they claim probable cause.",
                    legalBasis: "4th Amendment",
                    priority: .important
                )
            ],
            quickPhrases: [
                QuickPhrase(
                    id: "qp-ma-1",
                    situation: "Officer asks 'Do you know why I stopped you?'",
                    phrase: "No, officer. Why did you stop me?",
                    explanation: "Admitting knowledge is admitting guilt."
                ),
                QuickPhrase(
                    id: "qp-ma-2",
                    situation: "Officer asks to search your car",
                    phrase: "I do not consent to any searches.",
                    explanation: "Make your objection clear for the record."
                )
            ]
        ),
        
        // US Customs (CBP) Scenario
        Scenario(
            id: "us-customs",
            title: "US Customs (CBP)",
            subtitle: "Airport Entry & Re-entry",
            category: .customs,
            iconName: "airplane.arrival",
            rights: [
                RightCard(
                    id: "cbp-1",
                    title: "Phone Password",
                    summary: "You are NOT required to provide your password.",
                    content: "CBP can inspect your device, but they cannot force you to unlock it or provide your password. They may seize the device if you refuse.",
                    legalBasis: "CBP Directive 3340-049A",
                    priority: .important
                )
            ],
            quickPhrases: []
        )
    ]
}
