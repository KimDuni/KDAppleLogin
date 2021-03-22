//
//  ViewController.swift
//  KDAppleLogin
//
//  Created by 성준 on 2021/03/22.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    @IBOutlet weak var accountStateLabel:UILabel! {
        didSet {
            accountStateLabel.text = "로그인 안됨"
        }
    }
    
    @IBOutlet weak var appleLoginButtonView:UIView!
    let appleLoginModule = AppleLoginModule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: ASAuthorizationAppleIDButton.ButtonType.continue, authorizationButtonStyle: ASAuthorizationAppleIDButton.Style.white)
        button.addTarget(self
            , action: #selector(invokeLoginWithAppleTarget), for: UIControl.Event.touchUpInside)
        button.overrideUserInterfaceStyle = .dark
//        button.bounds = appleLoginButtonView.bounds
//        button.center = appleLoginButtonView.center
        appleLoginButtonView.addSubview(button)
    }

    @IBAction func invokeLoginWithAppleTarget(){
        print("invokeLoginWithAppleTarget")
        appleLoginModule.handlerAuthorizationAppleID(viewController: self)
    }
}

extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential{
            let userIdentifier = credential.user
            if let e = credential.email{
                print(e)
            }
            
            
            //시뮬레이터에 애플아이디 연결 안되어있을때 
//            2021-03-22 22:48:11.618106+0900 KDAppleLogin[59652:485502] [core] Authorization failed: Error Domain=AKAuthenticationError Code=-7022 "(null)" UserInfo={AKClientBundleID=KimDuni.KDAppleLogin}
//            authorizationController error~~~ The operation couldn’t be completed. (com.apple.AuthenticationServices.AuthorizationError error 1000.)
            
            
            //로그인중 취소했을때
//            2021-03-22 22:50:47.119961+0900 KDAppleLogin[59652:490457] [core] Authorization failed: Error Domain=AKAuthenticationError Code=-7003 "(null)" UserInfo={AKClientBundleID=KimDuni.KDAppleLogin}
//            authorizationController error~~~ The operation couldn’t be completed. (com.apple.AuthenticationServices.AuthorizationError error 1001.)
            
            
//            self.createUserFirebaseAccount(userId: userIdentifier) //받은 아이디로 firebase등록하러 간다.
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //에러처리
        print("authorizationController error~~~ \(error.localizedDescription)")
    }
}



class AppleLoginModule : NSObject, ASAuthorizationControllerDelegate {
    
    /// Call By Apple Login Button
    func handlerAuthorizationAppleID(viewController:ViewController){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email] //.email   .fullname  제공가능
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = viewController
        controller.presentationContextProvider = viewController
        controller.performRequests()
    }
}


