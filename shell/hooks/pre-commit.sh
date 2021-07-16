#!/usr/bin/env bash

if git rev-parse --verify HEAD >/dev/null 2>&1
then
  against=HEAD
else
  # Initial commit: diff against an empty tree object
  against=$(${git}/bin/git hash-object -t tree /dev/null)
fi

diff="git diff-index --name-only --cached $against --diff-filter d"

nix_files=($($diff -- '*.nix'))
all_files=($($diff))

# Format staged nix files.
if [[ -n "${nix_files[@]}" ]]; then
  for file in ${nix_files[@]}; do
    nixpkgs-fmt $file
    sed -i 's/[[:space:]]*$//' $file \  # Remove trailing whitespace
    git add $file
  done
fi

# check editorconfig
editorconfig-checker -- "${all_files[@]}"
if [[ $? != '0' ]]; then
  printf "%b\n" \
    "\nCode is not aligned with .editorconfig" \
    "Review the output and commit your fixes" >&2
  exit 1
fi
