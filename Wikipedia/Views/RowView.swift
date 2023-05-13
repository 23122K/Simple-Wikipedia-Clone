//
//  rowView.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 13/05/2023.
//

import SwiftUI

struct RowView: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(title)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }
            .padding()
            .background{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .shadow(color: Color.gray.opacity(0.4),
                            radius: 3,
                            x: 0.1, // Horizontal offset
                            y: 0.4) // Vertical offset
            }
        }
        .padding(.horizontal)
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(title: "Wikipedia")
    }
}
