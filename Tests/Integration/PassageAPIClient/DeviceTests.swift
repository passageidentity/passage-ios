//
//  File.swift
//  
//
//  Created by blayne bayer on 2/16/23.
//

import XCTest
@testable import Passage

final class ListDevicesTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        PassageSettings.shared.apiUrl = apiUrl
        PassageSettings.shared.appId = appInfoValid.id
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testListDevices() async {
        // make sure we have an authToken.
        XCTAssertNotEqual(authToken, "")
        
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared.listDevices(token: authToken)
            XCTAssertEqual(response.count, 2)
            XCTAssertEqual(response[0].id, "e05RoyWyVmnseVaqaHaRUoes")
            XCTAssertEqual(response[0].user_id,currentUser.id)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testListDevicesUnAuthed() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared.listDevices(token: "")
            XCTAssertTrue(false)
        } catch {
            
            XCTAssertTrue(error is PassageAPIError)
            
            if let thrownError = error as? PassageAPIError {
                switch thrownError {
                    case .unauthorized(let response):
                        XCTAssertTrue(true)
                default:
                    XCTAssertFalse(true)
                }
            }
        }
    }
    
    @available(iOS 16.0, *)
    func testAddDeviceStart() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared.addDeviceStart(token: authToken)
            // ensure we got a response. Pretty much all we can test for now.
            // If the response changes it should throw a swiftdecode error, which would fail the test
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false)
        }
    }

    @available(iOS 16.0, *)
    func testAddDeviceStartUnAuthed() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let response = try await PassageAPIClient.shared.addDeviceStart(token: "")
            XCTAssertTrue(false)
        } catch {
            
            XCTAssertTrue(error is PassageAPIError)
            
            if let thrownError = error as? PassageAPIError {
                switch thrownError {
                    case .unauthorized(let response):
                        XCTAssertTrue(true)
                default:
                    XCTAssertFalse(true)
                }
            }
        }
    }

    @available(iOS 16.0, *)
    func testUpdateDevice() async {
        do {
            PassageAPIClient.shared.appId = appInfoValid.id
            let listDevicesResponse = try await PassageAPIClient.shared.listDevices(token: authToken)
            let response = try await PassageAPIClient.shared.updateDevice(token: authToken, deviceId: listDevicesResponse[0].id, friendlyName: "integration test device" )
            // ensure we got a response. Pretty much all we can test for now.
            // If the response changes it should throw a swiftdecode error, which would fail the test
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false)
        }
    }

}
