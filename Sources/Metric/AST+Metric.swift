/*
   Copyright 2017 Ryuichi Saito, LLC and the Yanagiba project contributors

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/

import AST

public extension Declaration {
  public var cyclomaticComplexity: Int {
    let calculator = CyclomaticComplexity()
    return calculator.calculate(for: self)
  }

  public var ncssCount: Int {
    let calculator = NonCommentingSourceStatements()
    return calculator.calculate(for: self)
  }
}

public extension TopLevelDeclaration {
  public var ncssCount: Int {
    let calculator = NonCommentingSourceStatements()
    return calculator.calculate(for: self)
  }
}

public extension CodeBlock {
  public var nPathComplexity: Int {
    let calculator = NPathComplexity()
    return calculator.calculate(for: self)
  }

  public var ncssCount: Int {
    let calculator = NonCommentingSourceStatements()
    return calculator.calculate(for: self)
  }

  public var depth: Int {
    let calculator = CodeBlockDepth()
    return calculator.calculate(for: self)
  }
}
