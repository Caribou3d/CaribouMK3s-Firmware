#!/bin/bash
#
# lang-import.sh - multi-language support script
#  for importing translated xx.po

LNG=$1
# if no arguments, 'all' is selected (all po and also pot will be generated)
if [ -z "$LNG" ]; then LNG=all; fi

# if 'all' is selected, script will generate all po files and also pot file
if [ "$LNG" = "all" ]; then
 ./lang-import.sh cz
 ./lang-import.sh de
 ./lang-import.sh es
 ./lang-import.sh fr
 ./lang-import.sh it
 ./lang-import.sh pl
 exit 0
fi

# language code (iso639-1) is equal to LNG
LNGISO=$LNG
# exception for 'cz' (code='cs')
if [ "$LNG" = "cz" ]; then LNGISO=cs; fi

# cd to input folder
cd po/new

# check if input file exists
if ! [ -e $LNGISO.po ]; then
 echo "Input file $LNGISO.po not found!" >&2
 exit -1
fi

#convert '\\e' sequencies to 'x1b' and '\\' to '\'
cat $LNGISO.po | sed 's/\\e/\\x1b/g;s/\\\\/\\/g' > $LNG'_filtered.po'

#replace '\n' with ' ' (single space)
sed -i 's/ \\n/ /g;s/\\n/ /g' $LNG'_filtered.po'

#replace special characters in translation see https://www.utf8-chartable.de/unicode-utf8-table.pl?start=256&number=128&names=-&utf8=string-literal
https://www.utf8-chartable.de/unicode-utf8-table.pl?start=128&number=128&utf8=string-literal&unicodeinhtml=hex
http://www.fileformat.info/info/charset/UTF-8/list.htm
#replace in czech translation
if [ "$LNG" = "cz" ]; then
 #replace 'ž' with 'z' (z-caron
 sed -i 's/\xc5\xbe/z/g' $LNG'_filtered.po'
 #replace 'e' with 'e' (e-caron)
 sed -i 's/\xc4\x9b/e/g' $LNG'_filtered.po'
 #replace 'í' with 'i' (i-acute)
 sed -i 's/\xc3\xad/i/g' $LNG'_filtered.po'
 #replace 'r' with 'r' (r-caon)
 sed -i 's/\xc5\x99/r/g' $LNG'_filtered.po'
 #replace 'c' with 'c' (c-caron)
 sed -i 's/\xc4\x8d/c/g' $LNG'_filtered.po'
 #replace 'á' with 'a' (a-acute)
 sed -i 's/\xc3\xa1/a/g' $LNG'_filtered.po'
 #replace 'é' with 'e' (e-acute)
 sed -i 's/\xc3\xa9/e/g' $LNG'_filtered.po'
fi

#replace in german translation https://en.wikipedia.org/wiki/German_orthography
if [ "$LNG" = "de" ]; then
 #replace 'ä' with 'ae' (a-diaeresis)
 sed -i 's/\xc3\xa4/ae/g' $LNG'_filtered.po'
 #replace 'Ä' with 'Ae' (A-diaeresis)
 sed -i 's/\xc3\x84/Ae/g' $LNG'_filtered.po'
 #replace 'ü' with 'ue' (u-diaeresis)
 sed -i 's/\xc3\xbc/ue/g' $LNG'_filtered.po'
 #replace 'Ü' with 'Ue' (U-diaeresis)
 sed -i 's/\xc3\x9c/Ue/g' $LNG'_filtered.po'
 #replace 'ö' with 'oe' (o-diaeresis)
 sed -i 's/\xc3\xb6/oe/g' $LNG'_filtered.po'
 #replace 'Ö' with 'Oe' (O-diaeresis)
 sed -i 's/\xc3\x96/Oe/g' $LNG'_filtered.po'
 #replace 'ß' with 'ss' (s-sharp s)
 sed -i 's/\xc3\x9f/ss/g' $LNG'_filtered.po'
fi

#replace in spain translation
if [ "$LNG" = "es" ]; then
 #replace 'á' with 'a' (a-acute)
 sed -i 's/\xc3\xa1/a/g' $LNG'_filtered.po'
 #replace '¿' with '?' (inverted question mark)
 sed -i 's/\xc2\xbf/?/g' $LNG'_filtered.po'
 #replace 'ó' with 'o' (o-acute)
 sed -i 's/\xc3\xb3/o/g' $LNG'_filtered.po'
 #replace 'é' with 'e' (e-acute)
 sed -i 's/\xc3\xa9/e/g' $LNG'_filtered.po'
 #replace 'í' with 'i' (i-acute)
 sed -i 's/\xc3\xad/i/g' $LNG'_filtered.po'
 #replace '!' with '!' (inverted excamation mark)
 sed -i 's/\xc2\xa1/!/g' $LNG'_filtered.po'
 #replace 'n~' with 'n' (n-tilde)
 sed -i 's/\xc3\xb1/n/g' $LNG'_filtered.po'
fi

#replace in french translation https://en.wikipedia.org/wiki/French_orthography
if [ "$LNG" = "fr" ]; then
 #replace 'á' with 'a' (a-acute)
 sed -i 's/\xc3\xa1/a/g' $LNG'_filtered.po'
 #replace 'Á' with 'A' (A-acute)
 sed -i 's/\xc3\x81/A/g' $LNG'_filtered.po'
 #replace 'à' with 'a' (a-grave)
 sed -i 's/\xc3\xa0/a/g' $LNG'_filtered.po'
 #replace 'À' with 'A' (A-grave)
 sed -i 's/\xc3\x80/A/g' $LNG'_filtered.po'
 #replace 'â' with 'a' (a-circumflex)
 sed -i 's/\xc3\xa2/a/g' $LNG'_filtered.po'
 #replace 'Â' with 'A' (A-circumflex)
 sed -i 's/\xc3\x82/A/g' $LNG'_filtered.po'
 #replace 'ç' with 'c' (c-cedilla)
 sed -i 's/\xc3\xa7/c/g' $LNG'_filtered.po'
 #replace 'Ç' with 'C' (C-cedilla)
 sed -i 's/\xc3\x87/C/g' $LNG'_filtered.po'
 #replace 'é' with 'e' (e-acute)
 sed -i 's/\xc3\xa9/e/g' $LNG'_filtered.po'
 #replace 'É' with 'E' (E-acute)
 sed -i 's/\xc3\x89/E/g' $LNG'_filtered.po'
 #replace 'è' with 'e' (e-grave)
 sed -i 's/\xc3\xa8/e/g' $LNG'_filtered.po'
 #replace 'È' with 'E' (E-grave)
 sed -i 's/\xc3\x88/E/g' $LNG'_filtered.po'
fi

#replace in italian translation
if [ "$LNG" = "it" ]; then
 #replace 'è' with 'e' (e-grave)
 sed -i 's/\xc3\xa8/e/g' $LNG'_filtered.po'
 #replace 'á' with 'a' (q-acute)
 sed -i 's/\xc3\xa0/a/g' $LNG'_filtered.po'
 #replace 'ó' with 'o' (o-acute)
 sed -i 's/\xc3\xb2/o/g' $LNG'_filtered.po'
 #replace 'ú' with 'u' (u-acute)
 sed -i 's/\xc3\xb9/u/g' $LNG'_filtered.po'
 #replace 'é' with 'e' (e-acute)
 sed -i 's/\xc3\xa9/e/g' $LNG'_filtered.po'
 #replace 'É' with 'E' (E-acute)
 sed -i 's/\xc3\x88/E/g' $LNG'_filtered.po'
fi

#replace in dutch translation according to https://nl.wikipedia.org/wiki/Accenttekens_in_de_Nederlandse_spelling
if [ "$LNG" = "nl" ]; then
 #replace 'ë' with 'e' (e-diaeresis)
 sed -i 's/\xc3\xab/e/g' $LNG'_filtered.po'
 #replace 'ï' with 'i' (i-diaeresis)
 sed -i 's/\xc3\xaf/i/g' $LNG'_filtered.po'
 #replace 'é' with 'e' (e-acute)
 sed -i 's/\xc3\xa9/e/g' $LNG'_filtered.po'
 #replace 'è' with 'e' (e-grave)
 sed -i 's/\xc3\xa8/e/g' $LNG'_filtered.po'
 #replace 'ö' with 'o' (o-diaeresis)
 sed -i 's/\xc3\xb6/o/g' $LNG'_filtered.po'
 #replace 'ê' with 'e' (e-circumflex)
 sed -i 's/\xc3\xaa/e/g' $LNG'_filtered.po'
 #replace 'ü' with 'u' (u-diaeresis)
 sed -i 's/\xc3\xbc/u/g' $LNG'_filtered.po'
 #replace 'ç' with 'c' (c-cedilla)
 sed -i 's/\xc3\xa7/c/g' $LNG'_filtered.po'
 #replace 'á' with 'a' (a-acute)
 sed -i 's/\xc3\xa1/a/g' $LNG'_filtered.po'
 #replace 'à' with 'a' (a-grave)
 sed -i 's/\xc3\xa0/a/g' $LNG'_filtered.po'
 #replace 'ä' with 'a' (a-diaeresis)
 sed -i 's/\xc3\xa4/a/g' $LNG'_filtered.po'
 #replace 'û' with 'u' (u-circumflex)
 sed -i 's/\xc3\xbc/u/g' $LNG'_filtered.po'
 #replace 'î' with 'i' (i-circumflex)
 sed -i 's/\xc3\xae/i/g' $LNG'_filtered.po'
 #replace 'í' with 'i' (i-acute)
 sed -i 's/\xc3\xad/i/g' $LNG'_filtered.po'
 #replace 'ô' with 'o' (o-circumflex)
 sed -i 's/\xc3\xb4/o/g' $LNG'_filtered.po'
 #replace 'ú' with 'u' (u-acute)
 sed -i 's/\xc3\xba/u/g' $LNG'_filtered.po'
 #replace 'ñ' with 'n' (n-tilde)
 sed -i 's/\xc3\xb1/n/g' $LNG'_filtered.po'
 #replace 'â' with 'a' (a-circumflex)
 sed -i 's/\xc3\xa2/a/g' $LNG'_filtered.po'
 #replace 'Å' with 'A' (A-with ring above))
 sed -i 's/\xc3\x85/A/g' $LNG'_filtered.po'
fi

#replace in polish translation
#if [ "$LNG" = "pl" ]; then
#fi

#replace in turkish translation according to
if [ "$LNG" = "tr" ]; then
 #replace 'ç' with 'c' (c-cedilla)
 sed -i 's/\xc3\xa7/c/g' $LNG'_filtered.po'
 #replace 'Ç' with 'C' (C-cedilla)
 sed -i 's/\xc3\x87/C/g' $LNG'_filtered.po'
 #replace 'g' with 'g' (g-breve)
 sed -i 's/\xc4\x9f/g/g' $LNG'_filtered.po'
 #replace 'G' with 'G' (G-breve)
 sed -i 's/\xc4\x9e/G/g' $LNG'_filtered.po'
 #replace 'i' with 'i' (i-dotless)
 sed -i 's/\xc4\xb1/i/g' $LNG'_filtered.po'
 #replace 'I' with 'I' (I-with dot above)
 sed -i 's/\xc4\xb0/I/g' $LNG'_filtered.po'
 #replace 'ö' with 'o' (o-diaeresis)
 sed -i 's/\xc3\xb6/o/g' $LNG'_filtered.po'
 #replace 'Ö' with 'O' (O-diaeresis)
 sed -i 's/\xc3\x96/O/g' $LNG'_filtered.po'
 #replace 's' with 's' (s-cedilla)
 sed -i 's/\xc5\x9f/s/g' $LNG'_filtered.po'
 #replace 'S' with 'S' (S-cedilla)
 sed -i 's/\xc5\x9e/S/g' $LNG'_filtered.po'
 #replace 'ü' with 'u' (u-diaeresis)
 sed -i 's/\xc3\xbc/u/g' $LNG'_filtered.po'
 #replace 'Ü' with 'U' (U-diaeresis)
 sed -i 's/\xc3\x9c/Ue/g' $LNG'_filtered.po'
 #replace 'î' with 'i' (i-circumflex)
 sed -i 's/\xc3\xae/i/g' $LNG'_filtered.po'
fi

#check for nonasci characters
if grep --color='auto' -P -n '[^\x00-\x7F]' $LNG'_filtered.po' >nonasci.txt; then
 exit
fi

#join lines with multi-line string constants
cat $LNG'_filtered.po' | sed ':a;N;$!ba;s/\x22\n\x22//g' > $LNG'_new.po'

#generate new dictionary
cat ../../lang_en.txt | sed 's/\\/\\\\/g' | while read -r s; do
 /bin/echo -e "$s"
 if [ "${s:0:1}" = "\"" ]; then
#  /bin/echo -e "$s"
  s=$(/bin/echo -e "$s")
  s2=$(grep -F -A1 -B0  "$s" "$LNG"_new.po | tail -n1 | sed 's/^msgstr //')
  if [ -z "$s2" ]; then
   echo '"\x00"'
  else
   echo "$s2"
  fi
#  echo
 fi
done > lang_en_$LNG.txt
