# prebuilt-libsqlcipher

:package: Prebuilt native SQLCipher for Unity3D

- Prebuilt native [sqlcipher/sqlcipher](https://github.com/sqlcipher/sqlcipher) library for Unity3D.
  - VERSION=v4.10.0
- try [SqlCipher4Unity3D](https://github.com/netpyoung/SqlCipher4Unity3D).

| Platforms        | Arch        | action  |
| ---------------- | ----------- | ------- |
| Windows          | x86_64      | o       |
| Windows          | x86_arm64   | x       |
| Windows          | x86         | x       |
| Linux            | x86_64      | o       |
| Linux            | x86         | x       |
| macOS            | x86_64      | o       |
| macOS            | x86_64      | o       |
| macOS            | arm64       | o       |
| iOS              | armv7       | x       |
| iOS              | armv7s      | x       |
| iOS              | arm64       | o       |
| iOS (Simulator)  | x86_64      | o       |
| tvOS             | arm64       | o       |
| tvOS (Simulator) | x86_64      | o       |
| Android          | armeabi-v7a | x       |
| Android          | arm64_v8a   | x       |
| Android          | x86         | x       |
| Android          | x86_64      | x       |
| WebGL            | .           | no plan |
| Other            | .           | no plan |

- for android, there is <https://github.com/sqlcipher/android-database-sqlcipher>

## Preface

- I don't have macOS device then couldn't suppport issues which related. To reduce issues, bothering, doubting transparency about from that, so I choose to use [github's action](https://docs.github.com/en/actions).

## Ref

- <https://github.com/jfcontart/SqlCipher4Unity3D_Apple>
- <https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#preinstalled-software>
- <https://github.com/maxim-lobanov/setup-xcode>
- <https://github.com/sqlcipher/android-database-sqlcipher/blob/master/build.gradle>
- <https://developer.android.com/ndk/guides/other_build_systems#autoconf>
- <https://gist.github.com/youhide/121750fc4878801ea8e908080b535beb>
