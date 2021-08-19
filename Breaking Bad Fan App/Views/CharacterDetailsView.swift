//
//  CharacterDetailsView.swift
//  CharacterDetailsView
//
//  Created by COE on 8/9/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterDetailsView: View {
    
    var character: Character
    
    var body: some View {
        ScrollView {
            WebImage(url: character.img)
                .resizable()
                .indicator(.activity)
                .aspectRatio(contentMode: .fit)
            VStack(alignment: .leading) {
                
                Text(character.name)
                    .font(.title)
                Text(character.nickname)
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Spacer().frame(height: 20)
                
                Text("Status")
                    .font(.title2)
                Text(character.status)
                    .font(.title3)
                    .foregroundColor(.secondary)
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

//struct CharacterDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacterDetailsView()
//    }
//}
