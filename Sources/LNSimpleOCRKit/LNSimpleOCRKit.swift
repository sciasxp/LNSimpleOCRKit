import UIKit
import Vision

public class LNSimpleOCRKit {
    
    // MARK: - Errors
    
    public enum OCRError: Error {
        case preprocessorError
        case mergeTextError
        case postprocessorError
        case visionError
    }
    
    // MARK: - Type Alias
    
    public typealias TextDetectionResult = (Result<String, OCRError>) -> Void
    public typealias TextObservationsResult = (Result<[VNRecognizedTextObservation], OCRError>) -> Void
    public typealias TextDetectionProgress = (Double) -> Void
    public typealias PreProcessOCRImage = (UIImage) -> UIImage
    public typealias PostProcessOCRText = (String) -> String
    
    // MARK: - Properties
    
    private var preprocessor: PreProcessOCRImage?
    private let configuration: OCRConfiguration
    
    // MARK: - Initializer
    
    public init(preprocessor: PreProcessOCRImage? = nil,
                configuration: OCRConfiguration = OCRConfiguration.default()) {
        
        self.preprocessor = preprocessor
        self.configuration = configuration
    }
    
    public init() {
        self.configuration = OCRConfiguration.default()
    }
    
    // MARK: - Public API
    
    public func recognizedObservations(for image: UIImage,
                                       detectionProgress: TextDetectionProgress? = nil,
                                       result: @escaping TextObservationsResult) {
        
        guard let cgImage = try? getPreprocessedImage(image) else {
            result(.failure(OCRError.preprocessorError))
            return
        }
        
        self.getObservations(from: cgImage, detectionProgress: detectionProgress) { detectionResult in
            switch detectionResult {
            case .success(let observations):
                result(.success(observations))
                
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    public func detectText(for image: UIImage,
                           detectionProgress: TextDetectionProgress? = nil,
                           postprocessor: PostProcessOCRText? = nil,
                           result: @escaping TextDetectionResult) {
        
        guard let cgImage = try? getPreprocessedImage(image) else {
            result(.failure(OCRError.preprocessorError))
            return
        }
        
        self.getObservations(from: cgImage, detectionProgress: detectionProgress) { [weak self] detectionResult in
            switch detectionResult {
            case .success(let observations):
                guard let text = self?.mergedText(for: observations) else {
                    result(.failure(OCRError.mergeTextError))
                    return
                }
                
                guard let processText = postprocessor else {
                    //result(.failure(OCRError.postprocessorError))
                    result(.success(text))
                    return
                }
                
                let processedText = processText(text)
                result(.success(processedText))
                
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    private func mergedText(for observations: [VNRecognizedTextObservation]) -> String {
        let text = observations.reduce("") { partialResult, observation in
            guard let textObserved = observation.topCandidates(1).first else { return partialResult }
            if partialResult.last == "-" {
                var string = "\(partialResult)"
                string.remove(at: partialResult.index(before: partialResult.endIndex))
                return string + textObserved.string
            } else {
                return partialResult + " " + textObserved.string
            }
        }
        return text
    }
    
    // MARK: - Helper Methods
    
    private func getPreprocessedImage(_ image: UIImage) throws -> CGImage {
        guard let preprocessor = self.preprocessor else {
            guard let cgImage = image.cgImage else {
                throw OCRError.preprocessorError
            }
            return cgImage
        }

        guard let processedImage: CGImage = preprocessor(image).cgImage else {
            throw OCRError.preprocessorError
        }
        
        return processedImage
    }
    
    private func getObservations(from cgImage: CGImage,
                         detectionProgress: TextDetectionProgress?,
                         result: @escaping TextObservationsResult) {
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil else {
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                result(.success([]))
                return
            }
            
            result(.success(observations))
        }
        
        if cgImage.height > 200 {
            request.minimumTextHeight = 1/30
        } else {
            request.minimumTextHeight = 1/20
        }
        request.usesLanguageCorrection = configuration.languageCorrection
        request.usesCPUOnly = false
        request.preferBackgroundProcessing = false
        
        request.recognitionLevel = configuration.type.regocgnitionLevel
        if configuration.language != .automatic {
            request.recognitionLanguages = configuration.language.recognitionLanguages
        }
        request.revision = configuration.language.revision
            
        request.progressHandler = { request, progress, error in
            detectionProgress?(progress)
        }
        
        do {
            try handler.perform([request])
        } catch {
            result(.failure(OCRError.visionError))
        }
    }
}
