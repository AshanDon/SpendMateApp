//
//  UpdateProfile.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 17/10/2023.
//

import SwiftUI
import PhotosUI

struct UpdateProfile: View {
    
    enum InputFields {
        case firstNameField, lastNameField
    }
    
    // MARK: - PROPERTIES
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var selectedPhoto: [PhotosPickerItem] = []
    @State private var data: Data?
    @State private var showLoadingView: Bool = false
    @State private var showAlertView: Bool = false
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    @State private var disableSaveButton: Bool = true
    
    @FocusState private var focusFields: InputFields?
    
    @EnvironmentObject private var profileController: ProfileController
    
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("CurrentUser") private var currentUser: String?
    
    @Binding var showView: Bool
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                
                if let data = data,
                    let uiimage = UIImage(data: data) {
                    Image(uiImage: uiimage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .zIndex(0)
                        .overlay {
                            VStack {
                                Spacer()
                                
                                HStack{
                                    Spacer()
                                    
                                    HStack{
                                        Spacer()
                                        
                                        PhotosPicker(
                                            selection: $selectedPhoto,
                                            maxSelectionCount: 1,
                                            matching: .images
                                        ) {
                                            Image(systemName: "camera.circle.fill")
                                                .font(Font.body.bold())
                                                .imageScale(.large)
                                                .foregroundColor(.white)
                                                .frame(width: 25, height: 25)
                                                .zIndex(1)
                                                .background(Circle().fill(Color.accentColor))
                                        } //: Image Picker
                                        .padding(.bottom, 5)
                                        .padding(.trailing, 10)
                                    } //: HStack
                                } //: HStack
                            } //: VStack
                        }
                    .padding(.vertical, 30)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .zIndex(1)
                        .overlay {
                            VStack {
                                Spacer()
                                
                                HStack{
                                    Spacer()
                                    
                                    PhotosPicker(
                                        selection: $selectedPhoto,
                                        maxSelectionCount: 1,
                                        matching: .images
                                    ) {
                                        Image(systemName: "camera.circle.fill")
                                            .font(Font.body.bold())
                                            .imageScale(.large)
                                            .foregroundColor(.white)
                                            .frame(width: 25, height: 25)
                                            .zIndex(1)
                                            .background(Circle().fill(Color.accentColor))
                                    } //: Image Picker
                                    .padding(.bottom, 5)
                                    .padding(.trailing, 10)
                                } //: HStack
                            } //: VStack
                        }
                    .padding(.vertical, 30)
                }
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("First Name")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        
                    ZStack(alignment: .leading) {
                        if firstName.isEmpty {
                            Text("Charles")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 6)
                                .padding(.leading, 4)
                        }
                        
                        TextField("", text: $firstName)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .keyboardType(.emailAddress)
                            .focused($focusFields, equals: .firstNameField)
                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: focusFields == .firstNameField ? .accentColor : .black))
                            .onSubmit {
                                enableSaveButton()
                            }
                    }
                } //: First Name Group
                .padding(.top, 10)
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading, spacing: 7) {
                    Text("Last Name")
                        .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                        .foregroundColor(.black)
                        
                    ZStack(alignment: .leading) {
                        if lastName.isEmpty {
                            Text("Archie")
                                .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                                .foregroundColor(Color.black.opacity(0.3))
                                .padding(.bottom, 6)
                                .padding(.leading, 4)
                        }
                        
                        TextField("", text: $lastName)
                            .font(.custom("Inter-VariableFont_slnt,wght", size: 14))
                            .keyboardType(.emailAddress)
                            .focused($focusFields, equals: .lastNameField)
                            .textFieldStyle(BottomLineTextFieldStyle(lineColor: focusFields == .lastNameField ? .accentColor : .black))
                            .onSubmit {
                                enableSaveButton()
                            }
                    }
                } //: First Name Group
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Button(action: {
                    DispatchQueue.main.async {
                        
                        showLoadingView.toggle()
                        
                        updateProfileData()
                        
                    }
                }) {
                    Text("Update")
                        .font(.custom("Roboto-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                } //: Save Button
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.accentColor)
                )
                .disabled(disableSaveButton)
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Spacer()
            } //: VStack
        } //: ZStack
        .navigationTitle("Update Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.global(qos: .background).async {
                showLoadingView.toggle()
                getProfileData()
            }
        }
        .onChange(of: selectedPhoto) { photos in
            guard let item = photos.first else {
                return
            }
            
            item.loadTransferable(type: Data.self) { result in
                switch result {
                    
                case .success(let data):
                    if let data = data {
                        self.data = data
                        self.enableSaveButton()
                    } else {
                        print("Data is nil..")
                    }
                case .failure(let failure):
                    print("Error:- \(failure.localizedDescription)")
                }
            }
        }
        .overlay {
            if showLoadingView {
                LoadingView()
            }
        }
        .alert(isPresented: $showAlertView) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")){
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showView.toggle()
                }
            })
        }
    }
    
    
    // MARK: - FUNCTION
    private func enableSaveButton(){
       disableSaveButton = data == nil || firstName.isEmpty || lastName.isEmpty
    }
    
    private func getProfileData(){
        Task {
            do {
                if let userId = currentUser {
                    let profile = try await profileController.getProfile(userId: userId)
                    firstName = profile.first_name
                    lastName = profile.last_name
                    data = profile.profile_image
                    
                    showLoadingView.toggle()
                }
            } catch {
                
                alertMessage = error.localizedDescription
                
                showAlertView.toggle()
                
            }
        }
    }
    
    private func updateProfileData(){
        Task {
            do {
                guard let userId = currentUser else {
                    return
                }
                
                guard let imageData = data else {
                    return
                }
                
                let profile = Profile(user_id: userId, first_name: firstName, last_name: lastName, profile_image: imageData, date_created: Date())
                
                try await profileController.updateProfileData(profile: profile)
                
                showLoadingView.toggle()
                
                alertTitle = "Done!"
                alertMessage = "Profile sucessfully updated."
                
                showAlertView.toggle()
            } catch {
                
                showLoadingView.toggle()
                
                alertTitle = "Error!"
                alertMessage = "Profile unsucessfully updated. Please try again."
                
                showAlertView.toggle()
            }
        }
    }
}

struct UpdateProfile_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProfile(showView: .constant(false))
    }
}
