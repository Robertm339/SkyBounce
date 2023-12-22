//
//  StartView.swift
//  SkyBounce
//
//  Created by Robert Martinez on 12/21/23.
//

import SpriteKit
import SwiftUI

struct StartView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .frame(width: 300, height: 400)
            .ignoresSafeArea()
    }
}

#Preview {
    StartView()
}
