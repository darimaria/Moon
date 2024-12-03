import Foundation

class MoonHelper: ObservableObject {
    @Published var moonPhase: MoonPhase?
    @Published var sun: Sun?
    
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
    
    func fetchMoonData(lat: Double, lon: Double, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = moonURL(lat: lat, lon: lon) else {
            completion(.failure(NSError(domain: "MoonHelper", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("moon-phase.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.setValue(Keys.apikey, forHTTPHeaderField: "X-RapidAPI-Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(NSError(domain: "MoonHelper", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            do {
                // Decode the response
                let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.moonPhase = decodedResponse.moon
                    self.sun = decodedResponse.sun
                }
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct APIResponse: Decodable {
    let moon: MoonPhase
    let sun: Sun
}
