import Foundation
import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        // Create 5 sample ideas
        for i in 1...5 {
            let newIdea = Idea(context: context)
            newIdea.title = "Sample Idea \(i)"
            newIdea.short_description = "This is a description for sample idea \(i)"
            newIdea.category = ["tag.personal", "tag.work", "tag.hobby", "tag.housing"].randomElement()
            newIdea.created = Date()
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Error creating preview data: \(error.localizedDescription)")
        }
        
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Ideas") // Use your data model name
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
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
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
