
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    //MARK: - Here we appointed a delegate of coinManager and currencyPicker to ViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.delegate = self
    }
  
}
//MARK: - Here we use UIPickerViewDataSource delegate to specify how many picker should be and how many rows in this pickers should be.

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
}

//MARK: - Here we use UIPickerViewDelegate to set on what the text shold be on this rows and in func didSelectRow we send the curent currency that user select to the func getCoinPrice in CoinManager struct.
extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: currency)
    }
 
}

//MARK: - Here we use CoinManagerDelegate protocol that we create in CoinManager file to grab the data about cost bitcoin for curent currency from input bitcoin.

extension ViewController: CoinManagerDelegate {
    
    func didUpdateBitcoin(_ coinManager: CoinManager, bitcoin: ModelBTC) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = bitcoin.btcWithTwoDecimal
            self.currencyLabel.text = bitcoin.currencyNow
        }
    }
 
    func didFailError(error: Error) {
        print(error)
    }
}
