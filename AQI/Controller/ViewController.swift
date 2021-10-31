//
//  ViewController.swift
//  AQI
//
//  Created by Jai Mataji on 30/10/21.
//

import UIKit
import Charts

class ViewController: UIViewController {
    
    
    //MARK: Outlets
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var aqiTableView: UITableView!
    
    //MARK: Popup View
    @IBOutlet weak var chartPopupView: UIView!
    @IBOutlet weak var indexStatusLabel: UILabel!
    @IBOutlet weak var indexStatusImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var currentAQILabel: UILabel!
    @IBOutlet weak var indexBackView: UIView!
    @IBOutlet weak var infoBackView: UIView!
    @IBOutlet weak var lastUpdateOnLabel: UILabel!
    @IBOutlet weak var closeButon: UIButton!
    
    var aqiData = [String:AQIViewModel]()
    var graphData = [Double:Double]()
    var selectedCity = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAQIData()
        updateViewOnViewload()
    }
    
    func getAQIData(){
        Service.sharedInstance.startAQISocket { aqis, error in
            if error == nil{
                if let aqisData = aqis{
                    for aqi in aqisData{
                        let detailData = self.getSetingForAQI(aqi: aqi.aqi ?? 0.0)
                        
                        let aqiViewModel = AQIViewModel(aqiData: aqi, timestamp: Date().timeIntervalSince1970, aqiColor: detailData.color, titleStr: detailData.title, imageStr: detailData.image)
                        self.aqiData.updateValue( aqiViewModel, forKey: aqi.city ?? "")
                        
                        //check if any city selected & check if difference is 30 seconds i.e. 1800 
                        if self.selectedCity == aqi.city ?? "" {
                            if self.graphData.count == 0 || (Date().timeIntervalSince1970 - Array(self.graphData.keys).max()! >= 1800){
                                self.graphData.updateValue(aqi.aqi ?? 0.0, forKey: Date().timeIntervalSince1970.round(to: 0))
                            }
                            //Once data is available update chart and popupview
                            self.updatePopupView(data:aqiViewModel)
                            self.updateGraph()
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.aqiTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func closeButonClicked(_ sender: Any) {
        UIView.transition(with: chartPopupView, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.chartPopupView.isHidden = true
        })
        selectedCity = ""
        chartView.clear()
        graphData.removeAll()
    }
}

//MARK: TableView datasource and  delegates
extension ViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aqiData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AQITableViewCell
        let data = aqiData[Array(aqiData.keys).sorted()[indexPath.row]]
        
        cell.cityLabel.text = data?.city ?? ""
        cell.cityCountryLabel.text = "\(data?.city ?? ""), India"
        cell.currentAQILabel.text = "\(data?.aqi?.round(to: 2) ?? 0)"
        cell.lastUpdateOnLabel.text =  Date(timeIntervalSince1970: (data?.timestamp)!).timeAgoSinceDate()
        
        cell.indexStatusLabel.text = data?.titleStr ?? ""
        cell.indexStatusImageView.image = UIImage(named: data?.imageStr ?? "")
        cell.infoBackView.backgroundColor = UIColor.init(hex: data?.aqiColor ?? "")
        cell.indexBackView.backgroundColor = UIColor.init(hex: data?.aqiColor ?? "")
        
        cell.infoBackView.addRadius(brRadius: 10)
        cell.indexBackView.addRadius(brRadius: 10)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCity = Array(aqiData.keys).sorted()[indexPath.row]
        //on city selection  open popupview and load data
        
        UIView.transition(with: chartPopupView, duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: {
            self.chartPopupView.isHidden = false
        })
        updatePopupView(data:  aqiData[Array(aqiData.keys).sorted()[indexPath.row]]!)
    }
}

//MARK: Utility functions
extension ViewController{
    
    func updateViewOnViewload(){
        chartPopupView.isHidden = true
        infoBackView.addRadius(brRadius: 10)
        indexBackView.addRadius(brRadius: 10)
    }
    
    func updatePopupView(data:  AQIViewModel){
        cityLabel.text = selectedCity
        
        cityCountryLabel.text = "\(selectedCity ), India"
        currentAQILabel.text = "\(data.aqi?.round(to: 2) ?? 0)"
        lastUpdateOnLabel.text =  Date(timeIntervalSince1970: (data.timestamp)!).timeAgoSinceDate()
        
        indexStatusLabel.text = data.titleStr ?? ""
        indexStatusImageView.image = UIImage(named: data.imageStr ?? "")
        infoBackView.backgroundColor = UIColor.init(hex: data.aqiColor ?? "")
        indexBackView.backgroundColor = UIColor.init(hex: data.aqiColor ?? "")
    }
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]()
        
        let datakeys = Array(graphData.keys).sorted()
        for i in 0..<datakeys.count {
            let value = ChartDataEntry(x: datakeys[i], y: graphData[datakeys[i]]!) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        // hide grid lines
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.enabled = false
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "AQI") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.black] //Sets the colour to blue
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        chartView.data = data //finally - it adds the chart data to the chart and causes an
        
        chartView.chartDescription?.text = "Realtime AQI for city: \(selectedCity)" // Here we set the description for the graph
        chartView.xAxis.valueFormatter = XAxisNameFormater()
        
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.granularity = 1
    }
    
    func getSetingForAQI(aqi:Double)->(color:String, title:String, image: String){
        var color = "#55a951"
        var title = "NA"
        var image = "0-50.png"
        switch (aqi.round(to: 2) ){
        case 0..<51:
            title = "Good"
            image = "0-50.png"
            color = "#55a951"
            break
        case 51..<101:
            title = "Satisfactory"
            image = "51-100.png"
            color =  "#a3c852"
            break
        case 101..<201:
            title = "Moderate"
            image = "101-300.png"
            color =  "#fef932"
            break
        case 201..<301:
            title = "Poor"
            image = "101-300.png"
            color =  "#f29d33"
            break
        case 301..<401:
            title = "Very Poor"
            image = "301-500.png"
            color = "#e93f35"
            break
        case 401..<501:
            title = "Severe"
            image = "301-500.png"
            color = "#af2c25"
            break
        default:
            print("nothing")
        }
        return (color:color, title:title, image: image)
    }
}


