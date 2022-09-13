//
//  EmailConfirmViewModel.swift
//  FiveSenses
//
//  Created by Nam Jun Lee on 2022/09/13.
//

import Foundation

import RxSwift
import RxCocoa

class EmailConfirmViewModel: BaseViewModel {
    struct Input {
        var codeSendTapped: ControlEvent<Void>!
        var code: Observable<String>!
        var finishTapped: ControlEvent<Void>!
    }
    
    struct Output {
        var isCodeSendTapped: Driver<Bool>!
        var isConfirmed: Driver<Bool>!
    }
    
    var input: Input?
    var output: Output? = Output()
    
    var disposeBag = DisposeBag()
    
    init(input: Input) {
        self.input = input
        
        self.output?.isCodeSendTapped = input.codeSendTapped
            .flatMap { _ in
                UserServices.validateEmail(email: EmailPasswordViewController.creatingUser.email)
            }
            .asDriver(onErrorJustReturn: false)
        
        self.output?.isConfirmed = input.finishTapped
            .withLatestFrom(input.code)
            .flatMap { code -> Observable<Bool> in
                UserServices.validateEmailSendCode(email: EmailPasswordViewController.creatingUser.email, code: code)
            }
            .asDriver(onErrorJustReturn: false)
    }
}
