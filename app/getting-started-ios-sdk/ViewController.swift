//
//  ViewController.swift
//  getting-started-ios-sdk
//
//  Created by Smartcar on 11/19/18.
//  Copyright © 2018 Smartcar. All rights reserved.
//

import Alamofire
import UIKit
import SmartcarAuth
import NMAKit

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var vehicleText = ""
    var button = UIButton()
    var button2 = UIButton()
    var vechiles = [CarInfo]()
    lazy var mapView:NMAMapView! = nil
    
    // MARK:  Map  variables
    

    var coreRouter: NMACoreRouter!
    var progress: Progress? = nil
    var mapRouts = [NMAMapRoute]()
    @IBOutlet weak var searchTextFeild: UITextField!
//    let routeManager = NMARouteManager()

    
    
    func drawRoutes(route: [NMAGeoCoordinates]) {
        let routingMode = NMARoutingMode(routingType: .fastest, transportMode: .car, routingOptions: .avoidDirtRoad)
        
        
        // check if calculation completed otherwise cancel.
        if !(progress?.isFinished ?? false) {
            progress?.cancel()
        }
        coreRouter = NMACoreRouter()
        progress = coreRouter.calculateRoute(withStops: route, routingMode: routingMode, { (routeResult, error) in
            if (error != NMARoutingError.none) {
                NSLog("Error in callback: \(error)")
                return
            }
            
            guard let route = routeResult?.routes?.first else {
                print("Empty Route result")
                return
            }
            
            guard let box = route.boundingBox, let mapRoute = NMAMapRoute.init(route) else {
                print("Can't init Map Route")
                return
            }
            
            if (self.mapRouts.count != 0) {
                for route in self.mapRouts {
                    self.mapView.remove(mapObject: route)
                }
                self.mapRouts.removeAll()
            }
            
            self.mapRouts.append(mapRoute)
            
            self.mapView.set(boundingBox: box, animation: NMAMapAnimation.linear)
            self.mapView.add(mapObject: mapRoute)
        })
        
    }
    
    
    @IBAction func routeToSeattle(_ sender: Any) {
        
        let l1 = NMAGeoCoordinates(latitude: 37.787798, longitude: -122.396908)
        let l2 = NMAGeoCoordinates(latitude: 47.581813, longitude: -122.320184)
        let route = [l1,l2]
        drawRoutes(route: route)
        
    }
    
    @IBAction func routeToSeattleWithStops(_ sender: Any) {
        
        let l1 = NMAGeoCoordinates(latitude: 37.787798, longitude: -122.396908)
        let l2 = NMAGeoCoordinates(latitude: 40.576673, longitude: -122.386076)
        let l3 = NMAGeoCoordinates(latitude: 44.014842, longitude: -121.315173)
        let l4 = NMAGeoCoordinates(latitude: 45.511233, longitude: -122.682559)
        let l5 = NMAGeoCoordinates(latitude: 47.581813, longitude: -122.320184)
        let route = [l1,l2,l3,l4,l5]
        drawRoutes(route: route)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func buildButtons()  {
        
        
        
        
        
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // display a button
        button = UIButton(frame: CGRect(x: containerView.center.x , y: containerView.center.y + 5, width: view.frame.width, height: 30))
        button.addTarget(self, action: #selector(self.connectPressed(_:)), for: .touchUpInside)
        button.setTitle("Connect to the cars", for: .normal)
        button.backgroundColor = .black
        containerView.addSubview(button)
        
        button2 = UIButton(frame: CGRect(x: containerView.center.x , y: button.center.y + 20, width: view.frame.width, height: 30))
        button2.addTarget(self, action: #selector(self.informationClicked(_:)), for: .touchUpInside)
        button2.setTitle("Get car information and store in device", for: .normal)
        button2.backgroundColor = .black
        containerView.addSubview(button2)
        
        var button3 = UIButton()
        button3 = UIButton(frame: CGRect(x: containerView.center.x , y: button2.center.y + 20, width: view.frame.width, height: 30))
        button3.addTarget(self, action: #selector(self.locationPressed(_:)), for: .touchUpInside)
        button3.setTitle("Get location of cars", for: .normal)
        button3.backgroundColor = .black
        containerView.addSubview(button3)
        
        var button4 = UIButton()
        button4 = UIButton(frame: CGRect(x: containerView.center.x , y: button3.center.y + 20, width: view.frame.width , height: 30))
        button4.addTarget(self, action: #selector(self.routeToSeattle(_:)), for: .touchUpInside)
        button4.setTitle("Start Routing to Seattle", for: .normal)
        button4.backgroundColor = .blue
        containerView.addSubview(button4)
        
        
        var button5 = UIButton()
        button5 = UIButton(frame: CGRect(x: containerView.center.x , y: button4.center.y + 20, width: view.frame.width , height: 30))
        button5.addTarget(self, action: #selector(self.routeToSeattleWithStops(_:)), for: .touchUpInside)
        button5.setTitle("Route to seattle with charging stops", for: .normal)
        button5.backgroundColor = .blue
        containerView.addSubview(button5)
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        routeManager.delegate = self
        
        mapView = NMAMapView(frame: self.view.frame)
        let coordiantes = NMAGeoCoordinates(latitude: 49.260327, longitude: -123.115025)
        mapView.mapScheme = NMAMapSchemeNormalNight
        mapView.set(geoCenter: coordiantes, animation: .none)
        mapView.copyrightLogoPosition = .bottomLeft
        mapView.zoomLevel = 12
        self.view = mapView

        
        
        appDelegate.smartcar = SmartcarAuth(
            clientId: Constants.clientId,
            redirectUri: "sc\(Constants.clientId)://exchange",
            scope: ["read_vin", "read_vehicle_info", "read_odometer", "read_location", "read_charge", "read_fuel", "read_battery","control_security", "control_security:unlock", "control_security:lock"],
            testMode: true,
            completion: completion
        )
        
//        // display a button
//        button = UIButton(frame: CGRect(x: view.center.x/2, y: view.center.y, width: 250, height: 50))
//        button.addTarget(self, action: #selector(self.connectPressed(_:)), for: .touchUpInside)
//        button.setTitle("Connec to the cars", for: .normal)
//        button.backgroundColor = UIColor.black
//        self.view.addSubview(button)
//
////        let button1 = UIButton(frame: CGRect(x: view.center.x/2 , y: view.center.y + 100, width: 250, height: 50))
////        button1.addTarget(self, action: #selector(self.informationClicked(_:)), for: .touchUpInside)
////        button1.setTitle("هكر امها يلد", for: .normal)
////        button1.backgroundColor = UIColor.black
////        self.view.addSubview(button1)
////
//        button2 = UIButton(frame: CGRect(x: 0 , y: view.center.y + 300, width: 250, height: 50))
//        button2.addTarget(self, action: #selector(self.locationPressed(_:)), for: .touchUpInside)
//        button2.setTitle("get location", for: .normal)
//        button2.backgroundColor = UIColor.green
//        self.view.addSubview(button2)


//        button2 = UIButton(frame: CGRect(x: view.center.x/2, y: view.center.y + 200, width: 250, height: 50))
//        button2.addTarget(self, action: #selector(self.tesla(_:)), for: .touchUpInside)
//        button2.setTitle("افتح التسلا يلد", for: .normal)
//        button2.backgroundColor = UIColor.black
//        self.view.addSubview(button2)
//
//        let button1 = UIButton(frame: CGRect(x: view.center.x/2 , y: view.center.y + 100, width: 250, height: 50))
//        button1.addTarget(self, action: #selector(self.informationClicked(_:)), for: .touchUpInside)
//        button1.setTitle("get information", for: .normal)
//        button1.backgroundColor = UIColor.black
//        self.view.addSubview(button1)
//
//        let button2 = UIButton(frame: CGRect(x: view.center.x/2 , y: view.center.y + 300, width: 250, height: 50))
//        button2.addTarget(self, action: #selector(self.locationPressed(_:)), for: .touchUpInside)
//        button2.setTitle("get location", for: .normal)
//        button2.backgroundColor = UIColor.black
//        self.view.addSubview(button2)
        



buildButtons()

    }
//    @IBAction func tesla(_ sender: UIButton) {
//        let smartcar = appDelegate.smartcar!
//
//        if isOpen {
//
//
////            Alamofire.request(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
//
//
//
//            Alamofire.request("\(Constants.appServer)/bf2ea914-10e1-4913-ae58-d5efd5ab3776/security",method: .post,parameters: ["action":"LOCK"]).responseString { res in
//                print(res)
////                self.isOpen = false
//            }
////            Alamofire.request("\(Constants.appServer)/bf2ea914-10e1-4913-ae58-d5efd5ab3776/security",method: .post).responseJSON { res in
////             }
//        }else{
////            Alamofire.request("\(Constants.appServer)/bf2ea914-10e1-4913-ae58-d5efd5ab3776/security",method: .post).responseJSON { res in
////                print(res)
////                self.isOpen = true
////            }
//
//            Alamofire.request("\(Constants.appServer)/bf2ea914-10e1-4913-ae58-d5efd5ab3776/security",method: .post,parameters: ["action":"UNLOCK"]).responseString { res in
//                print(res)
//            }
//        }
//        isOpen = !isOpen
//
//        print(isOpen)
//
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectPressed(_ sender: UIButton) {
        let smartcar = appDelegate.smartcar!
        smartcar.launchAuthFlow(viewController: self)
        
    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        for car in vechiles {
           print(car.id)
            Alamofire.request("\(Constants.appServer)/\(car.id)/location",method: .get).responseJSON { res in
                
               if res.result.isSuccess{
                if let result = res.result.value {
                    
                    let JSON = result as! NSDictionary
                    print(JSON.value(forKey: "data"))
                    
//                        .forEach({ (car) in
//                        print(JSON as! [String:[String:String]])
                    
                        
                

//                    print(car["longitude"] as! [String:String])
                    
//                    let l = car["data"]["latitude"]! as! String
//                    let l = car.object(forKey: "make")!  as! String
//                    let model = car.object(forKey: "model")!  as! String
//                    let year = car.object(forKey: "year")!  as! Int
//                    let id = car.object(forKey: "id")! as! String
                    //                        let newCar = VehicleInfo(vin: vin, make: make, year: year, model: model)
//                    let newCar = CarInfo(id: id)
//                    self.vechiles.append(newCar)
                    
//                })
                
                }
                
                }
                
            }
        }
        
        
    }
        
    @IBAction func informationClicked(_ sender: UIButton) {
            
        Alamofire.request("\(Constants.appServer)/allcars",method: .get).responseJSON { res in
            if res.result.isSuccess{
                if let result = res.result.value {
                    print(result)
                    let JSON = result as! [NSDictionary]
//                    print(JSON)
                    
                    JSON.forEach({ (car) in
                        
                        let make = car.object(forKey: "make")!  as! String
                        let model = car.object(forKey: "model")!  as! String
                        let year = car.object(forKey: "year")!  as! Int
                        let id = car.object(forKey: "id")! as! String
//                        let newCar = VehicleInfo(vin: vin, make: make, year: year, model: model)
                        let newCar = CarInfo(id: id)
                        self.vechiles.append(newCar)
                        
                    })
                    
//                    let make = JSON.object(forKey: "make")!  as! String
//                    let model = JSON.object(forKey: "model")!  as! String
//                    let year = String(JSON.object(forKey: "year")!  as! Int)
//                    let vehicle = "\(year) \(make) \(model)"
                    
                    self.vehicleText = String(describing: self.vechiles)
                    
//                    self.performSegue(withIdentifier: "displayVehicleInfo", sender: self)
                }
            }
            
        }
        
    }
    
    func getCarinformation() {
        Alamofire.request("\(Constants.appServer)/allcars",method: .get).responseJSON { res in
            if res.result.isSuccess{
                if let result = res.result.value {
                    print(result)
                    let JSON = result as! [NSDictionary]
                    //                    print(JSON)
                    
                    JSON.forEach({ (car) in
                        
                        let make = car.object(forKey: "make")!  as! String
                        let model = car.object(forKey: "model")!  as! String
                        let year = car.object(forKey: "year")!  as! Int
                        let id = car.object(forKey: "id")! as! String
                        //                        let newCar = VehicleInfo(vin: vin, make: make, year: year, model: model)
                        let newCar = CarInfo(id: id)
                        self.vechiles.append(newCar)
                        
                    })
                    
                    //                    let make = JSON.object(forKey: "make")!  as! String
                    //                    let model = JSON.object(forKey: "model")!  as! String
                    //                    let year = String(JSON.object(forKey: "year")!  as! Int)
                    //                    let vehicle = "\(year) \(make) \(model)"
                    
                    self.vehicleText = String(describing: self.vechiles)
                    
                    //                    self.performSegue(withIdentifier: "displayVehicleInfo", sender: self)
                }
            }
            
        }
    }
    
    
    func completion(err: Error?, code: String?, state: String?) -> Any {
        // send request to exchange auth code for access token

        print(code)
        
        
        
        Alamofire.request("\(Constants.appServer)/exchange?code=\(code!)", method: .get).responseJSON {_ in
            
//            self.getCarinformation()
        }

        
//
//
//            self.getCarinformation()
//
////            print("\n\n\n\nresponse: \(res.result.value)")
//////            // TODO: Request Step 2: Get vehicle information
//////            // send request to retrieve the vehicle info
////            Alamofire.request("\(Constants.appServer)/location", method: .get).responseJSON { response in
////                print(response.result)
////
////                if let result = response.result.value {
////                    let JSON = result as! NSDictionary
////                    print(JSON)
////
////                    let make = JSON.object(forKey: "make")!  as! String
////                    let model = JSON.object(forKey: "model")!  as! String
////                    let year = String(JSON.object(forKey: "year")!  as! Int)
////
////                    let vehicle = "\(year) \(make) \(model)"
////                    self.vehicleText = vehicle
////
////                    self.performSegue(withIdentifier: "displayVehicleInfo", sender: self)
////                }
////            }
//        }
        
        
//        Alamofire.request("\(Constants.appServer)/exchange?code=\(code!)", method: .get).responseJSON {_ in
//
//            // send request to retrieve the vehicle info
//            Alamofire.request("\(Constants.appServer)/vehicle", method: .get).responseJSON { response in
//                print(response.result.value)
//
//                if let result = response.result.value {
//                    let JSON = result as! NSDictionary
//
//
//                    let make = JSON.object(forKey: "make")!  as! String
//                    let model = JSON.object(forKey: "model")!  as! String
//                    let year = String(JSON.object(forKey: "year")!  as! Int)
//
//                    let vehicle = "\(year) \(make) \(model)"
//
//
//
//                    self.vehicleText = vehicle
//                    print(self.vehicleText)
//
                    self.performSegue(withIdentifier: "displayVehicleInfo", sender: self)
////                    self.perfoseg
//                }
//            }
//        }
//
        return ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? InfoViewController {
            destinationVC.text = self.vehicleText
        }
    }

}


//extension UIViewController: NMARouteManagerDelegate,NMAMapViewDelegate,NMAMapGestureDelegate
//{
//    public func routeManagerDidCalculate(_ routeManager: NMARouteManager, routes: [NMARoute]?, error: NMARouteManagerError, violatedOptions: [NSNumber]?) {
//
//
//        if error == nil && (routes != nil) && routes!.count > 0 {
//            let route = routes?.startIndex
////            let mapRoute = routeManager.calculateRoute(stops: route)
//            let mapRoute = NMAMapRoute.
//
//
//        }
//
//
////        if (!error && routes && routes.count > 0)
////        {
////            routes[0]
////            NMARoute* route = [routes objectAtIndex:0];
////            // Render the route on the map
////            NMAMapRoute *mapRoute = [NMAMapRoute mapRouteWithRoute:route];
////            [mapView addMapObject:mapRoute];
////        }
////        else if (error)
////        {
////            // Display a message indicating route calculation failure
////        }
////    }
//
//
//}
//}
