# Canvas Apps

Good practices for Power Apps Canvas Apps.

## CA-010

### Title

Never reference controls from one screen on another screen

### Description

Never reference controls from one screen on another screen. Each screen's formulas must only reference controls that belong to that same screen.

### Guidelines

1. Do not reference a control on scrHome from a formula on scrDetails or any other screen.
1. Use variables (Set(), UpdateContext()) or collections to pass data between screens instead of directly referencing controls.
1. Pass values via Navigate() context parameters when navigating from one screen to another.

### Rationale

1. Cross-screen control references create hidden dependencies between screens, making the app fragile and difficult to maintain.
1. Power Apps does not guarantee that controls on other screens are initialized or hold the expected value when accessed from a different screen, leading to unpredictable behavior.
1. Referencing controls across screens prevents Power Apps from unloading inactive screens from memory, increasing memory consumption and degrading performance.
1. Using variables to pass data makes the data flow explicit and easier to trace during debugging.



### Examples

#### Good

Good example code snippet.
```Plain Text
// On scrHome: navigate and pass the selected order via context variable
Navigate(scrDetails, ScreenTransition.None, {locSelectedOrder: galOrders.Selected})

// On scrDetails: use the context variable, not the gallery control from scrHome
lblOrderTitle.Text: locSelectedOrder.Title
lblOrderStatus.Text: locSelectedOrder.Status
```

#### Bad

Bad example code snippet.
```Plain Text
// On scrDetails: directly referencing a gallery on scrHome
lblOrderTitle.Text: scrHome.galOrders.Selected.Title
lblOrderStatus.Text: scrHome.galOrders.Selected.Status
```

### More Information

1. [Microsoft Learn - Power Platform Documentation](https://learn.microsoft.com/en-us/power-platform/)


