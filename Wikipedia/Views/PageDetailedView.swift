//
//  PageDetailedView.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 11/05/2023.
//

import SwiftUI

struct PageDetailedView: View {
    let title: String
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack{
                Text(title)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                Text(vm.content)
                    .refreshable{
                        vm.fetchPageTitled(title: title)
                    }
            }
            .refreshable {
                vm.fetchPageTitled(title: title)
            }
        }
        .padding(.bottom)
        .padding(.horizontal)
        .foregroundColor(.black.opacity(0.8))
        .onAppear{ vm.fetchPageTitled(title: title) }

    }
}

struct PageDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        PageDetailedView(title: "Test")
    }
}
