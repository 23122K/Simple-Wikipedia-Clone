//
//  SearchResultsView.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 11/05/2023.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var vm: ViewModel
    var body: some View {
        CustomSection(section: "Search results", content: {
            ScrollView(showsIndicators: false){
                ForEach(vm.searchResults, id: \.self) { result in
                    NavigationLink(destination: {
                        PageDetailedView(title: result)
                            .withDismissName(title: "Search results")
                            .environmentObject(vm)
                    }, label: {
                        RowView(title: result)
                            .offset(y: 10)
                    })
                }
            }
        })
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
            .environmentObject(ViewModel())
    }
}
