#!/bin/bash
declare -A dictionary=(
    ["â"]="a"
    ["æ"]="a"
    ["ç"]="c"
    ["é"]="e"
    ["è"]="e"
    ["ê"]="e"
    ["ë"]="e"
    ["ï"]="i"
    ["î"]="i"
    ["ô"]="o"
    ["œ"]="o"
    ["û"]="u"
    ["ù"]="u"
    ["ü"]="u"
    ["ÿ"]="y"
    ["ä"]="a"
    ["ö"]="o"
    ["ü"]="u"
    ["ß"]="s"
    ["ʔ"]="2"
    ["ā"]="a"
    ["ǟ"]="e"
    ["ḅ"]="b"
    ["ʕ"]="3"
    ["ḏ"]="d"
    ["̣ḏ"]="d"
    ["ē"]="e"
    ["ġ"]="g"
    ["ǧ"]="g"
    ["ḥ"]="h"
    ["ī"]="i"
    ["ᴵ"]="i"
    ["ə"]="e"
    ["ᵊ"]="e"
    ["ḷ"]="l"
    ["ṃ"]="m"
    ["ō"]="o"
    ["ṛ"]="r"
    ["ṣ"]="s"
    ["š"]="s"
    ["ṭ"]="t"
    ["ṯ"]="t"
    ["ū"]="u"
    ["ẓ"]="z"
    ["ž"]="z"
)
 
for letter in "${!dictionary[@]}"; do
    lowercase_from=$(echo $letter | sed 's/[[:upper:]]*/\L&/')
    lowercase_to=$(echo ${dictionary[$letter]} | awk '{print tolower($0)}')
    dictionary[$lowercase_from]=$lowercase_to
done
 
function transliterate {
    string=$1
    for letter in "${!dictionary[@]}"; do
        string=${string//$letter/${dictionary[$letter]}}
    done
 
    echo $string;
}
 
for f in "$@"
do
    if [ ! -f "$f" ]; then
        echo "$(basename "$0") warn: this is not a regular file (skipped): $f" >&2
        continue
    fi
 
    DIR=$(dirname "$f")
    BASENAME="$(basename "$f")"
    # convert non-latin chars using my transliterate script OR uconv from the icu-devtools package
    NEWFILENAME=$(transliterate "$BASENAME") 
     
    if [ -f "$DIR/$NEWFILENAME" ]; then
        echo "$BASENAME warn: target filename already exists (skipped): $BASENAME/$NEWFILENAME" >&2
        continue
    fi
 
    if [ "$BASENAME" != "$NEWFILENAME" ]; then
        echo "\`$f' -> \`$NEWFILENAME'"
        mv -i "$f" "$DIR/$NEWFILENAME"
    fi
done