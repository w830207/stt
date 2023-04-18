# stt

A Speech-to-text project.

<img src="https://user-images.githubusercontent.com/44136372/232753467-20aa0898-540a-487a-8eb3-b0a811ad5c0c.png" height="460px"/>

## 功能

- 語音識別 speech to text
- 中英互轉文字翻譯
- 漢字轉拼音、注音
- 支援錄音、音檔

## How To Use

![1](https://user-images.githubusercontent.com/44136372/232783284-ca4785f1-e0d4-474e-8bbd-e51d50796833.png)
![2](https://user-images.githubusercontent.com/44136372/232783295-c3212f6c-f561-4e8c-abb1-225c09df393f.png)


## Models

### Speech to Text
- 英: openai/whisper-tiny.en 
- 中: kevin51jiang/whisper-tiny-zh-CN

### Translation
- 英轉中: liam168/trans-opus-mt-en-zh 
- 中轉英: Helsinki-NLP/opus-mt-zh-en

## 主要packages
- [audio_waveforms](https://github.com/SimformSolutionsPvtLtd/audio_waveforms) : 錄音、音訊播放、音訊視覺化
- [lpinyin](https://github.com/w830207/lpinyin) : 漢字轉拼注音，拼音來自[原庫](https://github.com/flutterchina/lpinyin)，我修改加上轉注音，已提出pr。注音參考自[python-zhuyin](https://github.com/rku1999/python-zhuyin)。


## Version

- **Xcode** 12 以上
- **Android** targetSdkVersion compileSdkVersion 皆為 33 minSdkVersion 21
- **Flutter** 3.3.8
- **Dart**  2.18.4
