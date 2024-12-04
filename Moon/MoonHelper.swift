import Foundation

class MoonHelper: ObservableObject {
    @Published var moonPhase: MoonPhase?
    @Published var sun: Sun?
    @Published var zodiac: Zodiac?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // Local storage for JSON
    private let jsonKey = "storedMoonData"

    init() {
        loadStoredData()
    }

    private func loadStoredData() {
        guard let jsonString = UserDefaults.standard.string(forKey: jsonKey) else {
            // No stored data; make the API call
            fetchMoonData(lat: 51.5, lon: 0.0) { result in
                switch result {
                case .success:
                    print("Data fetched and stored successfully.")
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
            return
        }

        // Decode stored JSON
        if let data = jsonString.data(using: .utf8) {
            decodeJSON(data: data)
        }
    }

    func fetchMoonData(lat: Double, lon: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = moonURL(lat: lat, lon: lon) else {
            completion(.failure(NSError(domain: "MoonHelper", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("moon-phase.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.setValue(Keys.apikey, forHTTPHeaderField: "X-RapidAPI-Key")

        isLoading = true

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NSError(domain: "MoonHelper", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }

            // Store JSON response in UserDefaults
            if let jsonString = String(data: data, encoding: .utf8) {
                UserDefaults.standard.set(jsonString, forKey: self.jsonKey)
            }

            // Decode the response
            self.decodeJSON(data: data)
            completion(.success(()))
        }.resume()
    }

    private func decodeJSON(data: Data) {
        do {
            let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            DispatchQueue.main.async {
                self.moonPhase = decodedResponse.moon
                self.sun = decodedResponse.sun
                self.zodiac = decodedResponse.moon.zodiac
            }
        } catch {
            print("Decoding Error: \(error.localizedDescription)")
        }
    }

    private func moonURL(lat: Double, lon: Double, language: String = "en") -> URL? {
        let baseURL = "https://moon-phase.p.rapidapi.com/advanced"
        let params = [
            "apikey": Keys.apikey,
            "lat": lat.description,
            "lon": lon.description,
            "language": language
        ]

        guard var components = URLComponents(string: baseURL) else {
            print("Invalid base URL")
            return nil
        }
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url
    }
}


struct APIResponse: Decodable {
    let moon: MoonPhase
    let sun: Sun
//    let zodiac: Zodiac
}
