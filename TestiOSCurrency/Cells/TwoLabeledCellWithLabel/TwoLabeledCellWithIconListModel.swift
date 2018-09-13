//
//  TwoLabeledCellWithIconListModel.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import Foundation

struct TwoLabeledCellWithIconListModel: ListObjectModel {
    static var associatedListObject: ListObject.Type = TwoLabeledCellWithIcon.self
    
    let imageUrl: URL
    let mainTitle: String
    let subTitle: String
    let value: String
}
