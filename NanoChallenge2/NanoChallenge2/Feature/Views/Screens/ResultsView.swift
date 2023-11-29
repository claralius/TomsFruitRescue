//
//  ResultsView.swift
//  NanoChallenge2
//
//  Created by Clarabella Lius on 23/05/23.
//

import SwiftUI

struct ResultsView: View {
    
    @State var score : Int
    @State var highScore: Int
    @State var playAgain = false
    
    var body: some View {
        NavigationView{
            ZStack{
                GeometryReader{ geometry in
                    //Background
                    Image(AssetName.background)
                        .resizable()
                    
                    ZStack{
                        //Rectangle frame
                        Rectangle()
                            .cornerRadius(10)
                            .frame(width: 343, height: 348)
                            .foregroundColor(.white)
                            .opacity(0.9)
                        
                        VStack{
                            //Face
                            
                            if(score > highScore){
                                Image(AssetName.bestFace)
                                    .resizable()
                                    .frame(width: 165, height: 116)
                            }
                            
                            if(score<10){ //Sicker
                                Image(AssetName.sickerFace)
                                    .resizable()
                                    .frame(width: 165, height: 116)
                                
                            }else if (score>=10 && score<20){ //Sick
                                Image(AssetName.sickFace)
                                    .resizable()
                                    .frame(width: 165, height: 116)
                                
                            }else if (score>=20 && score<25){//Better
                                Image(AssetName.betterFace)
                                    .resizable()
                                    .frame(width: 165, height: 116)
                                
                            }else{ //Best
                                Image(AssetName.bestFace)
                                    .resizable()
                                    .frame(width: 165, height: 116)
                            }
                            
                            //Your Score
                            Text("Your Score:")
                                .fontWeight(.heavy)
                                .font(.system(size:28))
                                .foregroundColor(Color(AssetName.colorOrange))
                            
                            Text("\(score)")
                                .fontWeight(.heavy)
                                .font(.system(size:50))
                                .padding(.bottom, 5)
                                .foregroundColor(Color(AssetName.colorOrange))
                            
                            //High Score
                            Text("Your Highscore: \(highScore)")
                                .fontWeight(.regular)
                                .font(.system(size:17))
                                
                            
                        }
                        
                    }.frame(width: 343, height: 348 )
                    .position(x: geometry.size.width / 2, y:geometry.size.height * 0.45)
                    
                    //Play Again
                    Button {
                        playAgain = true
                    } label: {
                        Text("Play Again")
                            .frame(width: 284, height: 43)
                            .bold()
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal, 15)
                    }.position(x: geometry.size.width / 2, y:geometry.size.height * 0.87)
                    
                    NavigationLink(
                        destination: GameplayView(),
                        isActive: $playAgain,
                        label: { EmptyView() }
                    )
                    
                }
                
            }.ignoresSafeArea()
        }.navigationBarBackButtonHidden(true)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView(score: 0, highScore: 0)
    }
}
