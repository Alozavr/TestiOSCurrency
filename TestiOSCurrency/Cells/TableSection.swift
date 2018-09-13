//
//  SectionModel.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

struct TableSection {
    var items: [Item]
}

extension TableSection {
    typealias Item = ListObjectModel
    
    init(original: TableSection, items: [ListObjectModel]) {
        self = original
        self.items = items
    }
}

