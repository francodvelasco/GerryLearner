import SwiftUI

struct TitleView: View {
    @State var orientation: UIDeviceOrientation = .unknown
    
    var body: some View {
        VStack(alignment: .center, spacing: 0.1) {
            Spacer()
            VStack(alignment: .leading, spacing: 0) {
                Text("Let's Explore")
                    .font(.system(size: 56))
                Group {
                    Text("Gerry")
                        .foregroundColor(.blue)
                        .fontWeight(.bold) +
                    Text("mandering")
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                }
                    .font(.system(size: 72))
            }
            Spacer()
            Button(action: {
                
            }) {
                HStack {
                    Text("Explore!")
                        .fontWeight(.medium)
                    Image(systemName: "arrow.right")
                }
                .font(.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            Spacer()
            if !orientation.isLandscape {
                HStack {
                    Image(systemName: "lightbulb.fill")
                    Text("This app is best experienced with an iPad in landscape!")
                }
                .font(.title2)
                .padding(8)
                .background(Color.yellow)
                .foregroundColor(.black)
                .cornerRadius(8)
                .animation(.easeInOut, value: 1)
                .transition(.move(edge: .bottom))
            }
        }
        .padding()
        .onRotate { newOrientation in
            self.orientation = newOrientation
        }
    }
}
