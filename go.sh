#!/bin/sh
bundle install
brew install xctool gcovr
#pmd
brew cask install oclint

xctool -workspace DutyTime.xcworkspace -scheme DutyTime -sdk iphonesimulator -configuration Debug -IDECustomDerivedDataLocation="build/build_ccov" \
  -reporter json-compilation-database:compile_commands.json -reporter pretty -reporter user-notifications clean test

exec gcovr --object-directory="build/build_ccov/DutyTime/Build/Intermediates/DutyTime.build/""Debug-iphonesimulator/DutyTime.build/Objects-normal/i386/" \
  --root=. --gcov-exclude='.*(?:DutyTimeTests|Frameworks|ViewController|AppDelegate).*' --print-summary --html --html-details -o build/coverage.html | tee build/coverage.txt

git notes add -f -F build/coverage.txt

oclint-json-compilation-database -e "Pods*" -- -rc LONG_LINE=150 -report-type html -o build/oclint.html
mv compile_commands.json build
