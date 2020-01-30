#!/bin/sh

cd "${GITHUB_WORKSPACE}" || exit

submit_review() {
	__reporter=${INPUT_REPORTER:-github-check}
	__level=${INPUT_LEVEL:-error}
    export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
    reviewdog -name="ansible-lint" -efm="%f:%l: %m" -tee -reporter="$__reporter" -level="$__level"
}

if [ "${INPUT_GITHUB_TOKEN}" ]
then
    ansible-lint -p | submit_review
else
    ansible-lint
fi
