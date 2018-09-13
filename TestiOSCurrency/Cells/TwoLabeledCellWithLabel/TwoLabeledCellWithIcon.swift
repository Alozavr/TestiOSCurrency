//
//  TwoLabeledCellWithIcon.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import Kingfisher

protocol CellTextFieldDelegate: ListObjectDelegatable {
    func shouldChangeText(textField: UITextField, in range: NSRange, with string: String) -> Bool
}

class TwoLabeledCellWithIcon: UITableViewCell, ListObject, NibReusable {
    weak var delegate: CellTextFieldDelegate?
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    func configure(with viewModel: ListObjectModel, delegate: ListObjectDelegatable?) {
        guard let model = viewModel as? TwoLabeledCellWithIconListModel else { return }
        self.delegate = delegate as? CellTextFieldDelegate
        icon.kf.setImage(with: model.imageUrl)
        topLabel.text = model.mainTitle
        bottomLabel.text = model.subTitle
        textField.text = model.value
        textField.keyboardType = .decimalPad
        textField.delegate = self
    }
    
}

extension TwoLabeledCellWithIcon: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return delegate?.shouldChangeText(textField: textField, in: range, with: string) ?? true
    }
}
