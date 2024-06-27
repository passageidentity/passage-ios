import XCTest
@testable import Passage

final class ListDevicesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        let passage = PassageAuth(appId: appInfoValid.id)
        passage.overrideApiUrl(with: apiUrl)
        // NOTE: These tests use static PassageAuth methods instead the passage instance.
        // * The passage instance utilizes keychain for token management, which is not supported in this kind of test environment.
        // * We still have to create this instance to override appId and ApiUrl (this will change in next major version).
    }
    
    func testListDevices() async {
        do {
            let devices = try await PassageAuth.listDevices(token: authToken)
            XCTAssertEqual(devices.count, 1)
            XCTAssertEqual(devices[0].userId, currentUser.id)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func testListDevicesUnAuthed() async {
        do {
            let _ = try await PassageAuth.listDevices(token: "")
            XCTFail("passage.listDevices should throw an unauthorized error when no auth token set")
        } catch let error as UserError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("passage.listDevices should throw an unauthorized error when no auth token set")
        }
    }
    
    @available(iOS 16.0, *)
    func testAddDeviceStart() async {
        do {
            let _ = try await PassageAuth.addDevice(token: authToken)
            XCTFail("passage.addDevice should throw an authorizationFailed error in this test environment")
        } catch let error as AddDeviceError {
            XCTAssertEqual(error, .authorizationFailed)
        } catch {
            XCTFail("passage.addDevice should throw an authorizationFailed error in this test environment")
        }
    }

    @available(iOS 16.0, *)
    func testAddDeviceStartUnAuthed() async {
        do {
            let _ = try await PassageAuth.addDevice(token: "")
            XCTFail("passage.addDevice should throw an unauthorized error")
        } catch let error as AddDeviceError {
            XCTAssertEqual(error, .unauthorized)
        } catch {
            XCTFail("passage.addDevice should throw an unauthorized error")
        }
    }

    func testUpdateDevice() async {
        do {
            let date = Date().timeIntervalSince1970
            let newName = "device \(date)"
            let device = try await PassageAuth.editDevice(
                token: authToken,
                deviceId: existingDeviceId,
                friendlyName: newName
            )
            XCTAssertEqual(device.friendlyName, newName)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }

}
