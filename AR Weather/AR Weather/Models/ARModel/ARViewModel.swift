//
//  ARViewModel.swift
//  AR Weather
//
//  Created by Ali Eldeeb on 9/22/22.
//

import Foundation
import RealityKit
import ARKit

//Just need one instance of this object so we used final
final class ARViewModel: ObservableObject{
    
    static var singleton = ARViewModel()
    private var weatherModelAnchor: AnchorEntity?
    private var weatherArModelGenerator = WeatherARModelManager()
    private var isWeatherBallPlaced = false //using this bool so we could only place one ball
    var recievedWeatherData: WeatherModel = WeatherModel(cityName: "London", temperature: 65, conditionId: 890){
        //checking  if a new value is set
        didSet{
            updateModel(temperature: recievedWeatherData.temperature, condition: recievedWeatherData.conditionName)
        }
    }
        
    @Published var arView: ARView
    
    init() {
        self.arView = ARView(frame: .zero)
    }
    
    func startARSession(){
        startPlaneDetection()
        startTapDetection()
    }
    
    func startPlaneDetection(){
        arView.automaticallyConfigureSession = true
        let configuration = ARWorldTrackingConfiguration()
        configuration.environmentTexturing = .automatic
        configuration.planeDetection = .horizontal
        arView.session.run(configuration)
    }
    
    func startTapDetection(){
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer){
        let tapLocation = sender.location(in: arView)
        let results = arView.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first{
            let worldPosition = simd_make_float3(firstResult.worldTransform.columns.3)
            if !isWeatherBallPlaced{
                //creat modelEntity
                let weatherBox = weatherArModelGenerator.generateWeatherARModel(condition:  recievedWeatherData.conditionName, temperature: recievedWeatherData.temperature)
                //Position the model entity at the world Position
                placeObject(weatherBox, at: worldPosition)
                isWeatherBallPlaced = true
            }
            
        }
        
    }
    
    func placeObject(_ object: ModelEntity, at location: SIMD3<Float>){
        weatherModelAnchor = AnchorEntity(world: location)
        weatherModelAnchor!.addChild(object)
        arView.scene.addAnchor(weatherModelAnchor!)
    }
    
    private func updateModel(temperature: Double, condition: String){
        if let anchor = weatherModelAnchor{
            //delete the previously place model
            arView.scene.findEntity(named: "weatherBall")?.removeFromParent()
            
            //newModel
            let newWeatherBall = weatherArModelGenerator.generateWeatherARModel(condition: condition, temperature: temperature)
            anchor.addChild(newWeatherBall)
        }
    }
}
