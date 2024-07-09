import SwiftUI
struct NewIdeaView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State var idea: Idea?

    @State private var title: String
    @State private var description: String
    @State private var selectedCategory: String?
    @State private var id: UUID
    
    @State private var selectedImage: UIImage? = nil
    @State private var isImagePickerPresented = false
    
    @FocusState private var textIsFocused: Bool

    
    init(idea: Idea?) {
        _idea = State(initialValue: idea)
        _title = State(initialValue: idea?.title ?? NSLocalizedString("example.new.title", comment: "Title"))
        _description = State(initialValue: idea?.short_description ?? NSLocalizedString("example.new.description", comment: "Description"))
        _selectedCategory = State(initialValue: idea?.category ?? "tag.personal")
        _id = State(initialValue: idea?.id ?? UUID())
        let randomImage = idea?.image != nil ? UIImage(data: idea!.image!) : nil
        _selectedImage = State(initialValue: randomImage ?? UIImage(named: "default4.jpg")!)
    }

    let categories = ["tag.personal", "tag.work", "tag.hobby", "tag.housing"]

    var body: some View {
        NavigationView {
            VStack {
                    TextField("Title", text: $title)
                        .padding()
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(12)
                        .focused($textIsFocused) // Focus state added

                    TextEditor(text: $description)
                        .padding()
                        .frame(height: 150)
                        .background(Color(UIColor.systemGray5))
                        .cornerRadius(12)
                        .scrollContentBackground(.hidden)
                        .keyboardType(.default)
                        .focused($textIsFocused) // Focus state added

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories, id: \.self) { category in
                                IdeaCategoryView(title: category, selectedCategory: $selectedCategory)
                            }
                        }
                        .padding([.leading, .trailing, .top], 10)
                    }
                    
                    Button(action: {
                        isImagePickerPresented = true
                    }) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxHeight: 200)
                                .cornerRadius(12)
                                .padding(.bottom)
                        }
                    }

                    Button(action: {
                        if idea == nil {
                            let newIdea = Idea(context: viewContext)
                            newIdea.id = UUID()
                            newIdea.created = Date()
                            idea = newIdea
                        }
                        if let unwrappedIdea = idea {
                            unwrappedIdea.title = title
                            unwrappedIdea.short_description = description
                            unwrappedIdea.category = selectedCategory
                            if let imageData = selectedImage?.jpegData(compressionQuality: 1.0) {
                                unwrappedIdea.image = imageData
                            }

                            do {
                                try viewContext.save()
                                presentationMode.wrappedValue.dismiss() // Dismiss the view after saving
                            } catch {
                                // Handle the error appropriately
                                print("Failed to save idea: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Text(LocalizedStringKey("button.save"))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                if idea != nil {
                    Button(action: {
                        if let idea = idea {
                            viewContext.delete(idea)
                            do {
                                try viewContext.save()
                                presentationMode.wrappedValue.dismiss()
                            } catch {
                                // Handle the error appropriately
                                print("Failed to delete idea: \(error.localizedDescription)")
                            }
                        }
                    }) {
                        Text(LocalizedStringKey("button.delete"))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                }
            }
            .background(Color(UIColor.systemGray6))
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $selectedImage)
            }
        }
    }
}

struct NewIdeaView_Previews: PreviewProvider {
    static var previews: some View {
        return NewIdeaView(idea: nil)
            .environment(\.managedObjectContext, PersistenceController.shared.context)
    }
}
