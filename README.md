──────────────────────────────
# ✦✧  MMFormat  ✦✧
──────────────────────────────

MMFormat is a Swift package for styling text with simple, readable markup. Apply **expanded**, **condensed**, **bold**, **italic**, and **inline code** styles in your Swift projects or apps like **TrailNomad**. ⧫⧫

---

## Contents ⧑

1. [Introduction](#introduction)
2. [Supported Text Styles](#supported-text-styles)

   * [Expanded Text](#1-expanded-text)
   * [Condensed Text](#2-condensed-text)
   * [Bold Text](#3-bold-text)
   * [Italic Text](#4-italic-text)
   * [Inline Code](#5-inline-code)
   * [Combining Styles](#6-combining-styles)
3. [Cheat Sheet](#cheat-sheet)
4. [Known Limitations](#known-limitations)
5. [Getting Started](#getting-started)
6. [Contribution](#contribution)
7. [License](#license)

---

## Introduction

MMFormat makes styling text in Swift easy. Use intuitive inline markup to enhance readability and presentation in your apps. Perfect for headings, emphasis, or inline code examples. Compatible with **TrailNomad** and other Swift projects. ⧗⧗

---

## Supported Text Styles

### 1. Expanded Text ⨀

Use `++text++` to increase letter spacing for a more open, airy look. Ideal for headings or emphasis.

**Example:**

```swift
MMBlock(text: "Welcome to ++TrailNomad++!")
```

**Result:** `TrailNomad` appears with expanded spacing.

---

### 2. Condensed Text ⧗

Use `--text--` to reduce letter spacing, fitting more text in compact spaces while keeping it readable.

**Example:**

```swift
MMBlock(text: "Enjoy your --adventures-- in style.")
```

**Result:** `adventures` appears condensed.

---

### 3. Bold Text ⧫

Use `**text**` for bold emphasis.

**Example:**

```swift
MMBlock(text: "**Important:** Check your gear.")
```

**Result:** `Important:` appears bold.

---

### 4. Italic Text ✧

Use `*text*` for italic emphasis.

**Example:**

```swift
MMBlock(text: "*Note:* Trails may be slippery.")
```

**Result:** `Note:` appears italic.

---

### 5. Inline Code ⌘

Use `` `text` `` for inline code or monospaced text.

**Example:**

```swift
MMBlock(text: "Use `TrailNomad.start()` to begin.")
```

**Result:** `TrailNomad.start()` appears in monospaced font.

---

### 6. Combining Styles ✦

Combine multiple styles in a single block for more expressive formatting.

**Example:**

```swift
MMBlock(text: "++**Important:**++ Always check *conditions* before hiking.")
```

**Result:** Expanded + Bold + Italic applied correctly.

---

## Cheat Sheet ⧑⧑

| Style       | Markup Syntax   | Example Markup             | Visual Result          |
| ----------- | --------------- | -------------------------- | ---------------------- |
| Expanded    | `++text++`      | `++TrailNomad++`           | TrailNomad (expanded)  |
| Condensed   | `--text--`      | `--adventures--`           | adventures (condensed) |
| Bold        | `**text**`      | `**Important**`            | Important (bold)       |
| Italic      | `*text*`        | `*Note*`                   | Note (italic)          |
| Inline Code | `` `text` ``    | `` `TrailNomad.start()` `` | TrailNomad.start()     |
| Combined    | Any combination | `++**Text**++`             | Expanded + Bold        |

---

## Known Limitations ⚠

* Block styles are not yet supported; styling works only inline.
* Some Unicode glyphs may render differently on certain platforms.
* Nested styles are supported but may require careful ordering.

---

## Getting Started ⧫⧫

1. Add MMFormat to your Swift project via Swift Package Manager.
2. Import the package:

```swift
import MMFormat
```

3. Create a document with styled text blocks:

```swift
let document = MMDocument(blocks: [
    MMBlock(text: "++TrailNomad++ is ready for your adventures!"),
    MMBlock(text: "Remember to --stay safe-- and have fun."),
    MMBlock(text: "**Tip:** Bring plenty of water."),
    MMBlock(text: "*Note:* Weather may change quickly."),
    MMBlock(text: "Use `TrailNomad.start()` to begin.")
])
```

4. Render your document using `MMRenderer`.

---

## Contribution ✦✦

We welcome contributions! Open issues, request features, or submit pull requests. Your feedback helps make MMFormat stronger and more versatile. ⨀⨀

---

## License ⧫⧫

MMFormat is released under the AGPL-3.0-1 License.
