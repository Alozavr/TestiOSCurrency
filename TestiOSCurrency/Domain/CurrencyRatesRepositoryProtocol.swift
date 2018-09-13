//
//  CurrencyRatesRepositoryProtocol.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
import RxSwift

protocol CurrencyRatesRepositoryProtocol {
    func getCurrencies() -> Observable<[CurrencyEntity]>
}
