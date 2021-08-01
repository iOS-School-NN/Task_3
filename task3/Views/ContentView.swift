//
//  ContentView.swift
//  draft
//
//  Created by R S on 01.08.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: CharacterViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.state.data) { character in
                    NavigationLink(destination: CharacterDetailView(viewModel: viewModel, id: character.id).onAppear {
                        viewModel.fetchCharacter(characterId: character.id)
                        viewModel.fetchCharacterLocation(urlString: character.location.url)
                    }) {
                        EmptyView()
                        CharacterView(character: character).onAppear {
                            if viewModel.state.data.last == character {
                                viewModel.fetchNextPageIfPossible()
                            }
                        }
                    }
                }
            }.navigationTitle("Список персонажей")
            .onAppear(perform: viewModel.fetchNextPageIfPossible)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: CharacterViewModel())
    }
}
