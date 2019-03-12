#  Progress Manager
A manager that receives a UILabel and a UIProgressView and updates their status accordingly to informations set on Progress Info

Ideal for token generation based on time (TOTP)

---
## Basic Usage

You can set the label and progressView you want to update along with the necessary info

```swift
let progressInfo = ProgressInfo(text: "228538", startTime: Date(), timeleft: 10.0, maxTime: 10.0)
let progressManager = ProgressManager(progressInfo: progressInfo, label: label, progressView: progressView)
progressManager.start()
```

## Progress Info

`ProgressInfo` is the model that defines the information necessary for `ProgressManager`

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
- `startTime` works together with `timeleft`. The `timeleft` property is the amount of time (in seconds) left to finish the progress view in relation to `startTime`
- `maxTime` is maximum total time (in seconds) of the progress view

#### NOTE: If `timeleft` is bigger than maxTime or less than 0, it will not work.

![ProgressInfo](progressManager_example_fig.png)

## Personalizing

You can perfome some personalizations, such as:
- **direction**: defines if the bar progress is increasing or decreasing
- **smoothness**: defines how smooth the progress bar will increasing or decrease
- **shouldRestartAutomatically**: flag to indicate if the progress bar should restart automatically after is finished

```swift
progressManager.smoothness = .high
progressManager.direction = .increasing
progressManager.shouldRestartAutomatically = true
```

### IMPORTANT

If `shouldRestartAutomatically` is set as `true`, is important that you set the delegate for the manager, otherwise it will NOT work.

```swift
progressManager.delegate = self
```

Then, use the `ProgressManagerDelegate` protocol method `progressInfo(forProgressManager:)` to update the new `ProgressInfo`

```swift
func progressInfo(forProgressManager progressManager: ProgressManager) -> ProgressInfo {
    return ProgressInfo(text: "234534", startTime: Date(), timeleft: 9.0, maxTime: 10.0)
}
```

#### OR

Your can restart the progressView by will using

```swift
progressManager.restart(withInfo:)
```
