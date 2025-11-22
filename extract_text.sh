#!/bin/bash
# Script pour extraire le texte des passages depuis trad-francaise.html

extract_verses() {
    local book=$1
    local chapter=$2
    local start_verse=$3
    local end_verse=$4
    
    # Trouver le début du chapitre
    local chapter_pattern="<div class=\"chap\">${book} ${chapter}</div>"
    local start_line=$(grep -n "$chapter_pattern" trad-francaise.html | cut -d: -f1)
    
    if [ -z "$start_line" ]; then
        echo ""
        return
    fi
    
    # Extraire les versets
    local result=""
    for verse in $(seq $start_verse $end_verse); do
        verse_str=$(printf "%02d" $verse)
        verse_text=$(sed -n "${start_line},${start_line}+200p" trad-francaise.html | grep -A 1 "<span class=\"ver\">${verse_str}</span>" | sed -n 's/.*<span class="text">\(.*\)<\/span>.*/\1/p' | sed 's/<[^>]*>//g' | sed 's/&nbsp;/ /g' | sed 's/&amp;/\&/g' | sed 's/&lt;/</g' | sed 's/&gt;/>/g' | tr -d '\n' | sed 's/  */ /g')
        if [ ! -z "$verse_text" ]; then
            result="${result}${verse_text} "
        fi
    done
    
    echo "$result" | sed 's/ $//'
}

# Test
extract_verses "MATTHIEU" 26 1 16
