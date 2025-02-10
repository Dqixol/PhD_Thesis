#! /bin/bash
# Script to update atlaslatex scripts from the Git master.

# Copyright (C) 2002-2024 CERN for the benefit of the ATLAS collaboration.

# Changes:
# 2022-02-08 Ian Brock (ian.brock@cern.ch): First version of scropt.

# Decide how to clone atlaslatex - ssh is default
ATLASLATEXGIT=ssh://git@gitlab.cern.ch:7999/atlas-physics-office/atlaslatex.git
BRANCH=''
CLONE=1
while getopts shkcd opt; do
    case $opt in
        s)
            ATLASLATEXGIT=ssh://git@gitlab.cern.ch:7999/atlas-physics-office/atlaslatex.git
            ;;
        h)
            ATLASLATEXGIT=https://gitlab.cern.ch/atlas-physics-office/atlaslatex.git
            ;;
        k)
            ATLASLATEXGIT=https://:@gitlab.cern.ch:8443/atlas-physics-office/atlaslatex.git
            ;;
        c)
            CLONE=0
            ;;
        d)
            BRANCH=devel
            ;;
        \?)
            echo "$0 [-h] [-k] [-s]"
            echo "  -h use https GitLab link"
            echo "  -k use krb5 GitLab link"
            echo "  -s use ssh GitLab link"
            echo "  -d use devel branch instead of master"
            echo "  -c Copy scripts from local directory (mainly for testing)"
            exit 1
            ;;
    esac
done

# Check we are in the right directory
DIR=$(basename "${PWD}")
if [ -e ${DIR}.tex ]; then
    echo "We are in directory ${PWD}"
else
    echo "We do not appear to be in the main directory: ${PWD}."
    echo "There should be a tex file with the same name as the directory."
    exit 1
fi

# Use temporary directory if it already exists.
if [ -d tmp-atlaslatex ]; then
    echo "Use existing clone of atlaslatex."
else
    # Clone OR copy the ATLAS LaTeX Git repository.
    if [ ${CLONE} == 1 ]; then
        # Switch to devel branch for testing.
        if [ -n "${BRANCH}" ]; then
            git clone ${ATLASLATEXGIT} tmp-atlaslatex
            cd tmp-atlaslatex 
            git checkout devel
            cd ..
        else
            git clone --depth 1 ${ATLASLATEXGIT} tmp-atlaslatex
        fi
    else
        cp -r ${HOME}/atlas/LaTeX/atlaslatex tmp-atlaslatex
    fi
fi

# Self-update scripts first
test -d scripts || mkdir scripts
for lfile in scripts/atlaslatex_update.sh scripts/atlaslatex_2020.sh; do
    afile=tmp-atlaslatex/scripts/$(basename $lfile)
    cp ${afile} ${lfile}
    # Make sure file is exectuable
    chmod u+x ${lfile}
    echo "+++ ${lfile} updated. You can now run the new version of ${lfile}."
done

# Remove temporary directory
rm -rf tmp-atlaslatex

mfile=${DIR}.tex
