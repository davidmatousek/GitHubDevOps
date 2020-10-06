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
    @State private var showingViewerView = false
    @Binding var rootIsActive : Bool
    
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
                //.navigationBarBackButtonHidden(true)
            //
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarItems(trailing:
//                                NavigationLink(destination: ViewerView()) {
//                if viewer.viewer.avatarURL != "" {
//                    RemoteImage(url: viewer.viewer.avatarURL)
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 40)
//                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                    }
//            }
            Button(action: {
                self.showingViewerView = true
            }) {
                if viewer.viewer.avatarURL != "" {
                    RemoteImage(url: viewer.viewer.avatarURL)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                }
            )
        .sheet(isPresented: $showingViewerView) {
            ViewerView(shouldPopToRootView: self.$rootIsActive)
            }
    }
}
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

