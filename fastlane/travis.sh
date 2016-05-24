
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  fastlane test
  exit $?
fi

if [[ "$TRAVIS_BRANCH" == "testflight" ]]; then

  exit $?
fi
