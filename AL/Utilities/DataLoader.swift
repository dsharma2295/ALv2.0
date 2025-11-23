import Foundation

class DataLoader {
    static let shared = DataLoader()
    
    var agencies: [Agency] = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "agencies", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self.agencies = try decoder.decode([Agency].self, from: data)
            print("Successfully loaded \(agencies.count) agencies")
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    func getAgencies(category: AgencyCategory) -> [Agency] {
        return agencies.filter { $0.category == category }
    }
    
    func getTrafficAgency(state: String) -> Agency? {
        return agencies.first { $0.category == .traffic && $0.state == state }
    }
}
