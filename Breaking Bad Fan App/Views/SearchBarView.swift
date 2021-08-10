//
//  SearchBarView.swift
//  SearchBarView
//
//  Created by COE on 8/10/21.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var searching: Bool
    
     var body: some View {
         ZStack {
             Rectangle()
                 .foregroundColor(Color("LightGray"))
             HStack {
                 Image(systemName: "magnifyingglass")
                 TextField("Search ..", text: $searchText) { startedEditing in
                     if startedEditing {
                         withAnimation {
                             searching = true
                         }
                     }
                 } onCommit: {
                     withAnimation {
                         searching = false
                     }
                 }
             }
             .foregroundColor(.gray)
             .padding(.leading, 13)
         }
             .frame(height: 40)
             .cornerRadius(13)
             .padding()
     }
 }


//struct SearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarView()
//    }
//}
