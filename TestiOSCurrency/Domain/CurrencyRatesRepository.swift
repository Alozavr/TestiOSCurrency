//
//  CurrencyRatesRepository.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
import RxSwift

final class CurrencyRatesRepository: CurrencyRatesRepositoryProtocol {
    
    let currenciesObservable: Observable<[CurrencyEntity]>
    
    init(ratesQuery: RatesQueryProtocol) {
        currenciesObservable = Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
            .flatMapLatest({ _ -> Observable<[CurrencyEntity]> in
                ratesQuery.run(baseName: "EUR")
                    .catchErrorJustReturn([]) // Please purchase full version for error handling
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .filter({ !$0.isEmpty })
            .share(replay: 1, scope: .whileConnected)
    }
    
    func getCurrencies() -> Observable<[CurrencyEntity]> {
        return currenciesObservable
    }
}
