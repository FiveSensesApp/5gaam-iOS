//
//  CMViewController.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/07/20.
//

import UIKit

class CMViewController: UIViewController {
    override func loadView() {
        self.view = UIView()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
