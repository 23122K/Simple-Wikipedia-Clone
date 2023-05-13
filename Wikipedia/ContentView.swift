//
//  ContentView.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 13/05/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        NavigationView(content: {
            VStack(alignment: .leading) {
                SearchBar(userInput: $vm.userInput, isUsed: $vm.isSearchBarInUse)
                    .animation(Animation.spring(), value: vm.isSearchBarInUse)
                    .onTapGesture { vm.isSearchBarInUse = true }
                
                switch(vm.isSearchBarInUse){
                case false:
                    HomeView()
                        .environmentObject(vm)
                        .onAppear{ vm.fetchUserSearchHistory() }
                case true:
                    SearchResultView()
                        .environmentObject(vm)
                }
                
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
