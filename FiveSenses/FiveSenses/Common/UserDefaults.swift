//
//  UserDefaults.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/04.
//

import Foundation

import SwiftyUserDefaults

extension DefaultsKeys {
    var hadSeenOnBoarding: DefaultsKey<Bool> { .init("hadSeenOnBoarding", defaultValue: false)  }
}
