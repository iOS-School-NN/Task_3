//
//  ItemView.swift
//  task3
//
//  Created by R S on 31.07.2021.
//

import SwiftUI

struct CharacterDetailView: View {
    @ObservedObject var viewModel: CharacterViewModel
    let id: Int
    
    var body: some View {
        if viewModel.state.characters[id] != nil && viewModel.state.locationTypes[viewModel.state.characters[id]!.location.name] != nil  {
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: viewModel.state.characters[id]!.image)!, image: { Image(uiImage: $0).resizable() }).frame(width: 100, height: 100).background(Color.gray)
                    VStack(alignment: .leading) {
                        Text(viewModel.state.characters[id]!.name)
                        Text(viewModel.state.characters[id]!.gender)
                        Text(viewModel.state.characters[id]!.status)
                        Text(viewModel.state.characters[id]!.species)
                    }
                }
                Text("Местоположение").font(.title)
                Text(viewModel.state.characters[id]!.location.name)
                Text(viewModel.state.locationTypes[viewModel.state.characters[id]!.location.name]!.type)
                Text("Эпизоды").font(.title)
                List{
                    ForEach(viewModel.state.characters[id]!.episode, id: \.self) { episode in
                        if viewModel.state.episodes[episode] != nil {
                            HStack(alignment: .firstTextBaseline, spacing: 0) {
                                Text(viewModel.state.episodes[episode]!.episode + "/" + viewModel.state.episodes[episode]!.name + "/")
                                Text(viewModel.state.episodes[episode]!.air_date)
                            }.lineLimit(3)
                        } else {
                            Text("")
                        }
                    }
                }.onAppear {
                    for episode in viewModel.state.characters[id]!.episode {
                        viewModel.fetchCharacterEpisodes(urlString: episode)
                    }
                }
            }.navigationTitle(viewModel.state.characters[id]!.name)
        }
        else {
            ActivityIndicator()
        }
    }
}

