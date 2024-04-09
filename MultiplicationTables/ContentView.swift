//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by MaćKo on 09/04/2024.
//

import SwiftUI

enum Stage {
    case settings, game
}

struct ContentView: View {
    @State private var currentStage = Stage.settings

    @State private var multiplicationTable = 2
    var multiplicationTables: [Int] { // TODO: What is best solution for shifted index when we use range in Picker?
        var tables = [Int]()
        for i in 2...12 {
            tables.append(i)
        }

        return tables
    }

    @State private var numberOfQuestions = 5
    let questionNumberOptions = [1, 5, 10, 15]
    @State private var currentQuestion = 1

    @State private var multiplier = 0
    @State private var userAnswer = 0
    @State private var userAnswerCorrectly = false
    @State private var numberOfCorrectAnswers = 0

    @State private var showingResult = false
    @State private var isGameOver = false

    var body: some View {
        if currentStage == .settings {
            NavigationStack {
                Form {
                    Section("Which multiplication tables you want to practice?") {
                        Picker("Select multiplication table", selection: $multiplicationTable) {
                            ForEach(multiplicationTables, id: \.self) {
                                Text("\($0)x tables")
                            }
                        }
                    }

                    Section("How many questions you want to be asked?") {
                        Picker("Select number of questions", selection: $numberOfQuestions) {
                            ForEach(questionNumberOptions, id: \.self) {
                                Text("\($0) questions")
                            }
                        }
                    }

                    Section {
                        Text("You will be practice \(multiplicationTable)x multiplication tables and I will ask \(numberOfQuestions) questions. Are you ready?")
                        Button("Start Game") {
                            startGame()
                        }
                    }
                }
                .navigationTitle("xTables")
            }
        } else {
            NavigationStack {
                List {
                    Section {
                        Text("What is \(multiplicationTable) times \(multiplier)?")
                        TextField("Answer", value: $userAnswer, format: IntegerFormatStyle())
                    }
                }
                .navigationTitle("xTables")
                .toolbar {
                    Button("Setup new game") {
                        editSettings()
                    }
                }
                .onSubmit(checkAnswer)
                .alert(userAnswerCorrectly ? "Correct" : "Wrong", isPresented: $showingResult) {
                    Button("Continue", action: askQuestion)
                } message: {
                    Text("\(multiplicationTable) x \(multiplier) = \(multiplicationTable * multiplier)")
                }
                .alert("You answered all the questions", isPresented: $isGameOver) {
                    Button("Repeat", action: startGame)
                    Button("New game", action: editSettings)
                } message: {
                    Text("\nYou answered \(numberOfCorrectAnswers) out of \(numberOfQuestions) questions correctly.\n\nRepeat game with same settings or setup new game.")
                }
            }
        }
    }

    func startGame() {
        currentStage = .game
        numberOfCorrectAnswers = 0
        currentQuestion = 1
        askQuestion()
    }

    func askQuestion() {
        if currentQuestion > numberOfQuestions {
            isGameOver = true
            return // will not change question
        } else {
            currentQuestion += 1
        }

        multiplier = Int.random(in: 2...12)
        userAnswer = 0
    }

    func checkAnswer() {
        userAnswerCorrectly = userAnswer == (multiplicationTable * multiplier)
        if userAnswerCorrectly {
            numberOfCorrectAnswers += 1
        }
        showingResult = true
    }

    func editSettings() {
        currentStage = .settings
    }
}

#Preview {
    ContentView()
}
