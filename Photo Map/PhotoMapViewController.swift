//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Jose Guerrero on 3/16/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    private var photoTaken: UIImage! // holds user image after selection of photo in photo picker or camera.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.1, 0.1))
        self.mapView.setRegion(sfRegion, animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // get image chosen from imagepickercontroller
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        photoTaken = editedImage
        
        // Dismiss UIImagePickerController to go back to this view controller
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "fullImageSegue", sender: view)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "myAnnotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if !(annotationView != nil) {
            annotationView = MKAnnotationView(annotation:annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            
            
            let resizeRenderImageView = UIImageView(frame: CGRect(x:0, y:0, width:45, height:45))
            resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
            resizeRenderImageView.layer.borderWidth = 3.0
            resizeRenderImageView.contentMode = .scaleAspectFill
            resizeRenderImageView.image = (annotation as! PhotoAnnotation).photo
            
            UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
            resizeRenderImageView.layer.render(in:UIGraphicsGetCurrentContext()!)
            let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView?.image = thumbnail
            
            annotationView?.leftCalloutAccessoryView = resizeRenderImageView
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        }
        
        return annotationView
    }
    
    
    @IBAction func onTapCamera(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            vc.sourceType = UIImagePickerControllerSourceType.camera
        }
        else{
            vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func locationsPickedLocation(_ locationsViewController: LocationsViewController!, latitude: NSNumber!, longitude: NSNumber!) {
        locationsViewController.navigationController?.popToViewController(self, animated: true)
        let annotation = PhotoAnnotation(title: "\(latitude!)", coordinate: CLLocationCoordinate2D(latitude: latitude as CLLocationDegrees, longitude: longitude as CLLocationDegrees), photo: photoTaken)
            
        self.mapView.addAnnotation(annotation)
    }
    
    // prepare for navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if identifier == "tagSegue"{
            let vc = segue.destination as! LocationsViewController
            vc.delegate = self
        }
        else if identifier == "fullImageSegue" {
            let vc = segue.destination as! FullImageViewController
            let view = sender as! MKAnnotationView
            vc.tempImage = (view.leftCalloutAccessoryView as! UIImageView).image
        }
        
    }
    
    
    
    
    
    
    
    
}
