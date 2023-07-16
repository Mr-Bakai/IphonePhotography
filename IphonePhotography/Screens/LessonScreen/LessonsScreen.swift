//
//  ContentView.swift
//  IphonePhotography
//
//  Created by Bakai on 26/6/23.
//

import SwiftUI

struct LessonsScreen: View {
    @ObservedObject var viewModel = LessonsViewModelImpl(service: LessonsServiceImpl())
    
    var body: some View {
        VStack {
            
            switch viewModel.state {
            case .loading:
                ProgressView()
                
            case .success(let lessons):
                LessonsListView(lessons: lessons)
                
            case .failed(_):
                ProgressView()
            }
        }
        .onAppear { viewModel.getLessons() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsScreen()
    }
}
