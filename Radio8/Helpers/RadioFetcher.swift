//
//  RadioFetcher.swift
//  Radio8
//  Created by brfsu on 24.04.2024.
//
import Foundation

class RadioFetcher: ObservableObject {
    @Published var efirs: [EfirM] = []
    @Published var isLoading = false
    private let url = URL(string: "https://de1.api.radio-browser.info/json/stations/bycodec/aac?limit=60&order=clocktrend&hidebroken=true")!
    
    func load() {
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let decoded = try? JSONDecoder().decode([EfirM].self, from: data) else {
                DispatchQueue.main.async { self.isLoading = false }
                return
            }
            DispatchQueue.main.async {
                self.efirs = decoded
                self.isLoading = false
            }
        }.resume()
    }
}
