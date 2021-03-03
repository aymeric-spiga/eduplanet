#! /bin/bash

echo "*** update eduplanet"
# This line will reset the model setup files;
# They are saved in each exp folder anyway;
git reset HEAD --hard
git pull
