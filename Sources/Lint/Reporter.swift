/*
   Copyright 2015 Ryuichi Saito, LLC and the Yanagiba project contributors

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

protocol Reporter {
  func handle(issue: Issue) -> String
  func handle(numberOfTotalFiles: Int, issueSummary: IssueSummary) -> String

  func header() -> String
  func footer() -> String
  func separator() -> String
}

extension Reporter {
  func handle(issue: Issue) -> String {
    return ""
  }

  func handle(numberOfTotalFiles: Int, issueSummary: IssueSummary) -> String {
    return ""
  }

  func header() -> String {
    return ""
  }

  func footer() -> String {
    return ""
  }

  func separator() -> String {
    return ""
  }
}
