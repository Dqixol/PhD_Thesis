#! /bin/bash
# Script to update atlaslatex version from the Git master.

# Copyright (C) 2002-2024 CERN for the benefit of the ATLAS collaboration.

# Changes:
# 2018-08-14 Ian Brock (ian.brock@cern.ch): BASENAME should be set correctly if Makefile is overwritten.
# 2019-04-16 Ian Brock (ian.brock@cern.ch): Only overwrite "BASENAME = ..." and not occurences without a space (in help).
# 2020-11-21 Ian Brock (ian.brock@cern.ch): Check for use of \ATLASLATEXPATH and say atlaslatex_2020.sh should be run.
# 2022-02-07 Ian Brock (ian.brock@cern.ch): Check that standard style files are all there.

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

# Remove temporary directory if it exists
test -d tmp-atlaslatex && rm -r tmp-atlaslatex

# Clone or copy the ATLAS LaTeX Git repository.
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

function cf_files {
    # echo "Compare ${afile} with ${lfile}:"
    cmp --silent "$1" "$2"
    cmpStatus=$?
    # echo "cmp status is $cmpStatus" 
    extension="${1##*.}"
    # echo "File $1, Extension $extension"
    if [ $cmpStatus -eq 0 ]; then
        echo "No change to file $1"
    else
        echo "Running diff on $1 vs $2:"
        diff "$1" "$2"
        echo "Will try to copy $2 to $1:"
        cp -i "$2" "$1"
        # Make sure file is executable
        if [ ${extension} == "sh" ]; then
            echo "Making $1 executable"
            chmod u+x $1
        fi
    fi
}

# See if scripts have to be updated first.
test -d scripts || mkdir scripts
scriptupdate=0
sfile="scripts/atlaslatex_selfupdate.sh"
for lfile in "scripts/atlaslatex_update.sh" "scripts/atlaslatex_2020.sh"; do
    afile="tmp-atlaslatex/scripts/$(basename $lfile)"
    if [ -e ${lfile} ]; then
        cmp --silent ${lfile} ${afile}; cmpStatus=$?
        echo "Comparing ${lfile} with ${afile}:"
        # echo "Status is ${cmpStatus}"
        if [ $cmpStatus -eq 0 ]; then
            echo "No change to file ${lfile}."
        else
            scriptupdate=1
            echo "+++ ${lfile} need to be updated."
        fi
    else
        scriptupdate=1
        echo "+++ ${lfile} need to be updated."
    fi
done

# Update the scripts.
if [ $scriptupdate -eq 1 ]; then
    afile="tmp-atlaslatex/scripts/atlaslatex_selfupdate.sh"
    sfile="scripts/atlaslatex_selfupdate.sh"
    cp ${afile} ${sfile}
    # Do not remove temporary directory, as it can be used by atlas_selfupdate.sh.
    # rm -rf tmp-atlaslatex
    # Tell user what to do.
    echo "+++ You should run ${sfile} to update scripts first."
    exit
fi

# Class and style files
for lfile in latex/*.cls latex/*.sty; do
    afile=tmp-atlaslatex/latex/$(basename $lfile)
    cf_files "${lfile}" "${afile}"
done

# atlaslatexpath.sty should be there
for file in atlasdoc.cls atlaslatexpath.sty atlascover.sty \
    atlaspackage.sty atlasphysics.sty atlasbiblatex.sty \
    atlascontribute.sty atlascomment.sty atlastodo.sty \
    atlasmisc.sty; do
    if [ -e latex/${file} ]; then
        echo "${file} is already in latex directory."
    else
        echo "Copying ${file} to latex directory."
        cp tmp-atlaslatex/latex/${file} latex/
    fi
done

# Bibliography files
for lfile in bib/*.bib; do
    afile=tmp-atlaslatex/bib/$(basename $lfile)
    cf_files "${lfile}" "${afile}"
done

# Template files
for lfile in template/atlas-detector.tex; do
    afile=tmp-atlaslatex/template/$(basename $lfile)
    cf_files "${lfile}" "${afile}"
done
for lfile in template/MC_snippets/*.tex template/MC_snippets/*.sty; do
    afile=tmp-atlaslatex/template/MC_snippets/$(basename $lfile)
    cf_files "${lfile}" "${afile}"
done

# Logos
# ORCID-iD_icon-128.128.png should be there
for file in ORCID-iD_icon-128x128.png; do
    if [ -e logos/${file} ]; then
        echo "${file} is already in logos directory."
    else
        echo "Copying ${file} to logos directory."
        cp tmp-atlaslatex/logos/${file} logos/
    fi
done

for lfile in logos/*; do
    afile=tmp-atlaslatex/logos/$(basename $lfile)
    cf_files "${lfile}" "${afile}"
done

# ChangeLog
for lfile in CHANGELOG.md; do
    afile=tmp-atlaslatex/$(basename $lfile)
    cf_files "${lfile}" "${afile}"
done

# Makefile
for lfile in Makefile; do
    BASENAME=$(grep '^BASENAME.*=' ${lfile})
    echo "BASENAME definition is: <$BASENAME>."
    afile=tmp-atlaslatex/$(basename $lfile)
    cf_files "${lfile}" "${afile}"
    # Assume definition of BASENAME is of the form BASENAME =
    echo "Replacing BASENAME definition with <${BASENAME}> in ${lfile}:"
    sed -i '.bak' -e "s/^BASENAME =.*/${BASENAME}/" ${lfile}
    # The folllowing should only change the first occurence of BASENAME =..., but has not been tested everywhere
    # sed -i '.bak' -e "0,/${BASENAME}/ s/BASENAME[ \t]+=.*/${BASENAME}/" ${lfile}
done

# Acknowledgements - if the directory exists
# if [ -d acknowledgements ]; then
#     for lfile in acknowledgements/*.tex acknowledgements/*.bib; do
#         afile=tmp-atlaslatex/acknowledgements/$(basename $lfile)
#         cf_files "${lfile}" "${afile}"
#     done
# fi

# Remove temporary directory
rm -rf tmp-atlaslatex

# 2020-11-21 ATLASLATEXPATH should no longer be used
mfile=${DIR}.tex
if [ $(grep -c ATLASLATEXPATH ${DIR}.tex) -gt 0 ]; then
    echo "*** IMPORTANT ***"
    echo "*** If you have not already done so, please run scripts/atlaslatex_2020.sh."
    echo "*** This adapts your main tex file to avoid problems with TeX Live 2020."
    echo "*** It replaces the use of \ATLASLATEXPATH with a style file latex/atlaslatexpath.sty."
    echo "*** IMPORTANT ***"
fi
