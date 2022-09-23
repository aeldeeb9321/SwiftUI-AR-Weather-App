//
//  WeatherARModelManager.swift
//  AR Weather
//
//  Created by Ali Eldeeb on 9/23/22.
//

import UIKit
import ARKit
import RealityKit
public class WeatherARModelManager{
    //passing in the condition type and temp value then returning our weather cube entity with the tempEntity child
    public func generateWeatherARModel(condition: String, temperature: Double) -> ModelEntity{
        
        //our box and text
        let conditionModel = weatherConditionModel(condition: condition)
        let temperatureText = createWeatherText(with: temperature)
        
        //place text on top of ball
        conditionModel.addChild(temperatureText)
        temperatureText.setPosition(simd_float3(-0.07,0.08,0), relativeTo: conditionModel)
        conditionModel.name = "weatherBall"
        return conditionModel
    }
    
    //create the weather box modelEntity
    private func weatherConditionModel(condition: String) -> ModelEntity{
        let mesh = MeshResource.generateBox(width: 0.15, height: 0.15, depth: 0.15)
        //AVPlayerItem is an object that models the timing and presentation state of an asset during playback.
        let videoItem = createVideoItem(with: condition)
        //A VideoMaterial is a material that maps a movie file on to the surface of an entity.Video materials use an AVPlayer instance to control movie playback.
        let videoMaterial = createVideoMaterial(with: videoItem!)
        
        let ballModel = ModelEntity(mesh: mesh, materials: [videoMaterial])
        
        return ballModel
        
    }
    
    //creating the video item from our video files based on the condition string passed in
    private func createVideoItem(with fileName: String) -> AVPlayerItem?{
        // Create a URL from a movie filename.
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp4") else{return nil}
        
        //video item, An asset that represents media at a local or remote URL.
        let asset = AVURLAsset(url: url)
        //A player item stores a reference to an AVAsset object, which represents the media to play.
        let videoItem = AVPlayerItem(asset: asset)
        
        return videoItem
    }
    
    //Taking the video AVPlayerItem  and making a material that maps a video file on to the surface of a model entity.
    private func createVideoMaterial(with videoItem: AVPlayerItem) -> VideoMaterial{
        //video player
        let player = AVPlayer()
        
        //video material which takes an AVPlayer as an input
        let videoMaterial = VideoMaterial(avPlayer: player)
        
        //Play video from our createVideoItem func
        player.replaceCurrentItem(with: videoItem)
        player.play()
        
        return videoMaterial
        
    }
    
    //Place text on top of ball, need a func to create text
    private func createWeatherText(with temperature: Double) -> ModelEntity{
        //how to create a text meshResource
        let mesh = MeshResource.generateText("\(temperature)°F", extrusionDepth: 0.1, font: .systemFont(ofSize: 2), containerFrame: .zero, alignment: .left, lineBreakMode: .byTruncatingTail)
        let material = SimpleMaterial(color: .white, isMetallic: true)
        
        let textEntity = ModelEntity(mesh: mesh, materials: [material])
        //making the text bigger
        textEntity.scale = SIMD3<Float>(x: 0.025, y: 0.025, z: 0.1)
        return textEntity
    }
}
