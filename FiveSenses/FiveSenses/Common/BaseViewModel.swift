//
//  BaseViewModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/08/21.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    var input: Input? { get set }
    var output: Output? { get set }
}
