//
//  TabView.swift
//  TabView
//
//  Created by COE on 8/9/21.
//

import SwiftUI

struct TabViewController: View {
    @State var selectedView = 2
    var body: some View {
        TabView(selection: $selectedView) {
            FavoritesView()
                .padding()
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
                .tag(1)
            
            CharactersView()
                .padding()
                .tabItem {
                    Label("Characters", systemImage: "person.3")
                }
                .tag(2)
            
            EpisodesView()
                .padding()
                .tabItem {
                    Label("Episodes", systemImage: "list.number")
                }
                .tag(3)

        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabViewController()
    }
}
