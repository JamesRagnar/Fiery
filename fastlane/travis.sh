
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then

    if [[ "$TRAVIS_BRANCH" == "testflight" ]]; then

        fastlane testflight
        exit $?

    else

        fastlane test
        exit $?

    fi

fi