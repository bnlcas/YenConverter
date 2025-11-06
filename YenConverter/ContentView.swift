//
//  ContentView.swift
//  YenConverter
//
//  Created by Benjamin Lucas on 8/29/25.
//


import SwiftUI

struct NumpadButtonView : View {
    let buttonValue : String
    
    let buttonPressed : (String) -> ()
    
    let buttonDiameter : CGFloat = 109.0
    
    let buttonThickness: CGFloat = 5.0
    
    var invert: Bool = false
    
    var body: some View {
        Button {
            buttonPressed(buttonValue)
        } label: {
            ZStack{
                Circle()
                    .fill(invert ? .black : .white)
                    .stroke(invert ? .white : .white, lineWidth: buttonThickness)
                    .frame(width: buttonDiameter, height: buttonDiameter)
                    .padding(2)
                if(buttonValue == "<"){
                    Image(systemName: "delete.backward")
                        .foregroundStyle(invert ? .white : .black)
                        .font(.title)
                } else{
                    Text(buttonValue)
                        .foregroundColor(invert ? .white : .black)
                        .font(.title)
                }
            }
        }
    }
}


struct NumpadView : View {
    let keyEntered : (String) -> ()
    
    let darkBackground : Bool
    
    var body: some View {
        VStack{
            HStack{
                NumpadButtonView(buttonValue: "7", buttonPressed: keyEntered, invert: darkBackground)
                NumpadButtonView(buttonValue: "8", buttonPressed: keyEntered, invert: darkBackground)
                NumpadButtonView(buttonValue: "9", buttonPressed: keyEntered, invert: darkBackground)
            }
            HStack{
                NumpadButtonView(buttonValue: "4", buttonPressed: keyEntered, invert: darkBackground)
                NumpadButtonView(buttonValue: "5", buttonPressed: keyEntered, invert: darkBackground)
                NumpadButtonView(buttonValue: "6", buttonPressed: keyEntered, invert: darkBackground)
            }
            HStack{
                NumpadButtonView(buttonValue: "1", buttonPressed: keyEntered, invert: darkBackground)
                NumpadButtonView(buttonValue: "2", buttonPressed: keyEntered, invert: darkBackground)
                NumpadButtonView(buttonValue: "3", buttonPressed: keyEntered, invert: darkBackground)
            }
            HStack{
                NumpadButtonView(buttonValue: "C", buttonPressed: keyEntered, invert: !darkBackground)
                NumpadButtonView(buttonValue: "0", buttonPressed: keyEntered, invert: darkBackground)
                NumpadButtonView(buttonValue: "<", buttonPressed: keyEntered, invert: !darkBackground)
                //"↤" "⇦"
            }
        }
    }
}

struct ContentView: View {
    //@Environment(\.colorScheme) var colorScheme
    
    @State var yenAmount : Int = 0
    
    @State var usdAmount: Int = 0
    
    @State var inputDigits : [String] = []
    
    let yen2usd : Int = 147
    
    let darkBackground : Bool = true
    
    let backgroundColor : Color
    
    let textColor : Color
    
    init(){
        //darkBackground = (colorScheme == .dark)
        backgroundColor = darkBackground ? .black : .white
        textColor = darkBackground ? .white : .black
    }
    
    func digitsToNumber() -> Int{
        var amount: Int = 0
        var maxExponent: Int = inputDigits.count - 1
        if(maxExponent > 18){
            inputDigits = []
            return 0
        }
        if(maxExponent < 0){
            return 0
        }
        
        for i in 0..<inputDigits.count {
            amount += Int(inputDigits[i])! * Int(pow(10.0, Float(maxExponent - i)))
        }
        return amount
    }
    
    func numpadKeyEntered(keyCode : String){
        print(keyCode)
        if(keyCode == "C"){
            inputDigits = []
        }
        else if(keyCode == "<"){
            if(inputDigits.count > 0){
                inputDigits.removeLast()
            }
        } else {
            inputDigits.append(keyCode)
        }
        yenAmount = digitsToNumber()
        usdAmount = yenAmount / yen2usd
        
    }
    
    var body: some View {
        VStack {
            HStack{
                HStack{
                    Text("\(yenAmount) ¥")
                        .font(.title)
                }
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.title)
                
                Spacer()
                
                HStack{
                    Text("$ \(usdAmount)")
                        .font(.title)

                }
            }
            .foregroundColor(textColor)
            .padding(36)
            //Divider()
            Rectangle()
                .fill(textColor)
                .frame(height: 3)
                .edgesIgnoringSafeArea(.horizontal)

            Spacer()
            NumpadView(keyEntered: numpadKeyEntered, darkBackground: darkBackground)
            Spacer()

        }
        .padding()
        .background(backgroundColor)
    }
}

#Preview {
    ContentView()
}
