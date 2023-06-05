//
//  ContentView.swift
//  Photos
//
//  Created by لجين إبراهيم الكنهل on 15/11/1444 AH.
//

import SwiftUI



struct ContentView: View {
 
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    
    @State private var image = UIImage()
    @State private var showSheet = false
    @State var alertMessage = ""
    @State var isAlertShown = false
    @State var isLoading = true
    @State var photos: [Photos] = [
//        Photos( id: UUID.uuid, title: "YYY", thumbnailUrl: "https://via.placeholder.com/150/92c952"),
//        Photos( id: UUID(), title: "YYY", thumbnailUrl: "https://via.placeholder.com/150/92c952")
    ]
    func insertOnePhoto(photo: Photos) async {
        isLoading = true
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let urlString = "https://jsonplaceholder.typicode.com/albums/1/photos/posts"
            let request = try urlString.toRequest(withBody: photo, method: "POST")
           // let result = try await callApi(request, to: DeleteTodoApiResponse.self)
            //photos = result.newTodos
            await fetchTodos()
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    func updateOnePhoto(photo: Photos) async {
        isLoading = true
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let urlString = "https://jsonplaceholder.typicode.com/albums/1/photos/posts"
            let request = try urlString.toRequest(withBody: photo, method: "PUT")
            //let result = try await callApi(request, to: DeleteTodoApiResponse.self)
           // photos = result.newTodos
            await fetchTodos()
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    func deleteOneTodo(photoId: String) async {
        isLoading = true
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let urlString = "https://jsonplaceholder.typicode.com/albums/1/photos/posts" + photoId
            let request = try urlString.toDeleteRequest()
            let result = try await callApi(request, to: [Photos].self)
            //await fetchTodos()
            photos = result
//            if !result.success {
//                alertMessage = result.message
//                isAlertShown = true
//            }
            
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
 
    
    func fetchTodos() async {
        isLoading = true
        do {
           // try await Task.sleep(nanoseconds: 1_000_000_000)
            let urlString = "https://jsonplaceholder.typicode.com/albums/1/photos"
            let request = try urlString.toRequest()
            let apiPhotos = try await callApi(request, to: [Photos].self)
            photos = apiPhotos
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack{
    //Header()
                    if (isLoading) {
                    ProgressView()
                }
                    
                  
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(photos , id: \.id){ photo in
                            VStack{
                                AsyncImage(url: URL(string: photo.thumbnailUrl))
                                        .frame(width: 100, height: 100)
                                        .padding(.horizontal,100)
                                        .onTapGesture {
                                            showSheet = true
                                        }
                                
                         
                                        .sheet(isPresented: $showSheet) {
                                                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                                        }
                                
//                                if let index = photos.firstIndex(where: { $0.id == photo.id }){
//                                    let updatedPhoto = Photos(title: photo.title, url: photo.ur, id: photo.id)
//
//                                    photos[index] = updatedPhoto
//                                    Task {
//                                        await updateOnePhoto(photo: updatedPhoto)
//                                    }
//
//                                }
                                }
                                
                                
                        }.onDelete { index in
                           // let deletedTodoId = index.map { photos[$0].id}.first ?? ""
                            photos.remove(atOffsets: index)
//                            Task {
//                                await deleteOneTodo(todoId: deletedTodoId)
//                            }
                        }
                        //Spacer()
                    }
                    .padding()
                }.task {
                    await fetchTodos()
                }
            }.ignoresSafeArea()
            ZStack{
                HStack(spacing: 15.0){
                    ZStack{
                        Color(.gray)
                        Text("Select")
                            .foregroundColor(.white)
                            .bold()
                    }.frame(width: 75, height: 35)
                        .cornerRadius(20)
                       // .opacity(0.2)
                    ZStack{
                       Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: 35, height: 35)
                                .cornerRadius(20)
                        Text("...")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title)
                            .padding(.bottom)
                    }
                }.padding(.bottom,680)
                    .padding(.leading,220)
                ZStack{
//
                    Text("+")
                        .foregroundColor(.white)
                        .bold()
                        .font(.largeTitle)
                       // .padding(.bottom)
                }.padding(.bottom,690)
                    .padding(.trailing,300)
            }
        }
    }
}






