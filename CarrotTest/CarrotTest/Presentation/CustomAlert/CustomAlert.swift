//
//  CustomAlert.swift
//  CarrotTest
//
//  Created by vision on 12/5/25.
//

import UIKit

extension UIViewController {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "에러 발생",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
