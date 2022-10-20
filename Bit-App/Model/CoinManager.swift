
import Foundation

//MARK: - Here we create a delegate protocol to send a data to the ViewController

protocol CoinManagerDelegate {
    func didUpdateBitcoin(_ coinManager: CoinManager, bitcoin: ModelBTC)
    func didFailError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A9B2BDFB-DDB2-4C66-A91E-03C71B9550E8"
    
    //MARK: - Here we create a url that we use in func performRequest
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    //MARK: - Creating a url session and send this data in JSON format to parseJSON func and use this func parseJSON with output in deleget func didUpdateBitcoin.
    
    func performRequest(with urlString: String){
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    self.delegate?.didFailError(error: error!)
                    return
                }
                if let safeData = data {
                    if let finalBtc = self.parseJSON(safeData) {
                        self.delegate?.didUpdateBitcoin(self, bitcoin: finalBtc)
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - Decoding data from JSON format to BitcoinData struct, and then put this data from this struct to ModelBTC struct and put this in output this parseJSON func
    
    func parseJSON(_ bitcoinSafeData: Data) -> ModelBTC? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(BitcoinData.self, from: bitcoinSafeData)
            let btcCostInNumbers = decodedData.rate
            let currencyData = decodedData.asset_id_quote
            
            let btc = ModelBTC(btcCost: btcCostInNumbers, currencyNow: currencyData)
            return btc
            
        } catch {
            print(error)
            return nil
        }
    }
    
}
