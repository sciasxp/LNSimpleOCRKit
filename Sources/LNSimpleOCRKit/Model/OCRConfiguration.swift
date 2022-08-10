//
//  OCRConfiguration.swift
//  MangaSpeech
//
//  Created by Luciano Nunes on 04/05/22.
//  Copyright © 2022 Bar do Nunes. All rights reserved.
//

import Foundation
import Vision

public struct OCRConfiguration {
    
    public enum OCRDetectionType {
        case fast
        case accurate
        
        public var regocgnitionLevel: VNRequestTextRecognitionLevel {
            let level: VNRequestTextRecognitionLevel
            
            switch self {
            case .fast:
                level = .fast
            case .accurate:
                level = .accurate
            }
            
            return level
        }
    }
    
    public enum OCRAutomaticRevision {
        case revision2
        case revision3
    }
    
    public enum OCRDetectionLanguage {
        case portuguese
        case spanish
        case english
        case automatic(revision: OCRAutomaticRevision)
        
        var recognitionLanguages: [String] {
            let languages: [String]
            
            switch self {
            case .english:
                languages = ["en_US"]
            case .portuguese:
                languages = ["pt_BR"]
            case .spanish:
                languages = ["es"]
            default:
                languages = []
            }
            
            return languages
        }
        
        var revision: Int {
            let revisionCode: Int
            
            switch self {
            case .english:
                revisionCode = VNRecognizeTextRequestRevision1
                
            case .portuguese, .spanish:
                if #available(iOS 16.0, *) {
                    revisionCode = VNRecognizeTextRequestRevision3
                } else if #available(iOS 14.0, *) {
                    revisionCode = VNRecognizeTextRequestRevision2
                } else {
                    revisionCode = VNRecognizeTextRequestRevision1
                }
                
            case .automatic(let revision):
                switch revision {
                case .revision2:
                    if #available(iOS 14.0, *) {
                        revisionCode = VNRecognizeTextRequestRevision2
                    } else {
                        revisionCode = VNRecognizeTextRequestRevision1
                    }
                    
                case .revision3:
                    if #available(iOS 16.0, *) {
                        revisionCode = VNRecognizeTextRequestRevision3
                    } else if #available(iOS 14.0, *) {
                        revisionCode = VNRecognizeTextRequestRevision2
                    } else {
                        revisionCode = VNRecognizeTextRequestRevision1
                    }
                }
            }
            
            return revisionCode
        }
    }
    
    let language: OCRDetectionLanguage
    let type: OCRDetectionType
    let languageCorrection: Bool
    
    public static func `default`() -> OCRConfiguration {
        return OCRConfiguration (
            language: .automatic(revision: .revision2),
            type: .accurate,
            languageCorrection: false
        )
    }
}
