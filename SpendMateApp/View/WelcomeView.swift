//
//  ContentView.swift
//  SpendMateApp
//
//  Created by Ashan Anuruddika on 02/10/2023.
//

import SwiftUI

struct WelcomeView: View {
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color.accentColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                HeadingView()
                
                Spacer()
                
                MiddleView()
                
                Spacer()
                
                BottomView()
            } //: VStack
        } //: ZStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

// MARK: - Heading View
struct HeadingView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Welcome to")
                    .font(.custom("InriaSerif-Bold", size: 20))
                    .foregroundColor(.white)
                    .lineSpacing(22)
                
                Spacer()
            }
            
            HStack {
                Text("Expenses Tracker")
                    .font(.custom("InknutAntiqua-Bold", size: 24))
                    .foregroundColor(.white)
                    .lineSpacing(22)
                
                Spacer()
            }
        } //: Heading View
        .frame(height: 64)
        .padding(.top, 60)
        .padding(.leading, 20)
    }
}

// MARK: - Middle View
struct MiddleView: View {
    var body: some View {
        TabView {
            ForEach(intraductions) { data in
                OnboardView(intru: data)
            }
        } //TabView
        .tabViewStyle(.page(indexDisplayMode: .always))
        .onAppear {
            setupTabviewAppearance()
        }
    }
    
    func setupTabviewAppearance(){
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = .white
    }
}


// MARK: - Bottom View
struct BottomView: View {
    @State private var showMainView: Bool = false
    
    var body: some View {
        Button(action: {
            showMainView.toggle()
        }) {
            HStack {
                Spacer()
                
                Text("Let's Go")
                    .font(.custom("InriaSans-Bold", size: 22))
                    .foregroundColor(.black)
                
                Spacer()
            }
        } //LetsGo Button
        .frame(height: 50, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("#D9D9D9"))
        )
        .padding(.horizontal, 42)
        .padding(.vertical, 50)
        .fullScreenCover(isPresented: $showMainView) {
            SignInView()
        }
    }
}
