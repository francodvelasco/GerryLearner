import SwiftUI

@main
struct MyApp: App {
    @StateObject var viewModel = BaseViewModel()
    
    var body: some Scene {
        WindowGroup {
            GeometryReader { geom in
                BaseView(viewModel: viewModel)
                    .frame(width: geom.size.width, height: geom.size.height, alignment: .center)
                    .statusBar(hidden: true)
                    .onAppear {
                        viewModel.orientation = UIDevice.current.orientation
                    }
            }
        }
    }
}
