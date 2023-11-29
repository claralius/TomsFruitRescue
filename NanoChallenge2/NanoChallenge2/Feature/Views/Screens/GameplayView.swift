//
//  GameplayView.swift
//  NanoChallenge2
//
//  Created by Clarabella Lius on 23/05/23.
//

import SwiftUI
import SpriteKit
import AVFoundation

struct FruitModel: Identifiable, Hashable{ //Tipe data baru
    let id = UUID()
    var image: String
    var isSpoiled: Bool
    
    init(image: String, isSpoiled: Bool) { //used to set initial values  of image and isSpoiled.
        self.image = image //self krn manggil dari diri sendiri
        self.isSpoiled = isSpoiled
    }
}

class Fruit: SKSpriteNode{ //SKSpriteNode used for graphical element. Fruit represents graphical element in SpriteKit
    let image : String
    let isSpoiled : Bool
    
    init(image: String, isSpoiled: Bool) {
        self.image = image
        self.isSpoiled = isSpoiled
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: CGSize(width: 100, height: 100)) 
        self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class GameScene: SKScene{ // game background scene & handles logic and content
    var fruits : [FruitModel] = [FruitModel(image: AssetName.apple, isSpoiled: false), FruitModel(image: AssetName.spoiledApple, isSpoiled: true),
                                 
        FruitModel(image: AssetName.banana, isSpoiled: false),
        FruitModel(image: AssetName.spoiledBanana, isSpoiled: true),
                                 
        FruitModel(image: AssetName.strawberry, isSpoiled: false),
        FruitModel(image: AssetName.spoiledStrawberry, isSpoiled: true),
                                 
        FruitModel(image: AssetName.orange, isSpoiled: false),
        FruitModel(image: AssetName.spoiledOrange, isSpoiled: true),
                                 
        FruitModel(image: AssetName.avocado, isSpoiled: false),
        FruitModel(image: AssetName.spoiledAvocado, isSpoiled: true)]
    
    @ObservedObject var gameData : GameData
    
    init(size: CGSize, gameData: GameData) {
        self.gameData = gameData
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var duration = 1.5 //duration of the fruit falling
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.65) //gravity simulation. dx is horizontal force & dy downward gravitational force
        backgroundColor = .clear
        generateFruit(duration: duration)
        gameData.backgroundMusic?.play()
    }
    
    func generateFruit(duration: Double){//sequence of actions to create fruits and wait
        self.removeAllActions()
        let createFruitAction = SKAction.run {
            self.createFruit()
        }
        let waitAction = SKAction.wait(forDuration: duration)
        let sequenceAction = SKAction.sequence([createFruitAction, waitAction])
        let repeatAction = SKAction.repeatForever(sequenceAction)
        
        run(repeatAction)
    }
    
    func createFruit(){ //creating individual fruits to add to the scene
        let fruitModel = fruits.randomElement()
        let fruit = Fruit(image: fruitModel?.image ?? "Apple", isSpoiled: fruitModel?.isSpoiled ?? false)
        let randomX = CGFloat.random(in: fruit.size.width/2...size.width - fruit.size.width/2) //range dari kiri sampe ke kanan screen. baru utk kalkulasi posisi
        fruit.position = CGPoint(x: randomX, y: size.height + 50) // diposisikan buahny
        addChild(fruit)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameData.life == 0 {
            self.removeAllActions()
            self.removeFromParent()
            gameData.backgroundMusic?.stop()
        }
//        for node in self.children{
//            print(node)
//            if node.position.y < 0 {
//                gameData.life -= 1
//            }
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let touchLocation = touch.location(in: self)
        
        if let touchedNode = atPoint(touchLocation) as? Fruit{
            if !touchedNode.isSpoiled{//good fruits
                //Play Sound
                gameData.goodFruitSound?.play()
                gameData.score += 1
                gameData.face = gameData.face < 0 ? 1 : gameData.face + 1
                if gameData.score != 0 && gameData.score >= 2 {
                    generateFruit(duration: 0.75)
                }
            }else{//bad fruits
                //Play Sound
                gameData.badFruitSound?.play()
                if gameData.life > 0 {
                    print("touchedNode.isSpoiled")
                    gameData.life -= 1
                    gameData.face = -1
                }
                
            }
            touchedNode.removeFromParent()
            
        }
    }
}

class GameData: ObservableObject{
    @Published var score = 0{
        didSet {
           if score > highScore {
               highScore = score
           }
       }
    }
    @Published var life = 3
    @Published var face = 0
    @Published var timer = 0
    @AppStorage("highScore") var highScore = 0
    var goodFruitSound: AVAudioPlayer?
    var badFruitSound: AVAudioPlayer?
    var backgroundMusic: AVAudioPlayer?
    
    init() {
        if let backgroundMusicURL = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3") {
            backgroundMusic = try? AVAudioPlayer(contentsOf: backgroundMusicURL)
            backgroundMusic?.numberOfLoops = -1 // Set the number of loops (-1 means infinite loop)
            backgroundMusic?.prepareToPlay()
        }
        
        if let goodFruitSoundURL = Bundle.main.url(forResource: "GoodFruit", withExtension: "mp3") {
            goodFruitSound = try? AVAudioPlayer(contentsOf: goodFruitSoundURL)
            goodFruitSound?.prepareToPlay()
        }
        
        if let badFruitSoundURL = Bundle.main.url(forResource: "BadFruit", withExtension: "mp3") {
            badFruitSound = try? AVAudioPlayer(contentsOf: badFruitSoundURL)
            badFruitSound?.prepareToPlay()
        }
    }
}

struct GameplayView: View {
    @StateObject var gameData = GameData()
    @State var face = AssetName.sick
    @State public var scoreCount = 0
    
    var body: some View {
        NavigationView{
            ZStack {
                if gameData.life > 0{
                    ZStack{
                        //Background
                        GeometryReader{ geometry in
                            Image(AssetName.whiteBackground)
                            
                            //Health
                            HStack{
                                Image(AssetName.health)
                                    .resizable()
                                    .frame(width: 35, height: 30)
                                    .opacity(gameData.life >= 1 ? 1.0 : 0.0)
                                Image(AssetName.health)
                                    .resizable()
                                    .frame(width: 35, height: 30)
                                    .opacity(gameData.life >= 2 ? 1.0 : 0.0)
                                
                                Image(AssetName.health)
                                    .resizable()
                                    .frame(width: 35, height: 30)
                                    .opacity(gameData.life >= 3 ? 1.0 : 0.0)
                            }.frame(width: 28, height: 28)
                                .position(x: geometry.size.width * 0.25, y:geometry.size.height * 0.10)
                            
                            //Score
                            Text("\(gameData.score)")
                                .font(.system(size:40))
                                .bold()
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.28)
                            
                            //Faces
                            Image(face)
                                .resizable()
                                .frame(width: 535, height: 376)
                                .position(x: geometry.size.width / 2, y:geometry.size.height * 0.60)
                            
                                .onChange(of: gameData.face) { newValue in
                                    if gameData.face == 0 {
                                        self.face = AssetName.sick
                                    }else if gameData.face < 0 {
                                        self.face = AssetName.sicker
                                    }else if gameData.face >= 10 {
                                        self.face = AssetName.best
                                    }else if gameData.face >= 5 {
                                        self.face = AssetName.better
                                    }
                                }
                            
                            //Blanket
                            Image(AssetName.blanket)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width)
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.87)
                            
                            SpriteView(scene: GameScene(size: CGSize(width: geometry.size.width, height: geometry.size.height), gameData: gameData), options: [.allowsTransparency])
                            
                            
                            
                        }
                        
                    }.ignoresSafeArea()
                }else{
                    ResultsView(score: gameData.score, highScore: gameData.highScore)
                }
            }
        }.navigationBarBackButtonHidden(true)
        .onAppear {
            // Load the high score when the view appears
            gameData.highScore = UserDefaults.standard.integer(forKey: "highScore")
        }
        .onDisappear {
            // Save the high score when the view disappears
            UserDefaults.standard.set(gameData.highScore, forKey: "highScore")
        }
    }
}

struct GameplayView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayView()
    }
}
