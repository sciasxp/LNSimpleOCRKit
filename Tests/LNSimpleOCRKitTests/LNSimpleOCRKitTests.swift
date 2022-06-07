import XCTest
@testable import LNSimpleOCRKit

final class LNSimpleOCRKitTests: XCTestCase {
    
    func testOCRKitA01() async throws {
        let image = getImage(named: "a01")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "WHEN MY DREAM CHANGED, SOMETHING WITHIN ME CHANGED AS WELL.", "Not specting \(sut)")
    }
    
    func testOCRKitA02() async throws {
        let image = getImage(named: "a02")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "DOUBLE THE DOSE TODAY.", "Not specting \(sut)")
    }
    
    func testOCRKitA03() async throws {
        let image = getImage(named: "a03")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "THAT IS TOO DANGEROUS!", "Not specting \(sut)")
    }
    
    func testOCRKitAgua_Currier_New() async throws {
        let image = getImage(named: "Agua Currier New")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "ÁGUA", "Not specting \(sut)")
    }
    
    func testOCRKitArial() async throws {
        let image = getImage(named: "Arial")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "ABC123", "Not specting \(sut)")
    }
    
    func testOCRKitAvenir_1() async throws {
        let image = getImage(named: "Avenir_1")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "ABC123", "Not specting \(sut)")
    }
    
    func testOCRKitAvenir_2() async throws {
        let image = getImage(named: "Avenir_2")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "ABC123", "Not specting \(sut)")
    }
    
    func testOCRKitCurrier_New() async throws {
        let image = getImage(named: "Currier New")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "ABC123", "Not specting \(sut)")
    }
    
    func testOCRKitHelvetica() async throws {
        let image = getImage(named: "Helvetica")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "ABC123", "Not specting \(sut)")
    }
    
    func testOCRKitTahoma() async throws {
        let image = getImage(named: "Tahoma")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "ABC123", "Not specting \(sut)")
    }
    
    func testOCRKitVerdana() async throws {
        let image = getImage(named: "Verdana")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "ABC123", "Not specting \(sut)")
    }
    
    func testOCRKitTimesNewRoman() async throws {
        let image = getImage(named: "TimesNewRoman")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "ABC123", "Not specting \(sut)")
    }
    
    func testOCRKitTeste_Palavras() async throws {
        let image = getImage(named: "Teste Palavras")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "Água com Açúcar", "Not specting \(sut)")
    }
    
    func testOCRKitTeste_Palavras_2() async throws {
        let image = getImage(named: "Teste Palavras 2")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "Abreu comeu a maçã", "Not specting \(sut)")
    }

    func testOCRKitABC1B34() async throws {
        let image = getImage(named: "ABC1B34")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "BRASIL ABC1B34 BR", "Not specting \(sut)")
    }
    
    func testOCRKitABC2357() async throws {
        let image = getImage(named: "ABC2357")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "SP-TREMEMBE ABC-2357", "Not specting \(sut)")
    }
    
    func testOCRKitAMZ2X19() async throws {
        let image = getImage(named: "AMZ2X19")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "BRASIL AMZ2X19 BR", "Not specting \(sut)")
    }
    
    func testOCRKitBCD3456() async throws {
        let image = getImage(named: "BCD3456")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "PR • SAO JOSE DOS PINHAIS BCD-3456", "Not specting \(sut)")
    }
    
    func testOCRKitBCV6I89() async throws {
        let image = getImage(named: "BCV6I89")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "BCV6I89", "Not specting \(sut)")
    }
    
    func testOCRKitBRA0S17() async throws {
        let image = getImage(named: "BRA0S17")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "BRA0S17", "Not specting \(sut)")
    }
    
    func testOCRKitBRA2E19() async throws {
        let image = getImage(named: "BRA2E19")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "BRASIL BRA2E19 BR", "Not specting \(sut)")
    }
    
    func testOCRKitCDV2172() async throws {
        let image = getImage(named: "CDV2172")!
        let sut = try await getText(for: image)
        
        XCTAssertTrue(sut == "CDV 2172", "Not specting \(sut)")
    }
    
    func getText(for image: UIImage) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            
            let model = LNSimpleOCRKit(
                preprocessor: nil
            )
            
            model.detectText(for: image, postprocessor: postProcess) { result in
                switch result {
                case .success(let text):
                    continuation.resume(with: .success(text))
                    
                case .failure(let error):
                    continuation.resume(with: .failure(error))
                }
            }
        }
    }
    
    func postProcess(text: String) -> String {
        var processed = text
        processed = processed.replacingOccurrences(of: "W/THIN", with: "WITHIN")
        processed = processed.trimmingCharacters(in: .whitespacesAndNewlines)
        return processed
    }
    
    func getImage (named name : String) -> UIImage? {
        if let imgPath = Bundle.module.url(forResource: name, withExtension: "png") {
            return UIImage(contentsOfFile: imgPath.path)
        }
        return nil
    }
}
