#  Progress Manager
A manager that receives a UILabel and a UIProgressView and updates their status accordingly to informations set on Progress Info

---
## Basic Usage

You can set the label and progressView you want to update along with the necessary info

```swift
let progressInfo = ProgressInfo(text: "000 000", startTime: Date(), timeleft: 10.0, maxTime: 10.0)
let progManager = ProgressManager(progressInfo: progressInfo, label: label, progressView: progressView)
progManager.start()
```

## Progress Info

`ProgressInfo` is the model that defines the information necessary for the `ProgressManager`

```swift
struct ProgressInfo {
    let text: String
    let startTime: Date
    let timeleft: Double
    let maxTime: Double
}
```

In this model you define:
- `text` is used to update the label
- `startTime` works together with `timeleft`. The `timeleft` is the amount of time (in seconds) left to finish the progress view in relation to `startTime`
- `maxTime` is maximium total time (in seconds) of the progress view

See figure:
![ProgressInfo](progressManager_example_fig.png)
