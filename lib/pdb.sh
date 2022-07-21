#!/bin/bash

#    key value based data store tool writtein in bash 5 - Pnm DataBase
#    Copyright (C) 2022  lazypwny751
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

pdb:__allowchars() {
    if [[ "${1}" =~ ['!@#$ %^&*()+'] ]] ; then
        return 1
    else
        return 0
    fi
}

pdb:__datam() {
    # data manager:
    # require cpio and find

    # senin datan benim datam benim datam benim datam 
    #                                       --ms felsefesi

    local i=""
    local status="true"
    local requirements=(
        "cpio"
        "find"
        "file"
    )

    for i in ${requirements[@]} ; do
        if ! command -v "${i}" &> /dev/null ; then
            echo -e "\t${FUNCNAME##*:}: '${i}' missing.."
            local status="false"
        fi
    done

    if [[ "${status}" = "false" ]] ; thenü
        return 1
    fi

    # $1: arg
    # $2: arg(param) 
    if [[ "${#}" -ge 2 ]] ; then
        case "${1}" in
            --[oO][pP][eE[nN]|-[oO])
                if (file "${2}" | grep -w "cpio archive") &> /dev/null ; then
                    local CWD="${PWD}"
                    local TMP="${CWD}/.tmp${2##*/}"
                    if [[ -d "${TMP}" ]] ; then
                        rm -rf "${TMP}"
                    fi
                    mkdir -p "${TMP}"
                    (
                        cd "${TMP}"
                        cpio -i < "${2}"
                    ) && export TMP="${TMP}" || return 1
                else
                    echo -e "\t${FUNCNAME##*:}: '${2##*/}' is not an cpio archive."
                    return 1
                fi
            ;;
            --[cC][lL][oO][sS][eE]|-[cC])
                if [[ "${#}" -ge 3 ]] ; then
                    local CWD="${PWD}"
                    local TMP="${2}"
                    local FILE="${3}"
                    if [[ -d "${TMP}" ]] ; then
                        (
                            cd "${TMP}"
                            find . | cpio -o > "${FILE}"
                        ) || return 1
                    else
                        echo -e "\t${FUNCNAME##*:}: temp directory doesn't exist."
                        return 1
                    fi
                else
                    echo -e "\t${FUNCNAME##*:}: insufficient supplement."
                    return 1
                fi
            ;;
            *)
                if [[ -n "${TMP}" ]] && [[ -d "${TMP}" ]] ; then
                    return 0
                else
                    return 1
                fi
            ;;
        esac
    else
        echo -e "\t${FUNCNAME##*:}: insufficient supplement."
        return 1
    fi
}

pdb:new() {
    :
}

pdb:set() {
    :
}

pdb:rem() {
    :
}

pdb:get() {
    :
}

if [[ "${BASH_SOURCE}" = "${BASH_SOURCE[-1]}" ]] ; then
    while [[ "${#}" -gt 0 ]] ; do
        case "${1}" in
            *)
                shift
            ;;
        esac
    done
fi
