//
//  CurrencyViewModel.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
import RxSwift

final class CurrencyViewModel: CurrencyViewModelProtocol {
    
    unowned var view: CurrencyViewProtocol
    var ratesRepo: CurrencyRatesRepositoryProtocol
    var disposeBag = DisposeBag()
    
    let defaultCurrency = "EUR"
    let selectedCurrencyName: Variable<(String, String)>
    let currencies = Variable<[CurrencyEntity]>([])
    let sectionsArray = Variable<[TableSection]>([])
    
    init(view: CurrencyViewProtocol, ratesRepo: CurrencyRatesRepositoryProtocol) {
        self.view = view
        self.ratesRepo = ratesRepo
        selectedCurrencyName = Variable<(String, String)>((defaultCurrency, "1"))
        
        updateCurrencies()
        getSections()
    }
    
    func updateCurrencies() {
        ratesRepo.getCurrencies()
            .do(
                onNext: { (result) in
                    guard !result.isEmpty, let firstCurrency = result.first,
                        self.selectedCurrencyName.value.0 == self.defaultCurrency else { return }
                    self.selectedCurrencyName.value.0 = firstCurrency.name
            })
            .bind(to: currencies)
            .disposed(by: disposeBag)
    }
    
    func isValid(amount: String) -> Bool {
        var validCharacterSet = CharacterSet.decimalDigits
        validCharacterSet.insert(".")
        
        if amount.components(separatedBy: ".").count - 1 > 1 { return false }
        return amount.rangeOfCharacter(from: validCharacterSet.inverted) == nil
    }
    
    func getSections() {
        Observable.combineLatest(
            currencies.asObservable(),
            selectedCurrencyName.asObservable(),
            resultSelector: { ($0, $1) })
            .observeOn(SerialDispatchQueueScheduler(qos: .background, internalSerialQueueName: "Hello"))
            .subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName: "Hello"))
            .map({ (currencies, selectedName) -> [TableSection] in
                guard let selectedCurrency = currencies.first(where: { $0.name == selectedName.0 }) else { return [] }
                let reloadableModels = currencies.map({ currency -> ListObjectModel in
                    let amount = self.getAmount(from: currency,
                                                relativeTo: selectedCurrency,
                                                relativeAmount: Decimal(string: selectedName.1))
                    return self.createUIItemModel(from: currency, value: amount)
                })
                let section = TableSection(items: reloadableModels)
                return [section]
            })
            .bind(to: sectionsArray)
            .disposed(by: disposeBag)
    }
    
    func createUIItemModel(from entity: CurrencyEntity, value: Decimal) -> ListObjectModel {
        let fakeUrl = URL(string: "https://fakeimg.pl/100x100")!
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        let displayableValue = formatter.string(for: value) ?? "--"
        
        return TwoLabeledCellWithIconListModel(imageUrl: fakeUrl,
                                               mainTitle: entity.name,
                                               subTitle: "Enter description here",
                                               value: displayableValue)
    }
    
    func getAmount(from entity: CurrencyEntity, relativeTo: CurrencyEntity, relativeAmount: Decimal?) -> Decimal {
        let relation = (relativeAmount ?? 0) * entity.baseRelation / relativeTo.baseRelation
        return relation
    }
    
}
