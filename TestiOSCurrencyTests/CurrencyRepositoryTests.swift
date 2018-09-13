//
//  CurrencyRepositoryTests.swift
//  TestiOSCurrencyTests
//
//  Created by Dmitry Grebenschikov on 13/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import XCTest
import RxSwift
@testable import TestiOSCurrency

class CurrencyRepositoryTests: XCTestCase {
    
    var mockQuery = MockQuery()
    var disposeBag = DisposeBag()
    var repo: CurrencyRatesRepository!
    
    override func setUp() {
        repo = CurrencyRatesRepository(ratesQuery: mockQuery)
    }
    
    func testRepo_OnGetRates_RunsQueryAfterTimeout() {
        
        repo.getCurrencies()
            .subscribe()
            .disposed(by: disposeBag)
        
        eventually(timeout: 0.5, closure: {
            self.assertMethodWasNotCalled(self.mockQuery.runCalled)
        })
        eventually(timeout: 1.5, closure: {
            self.assertMethodWasCalled(self.mockQuery.runCalled)
        })
    }
    
    func testRepo_OnError_IsReusableAndNotSendingEvents() {
        mockQuery.observableToReturn = Observable.error(AppErrors.parseError)
        
        repo.getCurrencies()
            .subscribe(
                onNext: { _ in
                    XCTFail("There should not be any elements")
            })
            .disposed(by: disposeBag)
        
        eventually(timeout: 2.5, closure: {
            XCTAssertEqual(self.mockQuery.timesCalled, 2, "Run query only \(self.mockQuery.timesCalled) time(s)")
        })
    }
    
    func testRepoObservable_IsShared() {
        repo.getCurrencies()
            .subscribe()
            .disposed(by: disposeBag)
        
        repo.getCurrencies()
            .subscribe()
            .disposed(by: disposeBag)
        
        eventually(timeout: 1.5, closure: {
            XCTAssertEqual(self.mockQuery.timesCalled, 1, "Run query \(self.mockQuery.timesCalled) time(s)")
        })
    }
    
    class MockQuery: RatesQueryProtocol {
        var observableToReturn: Observable<[CurrencyEntity]> = Observable.never()
        var runCalled = false
        var timesCalled = 0
        
        func run(baseName: String) -> Observable<[CurrencyEntity]> {
            self.runCalled = true
            timesCalled += 1
            return self.observableToReturn
        }
    }
    
}
