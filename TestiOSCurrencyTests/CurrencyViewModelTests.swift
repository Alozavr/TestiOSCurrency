//
//  CurrencyViewModelTests.swift
//  TestiOSCurrencyTests
//
//  Created by Dmitry Grebenschikov on 13/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import XCTest
import RxSwift
@testable import TestiOSCurrency

class CurrencyViewModelTests: XCTestCase {
    
    let mockView = MockView()
    let mockRepo = MockRepo()
    var viewModel: CurrencyViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CurrencyViewModel(view: mockView, ratesRepo: mockRepo)
    }
    
    func testVM_AfterInit_SuscribedOnRepo() {
        assertMethodWasCalled(mockRepo.getRatesCalled)
        XCTAssertEqual(viewModel.selectedCurrencyName.value.0, viewModel.defaultCurrency, "Wrong initial value")
        XCTAssertEqual(viewModel.selectedCurrencyName.value.1, "1", "Wrong initial value")
    }
    
    func testUpdateCurrencies_OnEmptyResult_DoesNotUpdateSelectedItem() {
        mockRepo.observableToReturn = Observable.just([])
        
        viewModel.updateCurrencies()
        
        XCTAssertEqual(viewModel.selectedCurrencyName.value.0, viewModel.defaultCurrency, "Wrong initial value")
        XCTAssertTrue(viewModel.currencies.value.isEmpty, "Updated currencies with something")
    }
    
    func testUpdateCurrencies_OnNotInitialValue_DoesNotUpdateSelectedItem() {
        viewModel.selectedCurrencyName.value = ("USD", "321")
        mockRepo.observableToReturn = Observable.just(mockCurrencies)
        
        viewModel.updateCurrencies()
        
        XCTAssertEqual(viewModel.selectedCurrencyName.value.0, "USD", "Wrong initial value")
    }
    
    func testUpdateCurrencies_OnInitialValue_UpdatesSelectedItem() {
        mockRepo.observableToReturn = Observable.just(mockCurrencies)
        
        viewModel.updateCurrencies()
        
        XCTAssertEqual(viewModel.selectedCurrencyName.value.0, mockCurrencies.first!.name, "Wrong initial value")
        XCTAssertFalse(viewModel.currencies.value.isEmpty, "Did not update currencies")
    }
    
    func testGetCurrencies_UpdatesCorrectSubjectWithCorrectData() {
        viewModel.currencies.value = mockCurrencies
        viewModel.selectedCurrencyName.value = (mockCurrencies.last!.name, "321")

        viewModel.getSections()
        
        eventually {
            XCTAssertEqual(self.viewModel.sectionsArray.value.count, 1, "Wrong amount of sections")
            XCTAssertEqual(mockCurrencies.count, self.viewModel.sectionsArray.value.first!.items.count, "Wrong amount of ui items")
        }
    }
    
    func testCreateUIItem_MapsEntityCorrectly() {
        let uiItems = mockCurrencies
            .compactMap({ viewModel.createUIItemModel(from: $0, value: $0.baseRelation) as? TwoLabeledCellWithIconListModel})
        
        XCTAssertEqual(uiItems.count, mockCurrencies.count, "Skipped some entities")
        for model in uiItems {
            XCTAssertEqual(model.value, mappingExamples[model.mainTitle], "Wrong mapped value")
        }
    }

    class MockView: CurrencyViewProtocol {
        
    }
    
    class MockRepo: CurrencyRatesRepositoryProtocol {
        var observableToReturn: Observable<[CurrencyEntity]> = Observable.never()
        var getRatesCalled = false
        
        func getCurrencies() -> Observable<[CurrencyEntity]> {
            getRatesCalled = true
            return observableToReturn
        }
    }
}
