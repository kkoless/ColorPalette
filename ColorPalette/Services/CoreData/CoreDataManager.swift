//
//  CoreDataManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.12.2022.
//

import CoreData

struct CoreDataManager {
  private let context: NSManagedObjectContext

  init() {
    self.context = PersistenceContainer.shared.viewContext
  }
}

extension CoreDataManager {
  func getColors() -> [AppColor] {
    return fetchColors().map {
      AppColor(
        name: $0.name ?? "",
        hex: $0.hex ?? "",
        alpha: $0.alpha 
      )
    }
  }

  func getPalettes() -> [ColorPalette] {
    return fetchPalettes()
      .compactMap { coreDataPalette -> ColorPalette? in
        guard let data = coreDataPalette.colors else { return nil }
        do {
          let decoder = JSONDecoder()
          let colors = try decoder.decode([AppColor].self, from: data)
          return ColorPalette(colors: colors)
        }
        catch {
          print("Unable to dencode. \(error)")
          return ColorPalette(colors: [])
        }
      }
  }
}

extension CoreDataManager {
  func addColor(_ color: AppColor) {
    let _ = toCoreDataObj(from: color)
    context.saveContext()
  }

  func removeColor(_ color: AppColor) {
    if let coreDataColor = fetchColors().first(where: { $0.hex == color.hex }) {
      context.delete(coreDataColor)
      context.saveContext()
    }
  }

  func addPalette(_ palette: ColorPalette) {
    let _ = toCoreDataObj(from: palette)
    context.saveContext()
  }

  func removePalette(_ palette: ColorPalette) {
    if let coreDataModel = fetchPalettes().first(where: { $0.colors == palette.getData() }) {
      context.delete(coreDataModel)
      context.saveContext()
    }
  }
}

private extension CoreDataManager {
  private func fetchColors() -> [AppColorModel] {
    let request = NSFetchRequest<AppColorModel>(entityName: "AppColorModel")

    do {
      return try context.fetch(request)
    } catch {
      print("Error fetching. \(error)")
      return []
    }
  }

  private func fetchPalettes() -> [ColorPaletteModel] {
    let request = NSFetchRequest<ColorPaletteModel>(entityName: "ColorPaletteModel")

    do {
      return try context.fetch(request)
    } catch {
      print("Error fetching. \(error)")
      return []
    }
  }
}

private extension CoreDataManager {
  private func toCoreDataObj(from: AppColor) -> AppColorModel {
    let to = AppColorModel(context: self.context)
    to.name = from.name
    to.hex = from.hex
    to.alpha = from.alpha
    return to
  }

  private func toCoreDataObj(from: ColorPalette) -> ColorPaletteModel {
    let to = ColorPaletteModel(context: self.context)

    do {
      let encoder = JSONEncoder()
      let data = try encoder.encode(from.colors)
      to.colors = data
    } catch {
      print("Unable to encode. \(error)")
    }

    return to
  }
}
