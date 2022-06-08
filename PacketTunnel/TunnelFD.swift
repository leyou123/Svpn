//
//  TunnelFD.swift
//  PacketTunnel
//
//  Created by hzg on 2021/9/28.
//  Copyright © 2021 com. All rights reserved.
//

import Foundation

class TunnelFD : NSObject {
    
    @objc func getFD()->Int32 {
        var buf = [CChar](repeating: 0, count: Int(IFNAMSIZ))
        for fd: Int32 in 4...64 {
            var len = socklen_t(buf.count)
            if getsockopt(fd, 2 /* SYSPROTO_CONTROL */, 2, &buf, &len) == 0 {
                let str = String(cString: buf)
                if str.starts(with: "utun") {
                    return fd
                }
            }
        }
        return -1
    }
}
