//
//  CreateSessionResponse.swift
//  Moviefy
//
//  Created by Benjamin Simpson on 5/4/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation

struct CreateSessionResponse: Codable {
    let success: Bool
    let session_id: String
}
