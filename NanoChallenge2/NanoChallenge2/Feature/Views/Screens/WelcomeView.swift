//
//  Welcome.swift
//  NanoChallenge2
//
//  Created by Clarabella Lius on 22/05/23.
//

import SwiftUI

struct WelcomeView: View {
    
    @State private var tapped = false
    @State var startGame = false
    

    
    var body: some View {
        
        NavigationView{
            ZStack{
                Image(AssetName.background)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack{
                    GeometryReader{ geometry in
                        ZStack{
                            //Yellow Rectangle Background
                            Rectangle()
                                .cornerRadius(15)
                                .frame(width: 340, height: 382)
                                .foregroundColor(Color(AssetName.colorYellow))
                            
                            VStack{
                                if tapped {
                                    //How To Play
                                    Text("How To Play")
                                        .fontWeight(.semibold)
                                        .font(.system(size:20))
                                    
                                    Text(StringResource.instruction)
                                        .frame(maxWidth: 282, maxHeight: 56)
                                        .fontWeight(.regular)
                                        .font(.system(size:16))
                                        .lineSpacing(10)
                                    
                                    
                                    //Good Quality Fruits
                                    HStack{
                                        Image(AssetName.apple)
                                            .resizable()
                                            .frame(width: 34, height: 37)
                                            .padding(.trailing, 6)
                                        
                                        Text(StringResource.goodFruits)
                                            .frame(maxWidth: 237, maxHeight: 50)
                                            .font(.system(size:13))
                                            .lineSpacing(5)
                                    }.padding(.horizontal, 8)
                                    
                                    //Bad Quality Fruits
                                    HStack{
                                        Image(AssetName.spoiledAvocado)
                                            .resizable()
                                            .rotationEffect(Angle(degrees: -14.76))
                                            .frame(width: 29, height: 40)
                                            .padding(.trailing, 6)
                                        
                                        Text(StringResource.badFruits)
                                            .frame(maxWidth: 237, maxHeight: 50)
                                            .font(.system(size:13))
                                            .lineSpacing(5)
                                    }.padding(.horizontal, 8)
                                    
                                    
                                    //Warning Instruction
                                    Text("Make **three or more mistakes**, and  Tom's condition won't improve and will worsen!")
                                        .frame(maxWidth: 282, maxHeight: 81)
                                        .fontWeight(.regular)
                                        .font(.system(size:16))
                                        .lineSpacing(6)
                                    
                                }else{
                                    //Welcome text
                                    Text("Welcome!")
                                        .fontWeight(.semibold)
                                        .font(.system(size:20))
                                    
                                    Text(StringResource.welcome)
                                        .frame(maxWidth: 257, maxHeight: 224)
                                        .fontWeight(.regular)
                                        .font(.system(size:16))
                                        .lineSpacing(11)
                                }
                            }
                        }.position(x:geometry.size.width / 2, y: geometry.size.height * 0.5)
                        
                        //Next/Start Button
                        Button {
                            if tapped{
                                startGame = true
                            }else {
                                tapped = true
                            }
                        } label: {
                            Text(tapped == true ? "Start" : "Next")
                                .frame(width: 284, height: 43)
                                .bold()
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(10)
                                .padding(.horizontal, 15)
                        }.position(x:geometry.size.width / 2, y: geometry.size.height * 0.87)
                        
                        if(startGame == true){
                            NavigationLink(
                                destination: GameplayView(),
                                isActive: $startGame,
                                label: {EmptyView()}
                            )
                        }
                    }
                }
            }.ignoresSafeArea()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
