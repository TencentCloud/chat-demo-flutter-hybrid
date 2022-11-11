

<br>

<p align="center">
  <a href="https://www.tencentcloud.com/products/im?from=pub">
    <img src="https://qcloudimg.tencent-cloud.cn/raw/429a2f58678a1f5b150c6ae04aa0b569.png" width="320px" alt="Tencent Chat Logo" />
  </a>
</p>

<h1 align="center">Tencent Cloud Chat</h1>

<br>

<p align="center">
  Integrate In-App Chat and Call to your existing applications.
</p>

<br>

<br>

## Samples of integration Flutter SDK to an existing app.

This directory contains Android and iOS projects that import and use Tencent Cloud Chat as a Flutter module.

They're designed to show recommended approaches for adding Tencent Cloud Chat (Flutter SDKs) to existing Android and iOS apps.

Aiming to build an In-App Chat and Call module to your existing application quickly and conveniently.

**Which could reduce your workloads of integration of our SDKs to your existing Android and iOS apps to large extents.**

## About Tencent Cloud Chat

[Tencent Cloud Chat](https://www.tencentcloud.com/products/im?from=pub) provides globally interconnected chat APIs, multi-platform SDKs, and UIKit components to help you quickly bring messaging capabilities such as one-to-one chat, group chat, chat rooms, and system notifications to your applications and websites.

Taking the advantage of cross-platform features of Flutter, Tencent Cloud Chat Flutter SDK helps to integrate the Chat and Voice/Video Call module to your existing Android/iOS applications.

There are two main parts of Tencent Cloud Chat, including Chat and Call.

- Chat module mainly includes messages sending and receiving, conversation management and user relationship management, etc.

- Call module mainly includes voice call and video call for both one-to-one call and group call.

## Samples Listing

- Multiple Flutter Engines: Embeds Chat module and Call module into two separate Flutter engines, while based on a common Flutter Engine Group. Means that voice calls and video calls can be controlled independently without the navigation to a new page when a new calling income, providing a relatively better experience.
- Single Flutter Engines: Integrate both Chat module and Call module into one Flutter engine. It's supposed to navigate to the page that runs the Flutter module first, followed by presenting the call page, when a new call comes.
- Initialize from Native: Initialize and log in from Native SDK. Sometimes, you are willing to integrate chat modules, especially for those used in simple and high-frequency situations, to your application in depth quickly, you are allowed to use our Native SDK, without the need or before the process of initialization and log in from Flutter module.

## Goals for these samples

- Show developers how to add Tencent Cloud Chat to their existing applications in a convenient way.
- Show the following options:
    - Whether to build the Flutter module from source each time the app builds or rely on a separately pre-built module.
    - Whether to use multiple Flutter engines or use a single Flutter engine.
- Show Flutter being integrated ergonomically with applications with existing middleware and business logic data classes.

## Installing Cocoapods

The iOS samples in this repo require the latest version of Cocoapods. To make sure you've got it, run the following command on a macOS machine:

```shell
sudo gem install cocoapods
```

See https://guides.cocoapods.org/using/getting-started.html for more details.

## Contact Us

Please do not hesitate to contact us in the following place, if you have any further questions or tend to learn more about the use cases.

- Telegram Group: <https://t.me/+1doS9AUBmndhNGNl>
- WhatsApp Group: <https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A>
- QQ Group: 788910197, chat in Chinese

Our Website: <https://www.tencentcloud.com/products/im?from=pub>