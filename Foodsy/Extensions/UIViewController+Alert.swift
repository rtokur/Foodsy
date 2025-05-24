//
//  UIViewController+Alert.swift
//  Foodsy
//
//  Created by Rumeysa Tokur on 23.05.2025.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Error",
                   message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel))
        present(alert,
                animated: true)
    }
}
