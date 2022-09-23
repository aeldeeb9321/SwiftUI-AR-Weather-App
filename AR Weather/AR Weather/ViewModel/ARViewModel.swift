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
        arView.debugOptions = .showAnchorGeometry
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
            //creat modelEntity
            let weatherBox = createObject()
            //Position the model entity at the world Position
            placeObject(weatherBox, at: worldPosition)
        }
        
    }
    
    func createObject() -> ModelEntity{
        let mesh = MeshResource.generateBox(width: 0.1, height: 0.1, depth: 0.1)
        let material = SimpleMaterial(color: .blue, isMetallic: true)
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        return modelEntity
    }
    
    func placeObject(_ object: ModelEntity, at location: SIMD3<Float>){
        weatherModelAnchor = AnchorEntity(world: location)
        weatherModelAnchor!.addChild(object)
        arView.scene.addAnchor(weatherModelAnchor!)
    }
}
