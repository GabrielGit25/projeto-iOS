import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Olá, AltStore!")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.black)

                Text("Este app foi instalado sem conta de desenvolvedor da Apple.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}