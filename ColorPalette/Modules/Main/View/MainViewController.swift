//
//  MainViewController.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import UIKit

final class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        navigationController?.navigationBar.isHidden = true
    }

}
