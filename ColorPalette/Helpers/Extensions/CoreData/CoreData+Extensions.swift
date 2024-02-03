//
//  CoreData+Extensions.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.12.2022.
//

import CoreData

extension NSManagedObjectContext {
  func saveContext (){
    if self.hasChanges {
      do {
        try self.save()
      }
      catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
}
