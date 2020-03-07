//
//  SignInWithAppleButton.swift
//  SignInWithApple-SwiftUI
//
//  Created by akira morooka on 2020/03/07.
//  Copyright © 2020 akira morooka. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton()
        // NOTE: ボタン押下時のイベント処理を追加
        // CoordinatorクラスのdidTapButtonメソッドでイベントを受け取る
        button.addTarget(context.coordinator,
                         action: #selector(Coordinator.didTapButton),
                         for: .touchUpInside)
        return button
    }
    
    func updateUIView(_: ASAuthorizationAppleIDButton, context _: Context) {}
   
    func makeCoordinator() -> Coordinator {
        // NOTE: Coordinatorを作成する処理
        // 初期値にView自身を渡す
        Coordinator(self)
    }
}

final class Coordinator: NSObject {
    var parent: SignInWithAppleButton

    init(_ parent: SignInWithAppleButton) {
        self.parent = parent
        super.init()
    }
   
    // ボタンコンポーネントをタップされたときの処理
    @objc func didTapButton() {
        // NOTE: リクエストの作成
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        // NOTE: 認証情報として、「ユーザ名」と「メールアドレス」を受け取る
        request.requestedScopes = [.fullName, .email]

        // NOTE: 認証リクエストの実行
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension Coordinator: ASAuthorizationControllerDelegate {
    // 認証処理が完了した時のコールバック
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print(appleIDCredential)
        }
    }
    
    // 認証処理が失敗したときのコールバック
    // NOTE: 認証画面でキャンセルボタンを押下されたときにも呼ばれる
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
            print(error)
    }
}

extension Coordinator: ASAuthorizationControllerPresentationContextProviding {
    // 認証プロセス(認証ダイアログ)を表示するためのUIWindowを返すためのコールバック
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }
}
