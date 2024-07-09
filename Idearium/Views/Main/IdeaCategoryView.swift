import SwiftUI

struct IdeaCategoryView: View {
    let title: String
    @Binding var selectedCategory: String?


    var body: some View {
        Text(LocalizedStringKey(title))
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(selectedCategory == title ? Color.blue : Color.gray.opacity(0.2))
            .cornerRadius(16)
            .onTapGesture {
                selectedCategory = title
            }
    }
}
