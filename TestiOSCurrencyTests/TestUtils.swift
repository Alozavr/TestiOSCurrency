//
//  TestUtils.swift
//  TestiOSCurrencyTests
//
//  Created by Dmitry Grebenschikov on 13/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import XCTest

extension XCTestCase {
    func assertMethodWasCalled(_ methodFlag: Bool) {
        XCTAssertTrue(methodFlag, "Expected method was not called")
    }
    
    func assertMethodWasNotCalled(_ methodFlag: Bool) {
        XCTAssertFalse(methodFlag, "Expected method was not called")
    }
    
    func eventually(timeout: TimeInterval = 0.01, closure: @escaping () -> Void) {
        let expectation = self.expectation(description: "")
        expectation.fulfillAfter(timeout)
        self.waitForExpectations(timeout: 60) { _ in
            closure()
        }
    }
}
extension XCTestExpectation {
    
    func fulfillAfter(_ time: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            self.fulfill()
        }
    }
}
