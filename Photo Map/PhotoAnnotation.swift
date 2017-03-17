//
//  PhotoAnnotation.swift
//  Photo Map
//
//  Created by Jose Guerrero on 3/17/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var photo: UIImage
    
    init(title:String, coordinate: CLLocationCoordinate2D, photo: UIImage){
        
        
        self.coordinate = coordinate
        self.title = title
        self.photo = photo
    }
}
