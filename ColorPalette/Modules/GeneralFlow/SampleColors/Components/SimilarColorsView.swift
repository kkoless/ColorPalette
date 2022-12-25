//
//  SimilarColorsView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 24.12.2022.
//

import SwiftUI

struct SimilarColorsView: View {
    let color: UIColor
    
    var body: some View {
        ScrollView {
            VStack {
                complementColor
                splitComplementColors
                triadicColors
                tetradicColors
                analagousColors
            }
            .padding()
        }
    }
}

private extension SimilarColorsView {
    var complementColor: some View {
        VStack {
            Text("Complement:")
            Color(color.complement)
                .frame(height: 30)
                .cornerRadius(10)
        }
        .padding()
    }
    
    var splitComplementColors: some View {
        VStack {
            Text("Split Complement:")
            ForEach(color.getSplitComplementColors()) {
                Color($0)
                    .frame(height: 30)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    var triadicColors: some View {
        VStack {
            Text("Triadic:")
            ForEach(color.getTriadicColors()) {
                Color($0)
                    .frame(height: 30)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    var tetradicColors: some View {
        VStack {
            Text("Tetradic:")
            ForEach(color.getTetradicColors()) {
                Color($0)
                    .frame(height: 30)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    var analagousColors: some View {
        VStack {
            Text("Analagous:")
            ForEach(color.getAnalagousColors()) {
                Color($0)
                    .frame(height: 30)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct SimilarColorsView_Previews: PreviewProvider {
    static var previews: some View {
        let appColor = AppColor(name: "African Violet", hex: "#B284BE")
        SimilarColorsView(color: UIColor(hexString: appColor.hex))
    }
}
