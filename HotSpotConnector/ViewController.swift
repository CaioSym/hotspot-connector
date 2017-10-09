//
//  ViewController.swift
//  HotSpotConnector
//
//  Created by Caio Freitas Sym on 09/10/17.
//  Copyright © 2017 The Climate Corporation. All rights reserved.
//

import UIKit
import NetworkExtension

fileprivate let hotspotSSID = "ReplaceMe"
fileprivate let hotspotPassword = "ReplaceMe"
fileprivate let pingURL = URL(string: "https://api.github.com")!

class ViewController: UIViewController {

    @IBOutlet weak var resultOutputLabel: UILabel!
    
    func updateStatus(_ text: String) {
        DispatchQueue.main.async {
            self.resultOutputLabel.text = text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateStatus("Attempting to join...")
        let configuration = NEHotspotConfiguration.init(ssid: hotspotSSID,
                                                        passphrase: hotspotPassword,
                                                        isWEP: false)
        configuration.joinOnce = true
        
        NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
            if let error = error {
                self.updateStatus("got error \(error.localizedDescription)")
            }
            else {
                self.updateStatus("Joined \(hotspotSSID)... Sending request")
                let request = URLRequest(url: pingURL)
                URLSession.shared.dataTask(with: request){ (data, response, error) in
                    if let error = error {
                        self.updateStatus("got an error: \(error.localizedDescription)")
                    } else if let data = data,
                        let text = String(data: data, encoding: .utf8){
                        self.updateStatus("data was: \(text)")
                    } else {
                        self.updateStatus("Something totally unexpected happened.")
                    }
                }.resume()
                //success
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

