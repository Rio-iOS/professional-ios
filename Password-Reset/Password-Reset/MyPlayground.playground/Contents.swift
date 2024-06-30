import UIKit
import Foundation

// let text = "@:+?!()$#,.\\/"
let text = "\\"
let specialCharacterRegex = "[@:+?!()$#,.\\\\/]+"
text.range(of: specialCharacterRegex, options: .regularExpression) != nil
