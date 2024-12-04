//
//  MoonWebViewController.swift
//  Moon
//
//  Created by Dari Dennis on 12/2/24.
//

import Foundation
import UIKit
import WebKit
import SwiftUI

class MoonWebViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://moon.nasa.gov/moon-observation/daily-moon-guide/?intent=021")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}

struct MoonWebView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MoonWebViewController {
        return MoonWebViewController()
    }
    func updateUIViewController(_ uiViewController: MoonWebViewController, context: Context) {}
}

struct MoonWebView_Previews: PreviewProvider {
    static var previews: some View {
        MoonWebView()
            .edgesIgnoringSafeArea(.all) // Optional: Extend to full screen
    }
}

