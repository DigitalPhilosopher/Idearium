import Foundation
import CoreData
import PhotosUI

class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Ideas") // Use your data model name
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func addInitialData() {
        let context = container.viewContext

        // Check if initial data has already been added
        let fetchRequest: NSFetchRequest<Idea> = Idea.fetchRequest()
        let count = (try? context.count(for: fetchRequest)) ?? 0
        if count == 0 {
            // Add initial data here
            let newItem = Idea(context: context)
            newItem.title = NSLocalizedString("example.1.title", comment: "Title")
            newItem.short_description = NSLocalizedString("example.1.description", comment: "Description")
            newItem.category = "tag.personal"
            if let image = UIImage(named: "default1.jpg") {
                newItem.image = image.pngData() // Convert UIImage to Data
            }
            
            
            // Add initial data here
            let hobbyItem = Idea(context: context)
            hobbyItem.title = NSLocalizedString("example.2.title", comment: "Title")
            hobbyItem.short_description = NSLocalizedString("example.2.description", comment: "Description")
            hobbyItem.category = "tag.work"
            if let image = UIImage(named: "default2.jpg") {
                hobbyItem.image = image.pngData() // Convert UIImage to Data
            }
            
            // Add initial data here
            let personalItem = Idea(context: context)
            personalItem.title = NSLocalizedString("example.3.title", comment: "Title")
            personalItem.short_description = NSLocalizedString("example.3.description", comment: "Description")
            personalItem.category = "tag.hobby"
            if let image = UIImage(named: "default3.jpg") {
                personalItem.image = image.pngData() // Convert UIImage to Data
            }

            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}
