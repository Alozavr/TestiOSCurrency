//
//  CurrencyViewModelProtocol.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 13/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
import RxSwift

protocol CurrencyViewModelProtocol {
    var sectionsArray: Variable<[TableSection]> { get }
    var selectedCurrencyName: Variable<(String, String)> { get }
    func isValid(amount: String) -> Bool
}
