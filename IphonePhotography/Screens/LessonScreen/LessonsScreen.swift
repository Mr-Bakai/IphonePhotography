//
//  ContentView.swift
//  IphonePhotography
//
//  Created by Bakai on 26/6/23.
//

import SwiftUI

struct LessonsScreen: View {
    @StateObject var lessonViewModel = LessonsViewModelImpl(service: LessonsServiceImpl())
    
    var body: some View {
        VStack {
            
            switch lessonViewModel.state {
            case .loading:
                ProgressView()
                
            case .success(let lessons):
                LessonsListView(lessons: lessons)
                
            case .failed:
                EmptyView()
            }
        }
        .onAppear { lessonViewModel.getLessons() }
        .environmentObject(lessonViewModel)
        .bottomSheet(isPresented: $lessonViewModel.isSheetPresented) {
            RedBottomSheet(
                description: lessonViewModel.errorMessage,
                primaryTitle: "Try Again",
                onPrimaryTap: { lessonViewModel.getLessons() }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsScreen()
    }
}
