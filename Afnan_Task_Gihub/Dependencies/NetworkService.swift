//
//  Untitled.swift
//  GitHubExplorer
//
//  Created by Afnan Alotaibi on 09/05/1446 AH.
//

import Foundation
import Combine
import Network

public class NetworkService: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    @Published var isConnected: Bool = true

    static let networkStatusChangedNotification = Notification.Name("NetworkStatusChanged")

    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitorQueue")
        
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
