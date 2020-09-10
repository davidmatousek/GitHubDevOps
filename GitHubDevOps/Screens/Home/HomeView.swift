//
//  ContentView.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/4/20.
//

import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct HomeView: View {
    @ObservedObject private var viewer: GetViewer = GetViewer()
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("User Information")) {
                    Text(viewer.viewer.userName)
                }
                Section(header: Text("Repositories")) {

                    List(viewer.viewer.repositories, id:\.id) { repository in
                    NavigationLink(destination: HomeDetailView(repository: repository)) {
                        Text(repository.name)
                            }
                    }
                                    }
                Section(header: Text("Organizations")) {
                    List(viewer.viewer.organizations, id:\.id) { organization in
                    NavigationLink(destination: OrganizationView(organization: organization)) {
                        Text(organization.name)
                            }
                    }
                    
                }
            }
            //.navigationBarTitle("My stuff")
            .navigationViewStyle(StackNavigationViewStyle())
            Text("Second View")
        }
       
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


    
