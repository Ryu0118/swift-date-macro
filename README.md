# swift-date-macro
Macro for converting String to Date safely

## Usage
```Swift
let date = #date("2023/11/27", dateFormat: "yyyy/MM/dd")
```
Entering the wrong date format like this causes a compile error
```Swift
let date = #date("202311-11", dateFormat: "yyyy-MM-dd")
        // ┬───────────────────────────────────────────
        // ╰─ 🛑 malformed date or dateFormat: 202311-11, yyyy-MM-dd
```
