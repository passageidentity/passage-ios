//
//  MagicLinkTests.swift
//  
//
//  Created by Kevin Flanagan on 2/16/23.
//
import XCTest
@testable import Passage

final class MagicLinkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = appInfoValid.id
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @available(iOS 15.0, *)
    func testSendRegisterMagicLink() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let date = Date().timeIntervalSince1970
            let identifier = "authentigator" + "+" + String(date) + "@passage.id"
            let response = try await PassageAPIClient.shared.sendRegisterMagicLink(identifier: identifier, path: nil, language: nil)
            print(response)
            do {
                _ = try await PassageAPIClient.shared.magicLinkStatus(id: response.id)
                XCTAssertTrue(false) // the status should error as it is unactivated
            } catch {
                XCTAssertTrue(true)
            }
            
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testSendLoginMagicLink() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared.sendLoginMagicLink(identifier: registeredUser.email!, path: nil, language: nil)
            do {
                _ = try await PassageAPIClient.shared.magicLinkStatus(id: response.id)
                XCTAssertTrue(false) // the status should error as it is unactivated
            } catch {
                XCTAssertTrue(true)
            }
            
        } catch {
            print(error)
            XCTAssertTrue(false)
        }
    }
}

