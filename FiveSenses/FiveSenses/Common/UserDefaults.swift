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
    var tmpDeletelogin: DefaultsKey<Bool> { .init("tmpDeletelogin", defaultValue: false)  }
    var hadSeenFirstView: DefaultsKey<Bool> { .init("hadSeenFirstView", defaultValue: false) }
    var recentSearchTexts: DefaultsKey<[String]> { .init("recentSearchTexts", defaultValue: []) }
    var didSeenShareOnBoarding: DefaultsKey<Bool> { .init("didSeenShareOnBoarding", defaultValue: false) }
    var didSeenNewOnBoarding: DefaultsKey<Bool> { .init("didSeenNewOnBoarding", defaultValue: false) }
}
