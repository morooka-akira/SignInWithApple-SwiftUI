//
//  ContentView.swift
//  SignInWithApple-SwiftUI
//
//  Created by akira morooka on 2020/03/07.
//  Copyright © 2020 akira morooka. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            SignInWithAppleButton()
                .frame(width: 200.0, height: 60)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
