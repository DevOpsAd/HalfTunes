/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import XCTest
@testable import HalfTunes

class HalfTunesSlowTests: XCTestCase {
  var sessionUnderTest: URLSession!
  
  override func setUp() {
    super.setUp()
    sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
  }
  
  override func tearDown() {
    sessionUnderTest = nil
    super.tearDown()
  }
  
  // Asynchronous test: success fast, failure slow
  func testValidCallToiTunesGetsHTTPStatusCode200() {
    // given
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    // 1
    let promise = expectation(description: "Status code: 200")
    
    // when
    let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
      // then
      if let error = error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if statusCode == 200 {
          // 2
          promise.fulfill()
        } else {
          XCTFail("Status code: \(statusCode)")
        }
      }
    }
    dataTask.resume()
    // 3
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  // Asynchronous test: faster fail
  func testCallToiTunesCompletes() {
    // given
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    // 1
    let promise = expectation(description: "Completion handler invoked")
    var statusCode: Int?
    var responseError: Error?
    
    // when
    let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
      statusCode = (response as? HTTPURLResponse)?.statusCode
      responseError = error
      // 2
      promise.fulfill()
    }
    dataTask.resume()
    // 3
    waitForExpectations(timeout: 5, handler: nil)
    
    // then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
