//
//  NSDecimalNumber+Operators.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 13/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

// MARK: - Observers

import UIKit

let keyboardAnimationDuration = 0.3

extension UIViewController {
    
    func addKeyboardsObservers(forShow showNotificationName: NSNotification.Name = .UIKeyboardWillShow,
                               forHide hideNotificationName: NSNotification.Name = .UIKeyboardWillHide) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardShow(notification:)),
                                               name: showNotificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHide(notification:)),
                                               name: hideNotificationName,
                                               object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    
    @objc func keyboardShow(notification: NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardRectValue.height
            if #available(iOS 11.0, *) {
                let bottomInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
                keyboardHeightDidChange(withNewHeight: keyboardHeight - bottomInset)
            } else {
                keyboardHeightDidChange(withNewHeight: keyboardHeight)
            }
            animateLayoutIfNeeded(withDuration: keyboardAnimationDuration)
        }
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat = 0.0
            keyboardHeightDidChange(withNewHeight: keyboardHeight)
            animateLayoutIfNeeded(withDuration: keyboardAnimationDuration)
        }
    }
    
    @objc func keyboardHeightDidChange(withNewHeight height: CGFloat) {
        // Override this func
        fatalError("keyboardHeightDidChange must be overridden")
    }
    // MARK: - Private
    
    private func animateLayoutIfNeeded(withDuration duration: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
}
