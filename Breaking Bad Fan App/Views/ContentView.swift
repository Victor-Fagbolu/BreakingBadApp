//
//  ContentView.swift
//  Breaking Bad Fan App
//
//  Created by COE on 8/9/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabViewController()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
