//
//  ContentView.swift
//  BullsEye
//
//  Created by Theo Ntogiakos on 23/10/2023.
//

import SwiftUI

class BullsEyeVM {
    var randomNumber: Int = 0
    
    init() {}
    
    func getRandomNumber() {
        randomNumber = Int.random(in: 1...100)
    }
    
    func checkScore(of value: Int) -> String {
        switch abs(randomNumber - value) {
        case 0:
            "Bingoooo!"
        case 1...5:
            "So close!\nYour guess was: \(value)"
        case 6...10:
            "Not bad!\nYour guess was: \(value)"
        default:
            "Better luck next time!\nYour guess was: \(value)"
        }
    }
}

struct BullsEyeView: View {
    let bullsEyeVM = BullsEyeVM()
    @State private var sliderValue: CGFloat = 50.0
    @State private var showingAlert = false
    @State private var gameStarted = false
    
    var body: some View {
        VStack {
            Button {
                gameStarted = true
                bullsEyeVM.getRandomNumber()
            } label: {
                Text("Start Game")
            }
            .disabled(gameStarted)
            .buttonStyle(StandardButton())
            
            Spacer()
            let target = bullsEyeVM.randomNumber == 0 ? "-" : "\(bullsEyeVM.randomNumber)"
            Label(target, systemImage: "target")
                .font(.title)
                .bold()
                .monospaced()
                .foregroundStyle(.red)
            
            Spacer()
            
            Slider(value: $sliderValue, in: 1...100, step: 1)
                .frame(width: 350, height: 50)
                .background(.red)
                .tint(.white)
                .clipShape(
                    RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                )
            
            Spacer()
            
            Button("Check") {
                showingAlert = true
            }
            .alert(bullsEyeVM.checkScore(of: Int(sliderValue)), isPresented: $showingAlert) {
                Button("OK", role: .cancel) {
                    gameStarted = false
                    sliderValue = 50
                }
            }
            .disabled(!gameStarted)
            .buttonStyle(StandardButton())
        }
    }
}

struct StandardButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 150)
            .background(isEnabled ? .blue : .gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    BullsEyeView()
}
