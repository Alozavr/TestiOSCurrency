//
//  CurrencyView.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 08/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyViewController: UIViewController, CurrencyViewProtocol {
    
    weak var tableView: UITableView!
    var viewModel: CurrencyViewModelProtocol!
    var disposeBag = DisposeBag()
    var bottomTableConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addKeyboardsObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        removeObservers()
    }
    
    @objc override func keyboardHeightDidChange(withNewHeight height: CGFloat) {
        bottomTableConstraint.constant = -height
    }
    
    // MARK: TableView
    
    private func setupTableView() {
        let tmpTable = UITableView(frame: view.frame, style: .plain)
        tableView = tmpTable
        view.addSubview(tableView)
        bindTableViewConstraints()
        tableView.estimatedRowHeight = 80
        setupScrollingBehaviour()
        setupDataSource()
    }
    
    private func setupScrollingBehaviour() {
        tableView.rx.willBeginDragging
            .subscribe(
                onNext: {_ in
                    self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupDataSource() {
        tableView.register(cellType: TwoLabeledCellWithIcon.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.sectionsArray.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .filter({ _ in
                return !self.tableView.isTracking && !self.tableView.isDecelerating
            })
            .subscribe(
                onNext: { newValue in
                    guard newValue.count == self.tableView.numberOfSections else {
                        self.tableView.reloadData()
                        return
                    }
                    
                    for (i, section) in newValue.enumerated() {
                        guard self.tableView.numberOfRows(inSection: i) == section.items.count else {
                            self.tableView.reloadData()
                            return
                        }
                    }
                    
                    let reloadableCells = self.tableView.visibleCells
                        .compactMap({ $0 as? TwoLabeledCellWithIcon })
                        .filter({ !$0.textField.isFirstResponder})
                        .compactMap({ self.tableView.indexPath(for: $0) })
                    
                    self.tableView.reloadRows(at: reloadableCells, with: .none)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTableViewConstraints() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        if #available(iOS 11.0, *) {
             bottomTableConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        } else {
             bottomTableConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
        bottomTableConstraint.isActive = true
        view.sendSubview(toBack: tableView)
    }
}

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TwoLabeledCellWithIcon else { return }
        cell.textField.resignFirstResponder()
    }
}

extension CurrencyViewController: UITableViewDataSource {
    var sections: [TableSection] {
        return viewModel.sectionsArray.value
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        if let configurable = cell as? ListObject {
            configurable.configure(with: item, delegate: self)
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension CurrencyViewController: CellTextFieldDelegate {
    
    func shouldChangeText(textField: UITextField, in range: NSRange, with string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let newString = currentText.replacingCharacters(in: range, with: string)
        guard let cellCurrency = (textField.superview?.superview as? TwoLabeledCellWithIcon)?.topLabel.text else { return false}
        guard viewModel.isValid(amount: currentText as String) else { return false }
        viewModel.selectedCurrencyName.value = (cellCurrency, newString as String)
        return true
    }
}
