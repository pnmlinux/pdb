#!/bin/sh

# Generated manually;
#
# check the requirement's and create Makefile.
# configuration script for pnm's key value based data base
# management tool, it require: Gnu-Make, Gnu-Cpio (or bsd it doesn't matter)
# core-utils, find-utils and Bourne Again SHell.

# defaults
export CWD="${PWD}"
export tab="$(printf '\t')"
export status="true"
export root=""
export prefix="/usr"

# parsing the options
while [ "${#}" -gt 0 ] ; do
    case "${1}" in
		--root|-r)
            shift
            [ -n "${1}" ] && {
                export root="${1}" 
                shift
            }
        ;;
        --prefix|-p)
            shift
            [ -n "${1}" ] && {
                export prefix="${1}"
                shift
            }
        ;;
        *)
            shift
        ;;
    esac
done

# check requirements
for i in "cpio" "file" "make" "bash" "mkdir" "cat" "rm" "find" ; do
    if ! command -v "${i}" > /dev/null ; then
        printf "\tconfigure: command: '${i}' not found..\n"
        export status="false"
    fi
done

if [ "${status}" = "false" ] ; then
    exit 1
fi

# create Makefile
cat - > Makefile <<EOF
PREFIX  = ${root}${prefix}
LIBDIR  = \$(PREFIX)/local/lib/bash5

install:
${tab}mkdir -p \$(LIBDIR)
${tab}cp ./lib/pdb.sh \$(LIBDIR)

uninstall:
${tab}rm \$(LIBDIR)/pdb.sh

reinstall:
${tab}rm \$(LIBDIR)/pdb.sh
${tab}mkdir -p \$(LIBDIR)
${tab}cp ./lib/pdb.sh \$(LIBDIR)
EOF
