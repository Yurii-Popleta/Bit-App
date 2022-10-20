
import Foundation

struct ModelBTC {
    
    let btcCost: Double
    let currencyNow: String
    
    //MARK: - Seting this btcCost into btcWithTwoDecimal by computed propertie.
    
    var btcWithTwoDecimal: String {
        return String(format: "%.2f", btcCost)
    }
    
}
