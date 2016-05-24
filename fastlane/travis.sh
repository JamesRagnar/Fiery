
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then

  fastlane test
  exit $?

else

  if [[ "$TRAVIS_BRANCH" == "testflight" ]]; then

    fastlane testflight
    exit $?

  fi

fi
