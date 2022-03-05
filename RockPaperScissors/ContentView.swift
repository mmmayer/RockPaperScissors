//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Michael M. Mayer on 3/1/22.
//

import SwiftUI
// The number of images of rock, paper, scissors
let numImages = 10

// The three possible answers of rock, paper, scissors are presented in a different order for each question.
var answers = [0, 1, 2].shuffled()

struct ContentView: View {
    // The game's choice of rock, paper, or scissors
    @State private var gameChoice = Int.random(in: 0..<3)
    // random choice for which of the images are presented this round
    @State private var choiceVersion = Int.random(in: 1...numImages)
    
    // Whether the game has started or not
    @State private var hasStarted = false
    
    // Determines for the round whether the answer should beat the game's choice or lose to it
    @State private var outcome = Bool.random()
    
    // The current score of the game
    @State private var score = 0
    
    // The time remaining in the round - from 5 to 0 seconds
    @State private var timeRemaining = 5
    
    // A timer that connects to the main run-loop and notifies a listener periodically
    // The listener is on the Text view that displays the time remaining, but it could be anywhere
    let timer = Timer.publish(every: 1.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color(red: 242.0 / 255.0, green: 110.0 / 255.0, blue: 1 / 255.0)
                .ignoresSafeArea()
            VStack {
                Text("Rock Paper Scissors")
                    .font(.largeTitle)
                    .fontWeight(.black)
                Spacer()
                Text("The computer chose:")
                    .font(.title2)
                    .fontWeight(.black)
                    .padding(0)
                Image("\(randItem(gameChoice))\(choiceVersion)")
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    .padding(0)
                
                Spacer()
                Text("Pick the one that \(randOutcome())")
                    .font(.title2)
                    .fontWeight(.black)
                HStack {
                    Button {
                        answer(answers[0])
                    } label: { Image("\(randItem(answers[0]))\(choiceVersion)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100.0, maxHeight: 100.0)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    }
                    .padding(10)
                    Button {
                        answer(answers[1])
                        
                    } label: { Image("\(randItem(answers[1]))\(choiceVersion)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100.0, maxHeight: 100.0)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    }
                    .padding(10)
                    Button {
                        answer(answers[2])
                        
                    } label: { Image("\(randItem(answers[2]))\(choiceVersion)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 100.0, maxHeight: 100.0)
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    }
                    .padding(10)
                }
                .background(Color(red: 0.95, green: 0.95, blue: 0.95))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                Spacer()
                Button(!hasStarted ? "Start" : "Pause") {
                    hasStarted.toggle()
                }
                .font(.largeTitle)
                .padding()
                HStack {
                    Text("Score: \(score)").bold()
                        .padding(30)
                    Text("Timer: \(timeRemaining)").bold()
                        .onReceive(timer) { _ in
                            if hasStarted {
                                timeRemaining -= 1
                                if timeRemaining <= 0 {
                                    score -= 1
                                    newTurn()
                                }
                            }
                        }
                        .padding(30)
                    
                }
            }
        }
    }
    
    func randItem(_ choice: Int) -> String {
        switch choice {
            case 0:
                return "Rock"
            case 1:
                return "Paper"
            case 2:
                return "Scissors"
            default:
                fatalError()
        }
    }
    
    func randOutcome() -> String {
        return outcome ? "wins" : "loses"
    }
    
    func answer(_ answer: Int) -> Void {
        if hasStarted {
            let remainingTime = timeRemaining
            if outcome && answer == (gameChoice + 1) % 3 {
                score += remainingTime
            }
            else if !outcome && answer == (gameChoice - 1 + 3) % 3 {
                score += remainingTime
            }
            else {
                score -= 1
            }
            newTurn()
        }
    }
    
    func newTurn() {
        answers.shuffle()
        gameChoice = Int.random(in: 0..<3)
        choiceVersion = Int.random(in: 1...numImages)
        outcome = Bool.random()
        timeRemaining = 5
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
