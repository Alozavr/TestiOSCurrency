//
//  CurrencyDTO.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import ObjectMapper

struct RatesDTO {
    var rates: [String: NSNumber]?
}

extension RatesDTO: Mappable {
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        rates <- map["rates"]
    }
}
