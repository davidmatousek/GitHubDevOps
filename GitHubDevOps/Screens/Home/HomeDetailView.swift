//
//  DetailView.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/7/20.
//

import SwiftUI

struct HomeDetailView: View {
    var repository:Repository
    
    var body: some View {
        Form {
            Section {
               Text(repository.name).font(.title)
            }
            Section {
                HStack{
                    VStack(alignment: .leading) {
                        Text("Issues:")
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(repository.issuesTotalCount)")
                    }
                }
            }
            Section(header: Text("Description")) {
                Text("\(repository.description) ")
            }
           }
    }
}

struct HomeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HomeDetailView(repository: Repository.default)
    }
}
