//
//  RatesQuery.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import RxSwift

final class RatesQuery: RatesQueryProtocol {
    
    let request: NetworkClient<RatesDTO>
    let url: URL
    
    init (request: NetworkClient<RatesDTO>, url: URL) {
        self.request = request
        self.url = url
    }
    
    convenience init() {
        //Born to believe
        let url = URL(string: "https://revolut.duckdns.org/latest?base=EUR")!
        self.init(request: NetworkClient<RatesDTO>(), url: url)
    }
    
    func run(baseName: String) -> Observable<[CurrencyEntity]> {
        let params: [String: Any] = ["base": baseName]
        return request.get(from: url, parameters: params)
            .map({ rate in
                guard let rates = rate.rates else { return [] }
                let currensies = rates.map({ CurrencyEntity(name: $0.key, baseRelation: $0.value.decimalValue) })
                return currensies
            })
    }
    
}
