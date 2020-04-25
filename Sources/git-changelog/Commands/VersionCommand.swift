//
//  VersionCommand.swift
//  
//
//  Created by Anthony Castelli on 4/8/20.
//

import Foundation
import ConsoleKit

final class VersionCommand: Command {
    struct Signature: CommandSignature {
        init() { }
    }

    var help: String {
        return "Version Info"
    }

    func run(using context: CommandContext, signature: Signature) throws {
        context.console.output("Release Version " + [ConsoleTextFragment(string: "1.0.0", style: .init(color: .green))])
    }
}
