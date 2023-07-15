//
//  LessonsCollection.swift
//  IphonePhotography
//
//  Created by Bakai on 15/7/23.
//

import SwiftUI

struct LessonsListView: View {
    var mockData: [MockData] = MockDataList.data
    
    var body: some View {
        VStack {
            NavigationView {
                List(mockData, id: \.id) { item in
                    Image(item.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 70)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.title)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        
                        Text(item.uploadDate)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }.navigationTitle("Lessons")
            }
        }
    }
}

struct LessonsCollection_Previews: PreviewProvider {
    static var previews: some View {
        LessonsListView()
    }
}



struct MockData: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let uploadDate: String
}

struct MockDataList {
    static let data = [
        
        MockData(
            imageName: "brotherhood",
            title: "Test",
            description: "Test",
            uploadDate: "February 17, 2021"),
        
        MockData(
            imageName: "brotherhood",
            title: "Test",
            description: "Test",
            uploadDate: "February 17, 2021"),
        
        MockData(
            imageName: "brotherhood",
            title: "Test",
            description: "Test",
            uploadDate: "February 17, 2021"),
        
        MockData(
            imageName: "brotherhood",
            title: "Test",
            description: "Test",
            uploadDate: "February 17, 2021"),
        
        MockData(
            imageName: "brotherhood",
            title: "Test",
            description: "Test",
            uploadDate: "February 17, 2021"),
    ]
}
