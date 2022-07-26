/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
@testable import SecureStore

class SecureStoreTests: XCTestCase {
  var secureStoreWithGenericPwd: SecureStore!
  var secureStoreWithInternetPwd: SecureStore!

  override func setUp() {
    super.setUp()
    
    let genericPwdQueryable =
      GenericPasswordQueryable(service: "someService")
    secureStoreWithGenericPwd =
      SecureStore(secureStoreQueryable: genericPwdQueryable)
    
    let internetPwdQueryable =
      InternetPasswordQueryable(server: "someServer",
                                port: 8080,
                                path: "somePath",
                                securityDomain: "someDomain",
                                internetProtocol: .https,
                                internetAuthenticationType: .httpBasic)
    secureStoreWithInternetPwd =
      SecureStore(secureStoreQueryable: internetPwdQueryable)
  }
  
  override func tearDown() {
    try? secureStoreWithGenericPwd.removeAllValues()
    try? secureStoreWithInternetPwd.removeAllValues()
    
    super.tearDown()
  }

  // testSaveGenericPassword() methods verifies whether it can save a password correctly.
  func testSaveGenericPassword() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
    } catch (let e) {
      XCTFail("Saving generic password failed with \(e.localizedDescription).")
    }
  }

  // testReadGenericPassword() first saves the password then retrieves the password, checking if it’s equal to the expected one.
  func testReadGenericPassword() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
      let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
      XCTAssertEqual("pwd_1234", password)
    } catch (let e) {
      XCTFail("Reading generic password failed with \(e.localizedDescription).")
    }
  }

  // testUpdateGenericPassword() verifies when saving a different password for the same account, the latest password is the one expected after its retrieval.
  func testUpdateGenericPassword() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
      try secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword")
      let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
      XCTAssertEqual("pwd_1235", password)
    } catch (let e) {
      XCTFail("Updating generic password failed with \(e.localizedDescription).")
    }
  }

  // testRemoveGenericPassword() tests that it can remove a password for a specific account.
  func testRemoveGenericPassword() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
      try secureStoreWithGenericPwd.removeValue(for: "genericPassword")
      XCTAssertNil(try secureStoreWithGenericPwd.getValue(for: "genericPassword"))
    } catch (let e) {
      XCTFail("Saving generic password failed with \(e.localizedDescription).")
    }
  }


  // Finally, testRemoveAllGenericPasswords checks that all the passwords related to a specific service are deleted from the Keychain.
  func testRemoveAllGenericPasswords() {
    do {
      try secureStoreWithGenericPwd.setValue("pwd_1234", for: "genericPassword")
      try secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword2")
      try secureStoreWithGenericPwd.removeAllValues()
      XCTAssertNil(try secureStoreWithGenericPwd.getValue(for: "genericPassword"))
      XCTAssertNil(try secureStoreWithGenericPwd.getValue(for: "genericPassword2"))
    } catch (let e) {
      XCTFail("Removing generic passwords failed with \(e.localizedDescription).")
    }
  }

  
  //12 del día filmoteca direccion de sistemas

}
