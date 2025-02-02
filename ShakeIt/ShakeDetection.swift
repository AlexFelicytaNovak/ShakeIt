//
//  ShakeDetection.swift
//  ShakeIt
//
//  Created by Zosia on 08/05/2023.
//

import SwiftUI

struct Notifications {
    static let shaken = Notification.Name(rawValue: "Shaken")
}

extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: Notifications.shaken, object: nil)
        }
     }
}

struct WasDeviceShakenViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: Notifications.shaken)) { _ in
                action()
            }
    }
}

extension View {
    func deviceShaken(perform action: @escaping () -> Void) -> some View {
        self.modifier(WasDeviceShakenViewModifier(action: action))
    }
}
