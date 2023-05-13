//
//  customSection.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 11/05/2023.
//

import SwiftUI

struct CustomSection<Content: View>: View {
    
    let content: Content
    let title: String
    
    init(section title: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.title = title
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(title)
                .foregroundColor(.black.opacity(0.5))
                .padding(.leading)
            VStack(alignment: .leading){
                content
            }
        }
    }
}

struct CustomSection_Previews<Content: View>: PreviewProvider {
    static var previews: some View {
        CustomSection(section: "Section", content: {
            Text("First itme")
        })
    }
}
