//
//  OutdoorDutyLogListViewController.swift
//  WrkplanPayroll
//
//  Created by SATABHISHA ROY on 30/03/21.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class OutdoorDutyLogListViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var view_start_stop: UIView!
    @IBOutlet weak var img_start_stop: UIImageView!
    @IBOutlet weak var label_start_stop: UILabel!
    
    @IBOutlet weak var view_pause: UIView!
    
    @IBOutlet weak var label_todays_od_duty: UILabel!
    @IBOutlet weak var label_date: UILabel!
    
    @IBOutlet weak var view_border_line: UIView!
    var locationManager:CLLocationManager!
    
    let swiftyJsonvar1 = JSON(UserSingletonModel.sharedInstance.employeeJson!)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        determineMyCurrentLocation()
        // Do any additional setup after loading the view.
        check_od_duty_log_status()
    }
  
    //-------Location, code starts
    func determineMyCurrentLocation() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
                //locationManager.startUpdatingHeading()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let userLocation:CLLocation = locations[0] as CLLocation
            
            // Call stopUpdatingLocation() to stop listening for location updates,
            // other wise this function will be called every time when user location changes.
            
           // manager.stopUpdatingLocation()
            
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
            getAddressFromLatLon(pdblLatitude: userLocation.coordinate.latitude, withLongitude: userLocation.coordinate.longitude)
//            print("user Address = \(userLocation.)")
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
        {
            print("Error \(error)")
        }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double) {
            var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
            let lat: Double = Double("\(pdblLatitude)")!
            //21.228124
            let lon: Double = Double("\(pdblLongitude)")!
            //72.833770
            let ceo: CLGeocoder = CLGeocoder()
            center.latitude = lat
            center.longitude = lon

            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                       /* print(pm.country)
                        print(pm.locality)
                        print(pm.subLocality)
                        print(pm.thoroughfare)
                        print(pm.postalCode)
                        print(pm.subThoroughfare) */
                        var addressString : String = ""
                        if pm.subThoroughfare != nil {
                            addressString = addressString + pm.subThoroughfare! + ", "
                        }
                        if pm.subLocality != nil {
                            addressString = addressString + pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            addressString = addressString + pm.locality! + ", "
                        }
                        if pm.country != nil {
                            addressString = addressString + pm.country! + ", "
                        }
                        if pm.postalCode != nil {
                            addressString = addressString + pm.postalCode! + " "
                        }


                        print("Address-=>",addressString)
                  }
            })

        }
    //-------Location code ends

    //----function to get data to check od_duty_status from api using Alamofire and Swiftyjson to load data,code starts-----
    func check_od_duty_log_status(){
//           loaderStart()
        
        let url = "\(BASE_URL)od/request/check-exist/\(swiftyJsonvar1["company"]["corporate_id"].stringValue)/\(swiftyJsonvar1["employee"]["employee_id"].stringValue)/"
        print("odDutylisturl-=>",url)
           AF.request(url).responseJSON{ (responseData) -> Void in
//               self.loaderEnd()
               if((responseData.value) != nil){
                   let swiftyJsonVar=JSON(responseData.value!)
                   print("Log description: \(swiftyJsonVar)")
                
                
                
                   if let resData = swiftyJsonVar["request_list"].arrayObject{
//                       self.arrRes = resData as! [[String:AnyObject]]
                   }
                if swiftyJsonVar["status"] == "true"{
//                    self.info_img.isHidden = false
                    if swiftyJsonVar["next_action"] == "START"{
                        self.view_start_stop.backgroundColor = UIColor(hexFromString: "#dce9ab")
                        self.view_pause.isHidden = true
                        self.label_start_stop.text = "START"
//                        self.img_start_stop.image =
                    }else if swiftyJsonVar["next_action"] == "PAUSE"{
                        self.view_start_stop.backgroundColor = UIColor(hexFromString: "#febbaf")
                        self.img_start_stop.image = UIImage(named: "od_stop")
                        self.label_start_stop.text = "STOP"
                        self.view_pause.isHidden = false
                    }else if swiftyJsonVar["next_action"] == "STOP"{
                        self.view_start_stop.backgroundColor = UIColor(hexFromString: "#febbaf")
                        self.img_start_stop.image = UIImage(named: "od_stop")
                        self.label_start_stop.text = "STOP"
                        self.view_pause.isHidden = false
                    }else if swiftyJsonVar["next_action"] == "NA"{
                        self.view_pause.isHidden = true
                        self.view_start_stop.isHidden = true
                        self.label_date.isHidden = true
                        self.label_todays_od_duty.isHidden = true
                        self.view_border_line.isHidden = true
                    }
                }else if swiftyJsonVar["status"] == "false"{
                    self.view_pause.isHidden = true
                    self.view_start_stop.isHidden = true
                    self.label_date.isHidden = true
                    self.label_todays_od_duty.isHidden = true
                    self.view_border_line.isHidden = true
                }
                 
               }
               
           }
       }
    //----function to get data to check od_duty_status from api using Alamofire and Swiftyjson to load data,code ends-----
}
