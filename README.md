# Phone

## Description

This repository houses the DAFT OS: the non-smart operating system.

### Aims

This OS should:

* Only use the keys available on a number pad.
* Be intuitive.
* Allow a user to perform basic day-to-day tasks without fuss or clutter.
* Have as shallow a menu structure as is possible.
* Have as many useful programs as is practical.

This OS should not:

* Be overly complicated.
* Make any attempt to divert the user's attention from what they are doing.
* Have programs that nobody will use (unless they are tucked away somewhere).

## Hardware

This OS will eventually be run on a Raspberry Pi (although I'm currently testing on Windows). It should completely replace the default shell in text mode.

## Running

### Dependencies

To run DAFT OS, you will need:

* [espeak-ng](https://github.com/espeak-ng/espeak-ng/) in your path.
* [Dart](https://dart.dev/get-dart) version >=2.15.0 <3.0.0 (can be installed as part of [Flutter](https://github.com/flutter/flutter)).
* Write access to the directory where you plan to run the code.

### Getting The Code

You can clone the repository locally with `git clone https://github.com/chrisnorman7/phone`.

Then change into the directory and get the dart dependencies:

```shell
cd phone
dart pub get
```

### Running

Finally, run the software:

```shell
dart run
```

## Usage

Until I have written a manual (which will be accessible from within the software), the below serves as a reference on how to use the OS.

It is worth noting before we dive in that the number pads which are most commonly found on keyboards are build as a mirror image to those found on phones. As such, I have flipped the number pad, so that keys 7, 8 and 9 are keys 1, 2 and 3 in the OS. Similarly, keys 1, 2 and 3 are keys 7, 8 and 9 in the OS.

### Keys

The following table lists the keys recognised by the application.

| Actual Key | OS Key |
| --- | --- |
| 0 | 0 |
| 1 | 7 |
| 2 | 8 |
| 3 | 9 |
| 4 | 4 |
| 5 | 5 |
| 6 | 6 |
| 7 | 1 |
| 8 | 2 |
| 9 | 3 |
| . | Mode |
| Enter | Enter |
| Plus | Cancel |
| Minus | Backspace |
| Multiply | Arrow Right |
| Divide | Arrow Left |

### Menus

The most common form of control is the humble menu. You can operate within menus with the following keyboard shortcuts:

| OS Key | Description |
| --- | --- |
| Arrow Left | Move to the previous item. |
| Arrow Right | Move to the next item. |
| Enter | Activate the current item. |
| Cancel | Cancel this menu (if possible). |
| Mode | Switch between navigation mode and the information mode. While in information mode, you can read things like the time (with 0). |
| 2 | Go to the first item in the menu. |
| 8 | Go to the last item in the menu. |
| 4 | Go to the previous item whose name starts with a different letter. |
| 6 | Go to the next item whose name starts with a different letter. |

### Edit fields

Edit fields let you type in text. Emojis will be supported, but for now they can only be read, and not entered. For the progress of this issue, see #[#4](https://github.com/chrisnorman7/phone/issues/4).

In addition to the number keys (which type in the obvious way), you have the following additional keys:

| OS Key | Description |
| --- | --- |
| Arrow Left | Move to the previous character. |
| Arrow Right | Move to the next character. |
| Backspace | Delete the letter immediately before the cursor. |
| Mode | Switch between "Upper Case", "Lower Case", and "Number" modes. |
| Enter | Submit the text you have written. |
| Cancel | Cancel the text field (if possible). |

### Date picker fields

Date picker fields allow you to select a date, for example when setting the birth day of a contact.

When a date picker is selected, you can use the following keys:

| OS Key | Description |
| --- | --- |
| 1 | Add 1 year. |
| 2 | Add 1 month. |
| 3 | Add 1 day. |
| 4 | Reset the year to its default. |
| 5 | Reset the month to its default. |
| 6 | Reset the day to the default. |
| 7 | Subtract 1 year. |
| 8 | Subtract 1 month. |
| 9 | Subtract 1 day. |
| 0 | Reset the whole date to its default. |
| Enter | Submit the date you have chosen. |
| Cancel | Cancel the date picker (if possible). |

### Custom fields

It is possible that the control you have focused has overridden the default keys, and you may see different behaviours. For example, the TTS speed control uses the 2 key to increase the speed, the 5 key to reset it to the default, and the 8 key to reduce speed.

## Testing

To run the test suite, use the standard `dart test` command.

## Logs

Log files of your session are stored in a `logs` folder. You can view these either in a standard text editor, or from within the OS itself.

If you discover that something is being logged that shouldn't be, or conversely that you believe something should be logged that is not currently being logged, please [submit an issue](https://github.com/chrisnorman7/phone/issues/new).

## Hardware

For building the phone, the below hardware is suggested:

* [4G pHAT for Raspberry Pi - LTE Cat-4/3G/2G with GNSS Positioning](https://thepihut.com/collections/raspberry-pi-hats/products/4g-phat-for-raspberry-pi-lte-cat-4-3g-2g-with-gnss-positioning)
