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
            HStack {
                Text(.complement).font(.headline)
                Spacer()
            }
            
            Color(color.complement)
                .frame(height: 30)
                .cornerRadius(10)
        }
        .padding()
    }
    
    var splitComplementColors: some View {
        VStack {
            HStack {
                Text(.splitComplement).font(.headline)
                Spacer()
            }
         
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
            HStack {
                Text(.triadic).font(.headline)
                Spacer()
            }
            
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
            HStack {
                Text(.tetradic).font(.headline)
                Spacer()
            }
            
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
            HStack {
                Text(.analagous).font(.headline)
                Spacer()
            }
            
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
