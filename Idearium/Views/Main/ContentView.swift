import SwiftUI

struct ContentView: View {
    @State private var showNewIdeaView = false
    @State private var selectedCategory: String? = "tag.all"
    @State private var searchText = ""
    @State private var isSearching = false
    
    @FetchRequest(
        entity: Idea.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Idea.created, ascending: false)]
    ) var ideas: FetchedResults<Idea>

    let categories = ["tag.personal", "tag.work", "tag.hobby", "tag.housing"]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text(LocalizedStringKey("title"))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: {
                        isSearching.toggle()
                        if (!isSearching) {
                            searchText = ""
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }
                    .frame(width: 48, height: 48)
                    
                    Button(action: {
                        showNewIdeaView.toggle()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                    }
                    .frame(width: 24, height: 24)
                    .background(Color.green)
                    .cornerRadius(24)
                    
                    NavigationLink(destination: NewIdeaView(idea: nil), isActive: $showNewIdeaView) {
                        EmptyView()
                    }
                }
                .padding()

                if isSearching {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .trailing], 10)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        IdeaCategoryView(title: "tag.all", selectedCategory: $selectedCategory)
                        ForEach(categories, id: \.self) { category in
                            IdeaCategoryView(title: category, selectedCategory: $selectedCategory)
                        }
                    }
                    .padding([.leading, .trailing, .top], 10)
                }

                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(ideas.filter { idea in
                            (selectedCategory == idea.category || selectedCategory == "tag.all") &&
                            (searchText.isEmpty ||
                             idea.title?.localizedCaseInsensitiveContains(searchText) == true ||
                             idea.short_description?.localizedCaseInsensitiveContains(searchText) == true)
                        }, id: \.self) { idea in
                            NavigationLink(
                                destination: NewIdeaView(idea: idea),
                                label: {
                                    IdeaCardView(
                                        category: idea.category ?? "Unknown",
                                        title: idea.title ?? "No Title",
                                        description: idea.short_description ?? "No Description",
                                        image: idea.image != nil ? UIImage(data: idea.image!) : nil
                                    )
                                }
                            )
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
