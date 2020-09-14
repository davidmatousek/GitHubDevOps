//
//  ContentView.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/4/20.
//

import SwiftUI
import UIKit
import AuthenticationServices



struct HomeView: View {

    @EnvironmentObject var viewer: GetViewer

    var body: some View {
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
                .navigationBarBackButtonHidden(true)
            //
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(trailing:
            Button(action: {
                //add code to navigate to viewer view
            }) {
                if viewer.viewer.avatarURL != "" {
                    RemoteImage(url: viewer.viewer.avatarURL)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)

                }

            }
        )
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

