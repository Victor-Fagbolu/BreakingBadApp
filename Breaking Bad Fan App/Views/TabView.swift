//
//  TabView.swift
//  TabView
//
//  Created by COE on 8/9/21.
//

import SwiftUI

struct TabViewController: View {
    @State var selectedView = 1
    var body: some View {
        TabView(selection: $selectedView) {
            CharactersView()
                .padding()
                .tabItem {
                    Label("Characters", systemImage: "person.3")
                }
                .tag(1)
            
            
            EpisodesView()
                .padding()
                .tabItem {
                    Label("Episodes", systemImage: "list.number")
                }
                .tag(2)

        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewController()
    }
}
