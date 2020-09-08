//
//  DetailView.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/7/20.
//

import SwiftUI

struct DetailView: View {
    var repository:Repository
    
    var body: some View {
        VStack {
               Text(repository.name).font(.title)
               
               HStack {
                Text("\(repository.description) - Issues:\(repository.issuesTotalCount)")
               }
               
               Spacer()
           }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(repository: Repository.default)
    }
}
