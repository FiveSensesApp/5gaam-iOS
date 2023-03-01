//
//  UserServices.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/12.
//

import Foundation

import Moya
import RxSwift
import UIKit
import Toaster

class UserServices: Networkable {
    typealias Target = UserAPI
    
    static let provider = makeProvider()
    
    static var disposeBag = DisposeBag()
    
    static func validateDuplicate(email: String) -> Observable<ValidateDuplicateResponse?> {
        UserServices.provider
            .rx.request(.validateDuplicate(email))
            .asObservable()
            .map {
                let response = $0.data.decode(ValidateDuplicateResponse.self)
                dump(response)
                return response
            }
    }
    
    /// 이메일로 코드 전송
    static func validateEmail(email: String) -> Observable<Bool> {
        UserServices.provider
            .rx.request(.validateEmail(email))
            .asObservable()
            .map {
                let response = $0.data.decode(ValidateDuplicateResponse.self)
                return response?.meta.code == 200
            }
    }
    
    /// 코드 올바른지 확인
    static func validateEmailSendCode(email: String, code: String) -> Observable<Bool> {
        UserServices.provider
            .rx.request(.validateEmailSendCode(email: email, code: code))
            .asObservable()
            .map {
                let response = $0.data.decode(ValidateDuplicateResponse.self)
                return response?.meta.code == 200
            }
            
    }
    
    struct ValidateDuplicateResponse: ResponseBase {
        var meta: APIMeta
        var data: String?
    }
    
    static func lostPassword(email: String) -> Observable<Bool> {
        UserServices.provider
            .rx.request(.lostPassword(email: email))
            .asObservable()
            .map {
                return $0.statusCode == 200
            }
    }
    
    struct UserInfoResponse: ResponseBase {
        var meta: APIMeta
        var data: UserInfo?
    }
    
    static func getUserInfo() -> Observable<UserInfo?> {
        UserServices.provider
            .requestWithToken(.getUserInfo)
            .asObservable()
            .map {
                let response = $0.data.decode(UserInfoResponse.self)
                return response?.data
            }
    }
    
    static func updateUser(updatingUser: UpdatingUser) -> Observable<Bool> {
        UserServices.provider
            .requestWithToken(.updateUser(updatingUser: updatingUser))
            .asObservable()
            .map {
                return $0.statusCode == 200
            }
    }
    
    static func changePassword(old: String, new: String) -> Observable<String?> {
        UserServices.provider
            .requestWithToken(.changePassword(old: old, new: new))
            .asObservable()
            .map {
                let response = $0.data.decode(ValidateDuplicateResponse.self)
                return response?.meta.msg
            }
    }
    
    static func deleteUser() {
        UserServices.provider
            .requestWithToken(.deleteUser)
            .asObservable()
            .bind {
                if $0.statusCode == 200 {
                    UIApplication.shared.keyWindow?.replaceRootViewController(OnBoardingViewController(), animated: true, completion: nil)
                } else {
                    Toast(text: "회원 탈퇴에 실패했습니다. 잠시 후 다시 시도해주세요.").show()
                }
            }
            .disposed(by: UserServices.disposeBag)
    }
}

struct UserInfo: Codable {
    var createdUser: CreatedUser
    var badgeRepresent: String?
    var isMarketingAllowed: Bool?
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        badgeRepresent = try values.decode(String?.self, forKey: .badgeRepresent)
        isMarketingAllowed = try values.decode(Bool?.self, forKey: .isMarketingAllowed)
        createdUser = try decoder.singleValueContainer().decode(CreatedUser.self)
    }
}
