//
//  HomeView.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 13/05/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: ViewModel
    var body: some View {
        CustomSection(section: "Recent searches", content: {
            ScrollView(showsIndicators: false){
                ForEach(vm.history) { content in
                    NavigationLink(destination: {
                        PageDetailedView(title: content.unwrappedTitle)
                            .withDismissName(title: "Home")
                            .environmentObject(vm)
                    }, label: {
                        RowView(title: content.unwrappedTitle)
                            .offset(y: 10)
                    })
                }
            }
        })
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ViewModel())
    }
}
