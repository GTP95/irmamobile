#!/usr/bin/env bash

flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run flutter_launcher_icons:main
flutter format --line-length=120 lib/ test/
