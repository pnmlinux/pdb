#!/bin/bash

#    key value based data store tool writtein in bash 5 - Pnm DataBase 1.0.0
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

# TODO:
#   check permissions of directory, if can be write or not.
#   add list feature.
#   add match feature.

pdb:__realpath() {
    # simulate real path, this function can't show real path only theory.
    if [[ -n "${1}" ]] ; then
        if [[ "${1:0:1}" = "/" ]] ; then
            local CWD=""
        else
            local CWD="${PWD//\// }"
        fi

        local realpath="${1//\// }"
        local i="" markertoken="/"

        for i in ${CWD} ${realpath} ; do
            if [[ "${i}" = "." ]] ; then
                setpath="${setpath}"
            elif [[ "${i}" = ".." ]] ; then
                setpath="${setpath%/*}"
            else
                case "${i}" in
                    ""|" ")
                        :
                    ;;
                    *)
                        setpath+="${markertoken}${i}"
                    ;;
                esac
            fi
        done

        if [[ -z "${setpath}" ]] ; then
            setpath="${markertoken}"
        fi

        echo "${setpath}"
    else
        echo -e "\t${FUNCNAME##*:}: insufficient parameter."
        return 1
    fi
}

pdb:__allowchars() {
    if [[ "${1}" =~ ['\[!@#$ %^&*()+|?{}"=,;/£½'] ]] ; then
        return 1
    elif [[ "${1}" =~ "'" ]] ; then
        return 1
    elif [[ "${1}" = *"]"* ]] ; then
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

    if [[ "${status}" = "false" ]] ; then
        return 1
    fi

    # $1: arg
    # $2: arg(parameter) 
    if [[ "${#}" -ge 2 ]] ; then
        case "${1}" in
            --[oO][pP][eE][nN]|-[oO])
                if (file "${2}" | grep -w "cpio archive\|Apple DiskCopy 4.2 image") &> /dev/null ; then
                    local CWD="${PWD}"
                    local TMP="${CWD}/.tmp.${2##*/}"
                    if [[ -d "${TMP}" ]] ; then
                        rm -rf "${TMP}"
                    fi
                    mkdir -p "${TMP}"
                    (
                        cd "${TMP}"
                        cpio -i < "${2}"
                    ) &> /dev/null && export TMP="${TMP}" || return 1
                else
                    echo -e "\t${FUNCNAME##*:}: '${2##*/}' is not an cpio archive."
                    return 1
                fi
            ;;
            --[cC][lL][oO][sS][eE]|-[cC])
                if [[ "${#}" -ge 3 ]] ; then
                    local TMP="${2}"
                    local FILE="${3}"
                    if [[ -d "${TMP}" ]] ; then
                        (
                            cd "${TMP}"
                            find . | cpio -o > "${FILE}"
                            rm -rf "${TMP}"
                        ) &> /dev/null || return 1
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
    # max real arg lenght is 1.
    if [[ ! -e "${1}" ]] ; then
        local CWD="${PWD}"
        local TMP="${CWD}/.tmp.${1##*/}"
        if [[ -d "${1%/*}" ]] ; then
            local SAVEDIR="${1%/*}"
        else
            local SAVEDIR="${PWD}"
        fi
       
        if [[ -n "${TMP}" ]] && [[ -d "${TMP}" ]] ; then
            rm -rf "${TMP}"
        fi
        mkdir -p "${TMP}"
        (
            cd "${TMP}"
            pdb:__datam --close "${TMP}" "${SAVEDIR}/${1}" || return 1
        ) && return 0 || return 1
    else
        echo -e "\t${FUNCNAME##*:}: entity '${1##*/}' is already exist."
        return 1
    fi
}

pdb:set() {
    # max real arg lenght is 3.
    if [[ "${#}" -ge 2 ]] ; then
        local CWD="${PWD}" key="${2}" value="${3}"
        local TMP="${CWD}/.tmp.${1##*/}"
        local file="$(pdb:__realpath ${1})"

        if pdb:__allowchars "${key}" ; then
            pdb:__datam --open "${file}"
            if [[ "${?}" = 0 ]]; then
                (
                    cd "${TMP}"
                    echo "${value}" > "${key}"
                    pdb:__datam --close "${TMP}" "${file}" || return 1
                ) && return 0 || return "$?"
            else
                echo -e "\t${FUNCNAME##*:}: '${file##*/}', could not opening the archive."
                return 1
            fi
        else
            echo -e "\t${FUNCNAME##*:}: '${key}' has disallowed characters."
            return 1
        fi
    fi
}

pdb:rem() {
    # max real arg lenght is 2.
    if [[ "${#}" -ge 2 ]] ; then
        local CWD="${PWD}" key="${2}"
        local TMP="${CWD}/.tmp.${1##*/}"
        local file="$(pdb:__realpath ${1})"

        if pdb:__allowchars "${key}" ; then
            pdb:__datam --open "${file}"
            if [[ "${?}" = 0 ]]; then
                (
                    cd "${TMP}"
                    if [[ -f "${key}" ]] ; then
                        rm -f "${key}"
                    fi
                    pdb:__datam --close "${TMP}" "${file}" || return 1
                ) && return 0 || return "$?"
            else
                echo -e "\t${FUNCNAME##*:}: '${file##*/}', could not opening the archive."
                return 1
            fi
        else
            echo -e "\t${FUNCNAME##*:}: '${key}' has disallowed characters."
            return 1
        fi
    fi
}

pdb:get() {
    # max real arg lenght is 2.
    if [[ "${#}" -ge 2 ]] ; then
        local CWD="${PWD}" key="${2}"
        local TMP="${CWD}/.tmp.${1##*/}"
        local file="$(pdb:__realpath ${1})"

        if pdb:__allowchars "${key}" ; then
            pdb:__datam --open "${file}"
            if [[ "${?}" = 0 ]]; then
                (
                    local status="true"
                    cd "${TMP}"
                    if [[ -f "${key}" ]] ; then
                        cat "${key}"
                    else
                        local status="false"
                    fi
                    pdb:__datam --close "${TMP}" "${file}" || return 1
                    if [[ "${status}" = "false" ]] ; then
                        return 2
                    fi
                ) && return 0 || return "$?"
            else
                echo -e "\t${FUNCNAME##*:}: '${file##*/}', could not opening the archive."
                return 1
            fi
        else
            echo -e "\t${FUNCNAME##*:}: '${key}' has disallowed characters."
            return 1
        fi
    fi
}

if [[ "${BASH_SOURCE}" = "${BASH_SOURCE[-1]}" ]] ; then
    while [[ "${#}" -gt 0 ]] ; do
        case "${1}" in
            --[nN][eE][wW]|-[nN])
                shift
                if [[ -n "${1}" ]] ;  then
                    pdb:new "${1}" && echo "=> '${1##*/}' created." || { 
                        echo "=> db: '${1##*/}' could not creating."
                        exit "$?"
                    }
                    shift
                fi
            ;;
            --[sS][eE][tT]|-[sS])
                shift
                if [[ "${#}" -ge 3 ]] ; then
                    pdb:set "${1}" "${2}" "${3}" && echo "=> key '${1}' created in '${2##*/}' with the value '${3}'." || {
                        echo "=> key: '${2}' could not creating."
                        exit "$?"
                    }
                    shift 3
                else
                    echo -e "\t${0##*/}: insufficient parameter."
                    exit 1
                fi
            ;;
            --[rR][eE][mM]|-[rR])
                shift
                if [[ "${#}" -ge 2 ]] ; then
                    pdb:rem "${1}" "${2}" && echo "=> key '${2}' removed from '${1##*/}'." || {
                        echo "=> key: '${2}' could not removing."
                        exit "$?"
                    }
                    shift 2
                else
                    echo -e "\t${0##*/}: insufficient parameter."
                    exit 1
                fi
            ;;
            --[gG][eE][tT]|-[gG])
                shift
                if [[ "${#}" -ge 2 ]] ; then
                    pdb:get "${1}" "${2}" || {
                        echo "=> key '${2}' could not be called from '${1##*/}'."
                        exit "$?"
                    }
                    shift 2
                else
                    echo -e "\t${0##*/}: insufficient parameter."
                    exit 1
                fi
            ;;
            *)
                shift
            ;;
        esac
    done
fi