//
//  RatesQueryProtocol.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import RxSwift

protocol RatesQueryProtocol {
    func run(baseName: String) -> Observable<[CurrencyEntity]>
}
