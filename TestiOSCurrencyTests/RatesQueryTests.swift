//
//  RatesQueryTests.swift
//  TestiOSCurrencyTests
//
//  Created by Dmitry Grebenschikov on 13/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import XCTest
import RxSwift
@testable import TestiOSCurrency

class RatesQueryTests: XCTestCase {
    
    var mockRequest = MockRequest.success
    var query: RatesQuery!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        query = RatesQuery(request: mockRequest, url: URL(string: "http://test.site")!)
    }
    
    func testQuery_OnRun_DoesNotModifyData() {
        //when
        query.run(baseName: "SomeName")
            .subscribe(
                onNext: { (entities) in
                    //then
                    XCTAssertEqual(entities.count, mockRatesDTO.rates!.count, "Some elements were deleted")
                    let rates = mockRatesDTO.rates!
                    for currency in entities {
                        XCTAssertEqual(rates[currency.name]!.decimalValue, currency.baseRelation, "Relation was changed")
                    }
            },
                onError: { _ in XCTFail("Unexpected error") })
            .disposed(by: disposeBag)
    }
    
    func testQuesry_OnRun_SendsGetRequest() {
        query.run(baseName: "someName")
            .subscribe()
            .disposed(by: disposeBag)
        
        assertMethodWasCalled(mockRequest.getCalled)
    }
    
    func testQuery_PassesCorrectParameters() {
        let expectedName = "testMe"
        
        query.run(baseName: expectedName)
            .subscribe()
            .disposed(by: disposeBag)
        
        XCTAssertNotNil(mockRequest.passedParameters, "There should be parameters, but there are none")
        XCTAssertEqual(mockRequest.passedParameters!["base"] as! String, expectedName, "Wrong parameters passed")
    }
    
    class MockRequest: NetworkClient<RatesDTO> {
        var getCalled = false
        var shouldReturnError = false
        var entitiesToReturn = false
        var passedParameters: [String : Any]?
        
        convenience init(shouldReturnError: Bool = false) {
            self.init()
            self.shouldReturnError = shouldReturnError
        }
        
        override func get(from url: URL, headers: [String : String]?, parameters: [String : Any]?) -> Observable<RatesDTO> {
            getCalled = true
            passedParameters = parameters
            return shouldReturnError ? Observable.error(AppErrors.parseError) : Observable.just(mockRatesDTO)
        }
        
        static var success: MockRequest { return MockRequest() }
        static var error: MockRequest { return MockRequest(shouldReturnError: true) }
    }
    
}
