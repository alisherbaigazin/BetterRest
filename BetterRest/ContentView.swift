//
//  ContentView.swift
//  BetterRest
//
//  Created by Alisher Baigazin on 04.06.2022.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State var wakeUp = defaultWakeUp
    @State var sleepAmount = 8.0
    @State var coffee = 1
    
//    @State var alertTitle = ""
//    @State var alertMessage = ""
//    @State var alertIsVisible = false
    
    static var defaultWakeUp: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date.now
    }
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Spacer()
                            DatePicker("Enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
//                                .labelsHidden()
                        }
                    } header: {
                        Text("When do you want to wake up?")
                    }
                    Section {
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    } header: {
                        Text("Desired amount of sleep")
                    }
                    
                    Section {
                        Stepper(coffee == 1 ? "1 cup" : "\(coffee) cups", value: $coffee, in: 1...20)
                    } header: {
                        Text("Daily coffee intake")
                    }
                    Section {
                        Text(calculateBedtime())
                    } header: {
                        Text("Your ideal bedtime is:")
                    }
                }
            }
            .navigationTitle("BetterRest")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                Button("Calculate") {
//                    calculateBedtime()
//                }
//                .buttonStyle(.bordered)
//            }
//            .alert(alertTitle, isPresented: $alertIsVisible) {
//                Button("OK", role: .cancel) {}
//            } message: {
//                Text(alertMessage)
//            }

        }
    }
    
    func calculateBedtime() -> String{
        //Error handling
        do {
            let config = MLModelConfiguration() //config for SleepCalculator
            let model = try SleepCalculator(configuration: config) //created instance of SleepCalculator
            // try catching error
            
            let component = Calendar.current.dateComponents([.hour,.minute], from: wakeUp) //returns components from current Calendar(gregorianа) and special day(and time)
            let hour = (component.hour ?? 0) * 60 * 60 // turning into seconds
            let minute = (component.minute ?? 0) * 60 //turning into seconds
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffee)) // try catching error
            let sleepTime = wakeUp - prediction.actualSleep //getting sleep Time Date | actualsleep is seconds
//            alertTitle = "Your bedtime is:"
//            alertMessage = "You should go to sleep at \(sleepTime.formatted(date: .omitted, time: .shortened))"
            return sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            //catching errors?
//            alertTitle = "Error"
//            alertMessage = "There is was a problem during calculation your bedtime"
            return "Error"
        }
        
//        alertIsVisible.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
