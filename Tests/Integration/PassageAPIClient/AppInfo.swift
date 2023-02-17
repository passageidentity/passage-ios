//
//  testss.swift
//  
//
//  Created by blayne bayer on 2/14/23.
//

import XCTest
@testable import Passage

final class AppInfoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = appInfoValid.id
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
//    func testAppInfoFound() async {
//        do {
//            PassageAPIClient.shared.appId = appInfoValid.id
//            let response = try await PassageAPIClient.shared.appInfo()
//            XCTAssertEqual(response, appInfoValid)
//            
//        } catch {
//            XCTAssertTrue(false)
//        }
//    }

    func testAppInfoNotFound() async {
        do {
            PassageAPIClient.shared.appId = appInfoInvalid.id
            let response = try await PassageAPIClient.shared.appInfo();
            XCTAssertFalse(true)
        }
        catch  {
            XCTAssertTrue(error is PassageAPIError)
            
            if let thrownError = error as? PassageAPIError {
                switch thrownError {
                    case .notFound(let response):
                        XCTAssertTrue(true)
                default:
                    XCTAssertFalse(true)
                }
            }
        }
        
    }
    

}
