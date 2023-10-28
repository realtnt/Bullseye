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
    @State private var showingAlert = false
    @State private var gameStarted = false
    @State private var sliderValue: CGFloat = 50.0
    @State private var doublePoints = false
    
    var body: some View {
        let target = bullsEyeVM.randomNumber == 0 ? "-" : "\(bullsEyeVM.randomNumber)"
        ZStack {
            Text("\(target)")
                .font(.title)
                .bold()
            VStack {
                BullsEyeSlider(sliderValue: $sliderValue)
                    .padding(.top, 150)
                Spacer()
                Toggle("Double Points", isOn: $doublePoints)
                    .padding(.horizontal, 30)
                    .font(.title2)
                    .bold()
                HStack(spacing: 30) {
                    Button {
                        gameStarted = true
                        bullsEyeVM.getRandomNumber()
                    } label: {
                        Text("Start Game")
                    }
                    .disabled(gameStarted)
                    .buttonStyle(StandardButton())
                    Button("Check") {
                        showingAlert = true
                    }
                    .alert(bullsEyeVM.checkScore(of: Int(sliderValue)), isPresented: $showingAlert) {
                        Button("OK", role: .cancel) {
                            gameStarted = true
                            bullsEyeVM.getRandomNumber()
                        }
                    }
                    .disabled(!gameStarted)
                    .buttonStyle(StandardButton())
                }
                .padding(.vertical)
            }
            .background {
                Image(systemName: "target")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 1000)
                    .foregroundStyle(.red)
                    .opacity(0.2)
            }
        }
    }
}

#Preview {
    BullsEyeView()
}

struct StandardButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 150)
            .background(isEnabled ? .blue : .gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 14, height: 5)))
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct BullsEyeSlider: View {
    @Binding var sliderValue: CGFloat
    let startValue = 1
    let endValue = 100

    var body: some View {
        HStack {
            Text("\(startValue)")
                .font(.caption)
                .frame(width: 25)
            Slider(
                value: $sliderValue,
                in: CGFloat(startValue)...CGFloat(endValue),
                step: 1)
            .padding(5)
            .frame(width: .infinity, height: 50)
            .background(.red)
            .tint(.white)
            .clipShape(
                RoundedRectangle(cornerSize: CGSize(width: 50, height: 50))
            )
            .padding(.horizontal, 1)
            Text("\(endValue)")
                .font(.caption)
                .frame(width: 25)
        }
    }
}
