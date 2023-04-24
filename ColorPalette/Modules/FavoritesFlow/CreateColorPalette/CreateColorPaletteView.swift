//
//  CreateColorPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import SwiftUI

struct CreateColorPaletteView: View {
    @ObservedObject var viewModel : CreateColorPaletteViewModel
    
    var body: some View {
        VStack {
            navBar
            if !viewModel.output.colors.isEmpty {
                palettePreview
                    .padding([.top, .bottom])
            } else {
                emptyStateView
            }
        }
        .alert(Text(.createPaletteAlertTitle), isPresented: $viewModel.output.showSaveAlert, actions: {
            Button(role: .cancel, action: { stayAlertTap() }) {
                Text(.createPaletteAlertCancel)
            }
            Button(role: .destructive, action: { backAlertTap() }) {
                Text(.createPaletteAlertOK)
            }
        }, message: {
            Text(.createPaletteAlertMessage)
        })
        .foregroundColor(.primary)
        .edgesIgnoringSafeArea(.top)
    }
}

private extension CreateColorPaletteView {
    var navBar: some View {
        CustomNavigationBarView(backAction: {
            viewModel.input.backTap.send()
        })
        .trailingItems {
            HStack(spacing: 25) {
                Button(action: { addColorTap() }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 18, height: 18)
                }
                .disabled(viewModel.output.isLimit)
                .foregroundColor(viewModel.output.isLimit ? .gray : .primary)
                
                if !viewModel.output.colors.isEmpty {
                    Button(action: { savePaletteTap() }) {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    .disabled(viewModel.output.colors.count <= 1)
                    .foregroundColor(viewModel.output.colors.count <= 1 ? .gray : .primary)
                }
            }
        }
    }
    
    var emptyStateView: some View {
        VStack {
            Spacer()
            Text(.favoritesEmptyState)
                .font(.headline).bold()
            Spacer()
        }
    }
    
    var palettePreview: some View {
        List {
            ForEach(viewModel.output.colors) { color in
                Color(color)
                    .opacity(color.alpha)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .cornerRadius(10)
            }
            .onDelete { indexSet in
                indexSet.forEach { viewModel.removeColor(from: $0) }
            }
            .onMove(perform: { indexSet, index in
                viewModel.replaceColors(fromOffsets: indexSet, toOffset: index)
            })
            .frame(height: 60)
        }
        .listStyle(.plain)
        .environment(\.editMode, .constant(.active))
    }
}

private extension CreateColorPaletteView {
    func savePaletteTap() {
        viewModel.input.saveTap.send()
    }
    
    func addColorTap() {
        viewModel.input.addTaps.addColorTap.send()
    }
    
    func stayAlertTap() {
        viewModel.input.alertTaps.stayTap.send()
    }
    
    func backAlertTap() {
        viewModel.input.alertTaps.backTap.send()
    }
}

struct CreateColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateColorPaletteView(viewModel: CreateColorPaletteViewModel())
    }
}
