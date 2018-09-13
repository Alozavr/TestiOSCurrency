//
//  SharedMocks.swift
//  TestiOSCurrencyTests
//
//  Created by Dmitry Grebenschikov on 13/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation
@testable import TestiOSCurrency

let mappingExamples = ["AUD": "1.614",
                       "BGN": "1.953",
                       "BRL": "4.785",
                       "CAD": "1.532",
                       "CHF": "1.126",
                       "CNY": "7.933",
                       "CZK": "25.677",
                       "DKK": "7.446",
                       "GBP": "0.897",
                       "HKD": "9.119",
                       "HRK": "7.423",
                       "HUF": "326",
                       "IDR": "17298",
                       "ILS": "4.164",
                       "INR": "83.593",
                       "ISK": "127.61",
                       "JPY": "129.36",
                       "KRW": "1302.8",
                       "MXN": "22.332",
                       "MYR": "4.805",
                       "NOK": "9.761",
                       "NZD": "1.761",
                       "PHP": "62.499",
                       "PLN": "4.312",
                       "RON": "4.632",
                       "RUB": "79.456",
                       "SEK": "10.575",
                       "SGD": "1.598",
                       "THB": "38.073",
                       "TRY": "7.617",
                       "USD": "1.162",
                       "ZAR": "17.797"]

let mockResponse: [String: NSNumber] = ["AUD": NSNumber(value: 1.614),
                                        "BGN": NSNumber(value: 1.9529),
                                        "BRL": NSNumber(value: 4.7847),
                                        "CAD": NSNumber(value: 1.5315),
                                        "CHF": NSNumber(value: 1.1258),
                                        "CNY": NSNumber(value: 7.9333),
                                        "CZK": NSNumber(value: 25.677),
                                        "DKK": NSNumber(value: 7.4456),
                                        "GBP": NSNumber(value: 0.8969),
                                        "HKD": NSNumber(value: 9.1188),
                                        "HRK": NSNumber(value: 7.423),
                                        "HUF": NSNumber(value: 326),
                                        "IDR": NSNumber(value: 17298),
                                        "ILS": NSNumber(value: 4.1644),
                                        "INR": NSNumber(value: 83.593),
                                        "ISK": NSNumber(value: 127.61),
                                        "JPY": NSNumber(value: 129.36),
                                        "KRW": NSNumber(value: 1302.8),
                                        "MXN": NSNumber(value: 22.332),
                                        "MYR": NSNumber(value: 4.8048),
                                        "NOK": NSNumber(value: 9.7614),
                                        "NZD": NSNumber(value: 1.7607),
                                        "PHP": NSNumber(value: 62.499),
                                        "PLN": NSNumber(value: 4.3119),
                                        "RON": NSNumber(value: 4.6316),
                                        "RUB": NSNumber(value: 79.456),
                                        "SEK": NSNumber(value: 10.575),
                                        "SGD": NSNumber(value: 1.5976),
                                        "THB": NSNumber(value: 38.073),
                                        "TRY": NSNumber(value: 7.6168),
                                        "USD": NSNumber(value: 1.1617),
                                        "ZAR": NSNumber(value: 17.797)]

var mockRatesDTO = RatesDTO(rates: mockResponse)
var mockCurrencies = mockRatesDTO.rates!.map{ CurrencyEntity(name: $0.key, baseRelation: $0.value.decimalValue) }
