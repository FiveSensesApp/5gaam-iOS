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
    var hadSeenFirstView: DefaultsKey<Bool> { .init("hadSeenFirstView", defaultValue: false)  }
    var recentSearchTexts: DefaultsKey<[String]> { .init("recentSearchTexts", defaultValue: ["애플, 페이스북, 테슬라, 망포 Let’s go", "애플, 페이스북, 테슬라, 망포 Let’s go", "애플, 페이스북, 테슬라, 망포 Let’s go"]) }
}
