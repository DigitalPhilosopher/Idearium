import SwiftUI

struct IdeaCardView: View {
    let category: String
    let title: String
    let description: String
    let image: UIImage?

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(LocalizedStringKey(category))
                        .font(.system(size: 14))
                        .foregroundColor(Color.textColor)
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(Color.textColor)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                }
                .padding()
                
                Spacer()

                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipped()
                        .cornerRadius(8)
                        .padding([.trailing])
                } else {
                    Color.gray.opacity(0.2)
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                        .padding([.trailing])
                }
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

        }
        .padding(.horizontal)
    }
}
