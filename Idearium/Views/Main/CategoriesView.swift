import SwiftUI
import CoreData

struct CategoriesView: View {
    let categories = ["tag.personal", "tag.work", "tag.hobby", "tag.housing"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { category in
                    NavigationLink(destination: CategoryDetailView(category: category)) {
                        Text(LocalizedStringKey(category))
                    }
                }
            }
            .navigationTitle("Categories")
        }
    }
}

struct CategoryDetailView: View {
    let category: String
    
    @FetchRequest var ideas: FetchedResults<Idea>
    
    init(category: String) {
        self.category = category
        _ideas = FetchRequest(
            entity: Idea.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Idea.created, ascending: false)],
            predicate: NSPredicate(format: "category == %@", category)
        )
    }
    
    var body: some View {
        List {
            ForEach(ideas, id: \.self) { idea in
                NavigationLink(destination: NewIdeaView(idea: idea)) {
                    Text(idea.title ?? "Untitled")
                }
            }
        }
        .navigationTitle(LocalizedStringKey(category))
    }
}

struct Categories_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
