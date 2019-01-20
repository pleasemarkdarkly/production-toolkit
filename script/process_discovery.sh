
#!/bin/bash
# Bash Menu Script Example

#@TODO
#@TODO  after creating tiffs, move originals into PDF folder
#@TODO  save encryption password to file, and error function unless it has been created
#@TODO  after function executes, figure out how to jump back into the menu
#@TODO


# convert all pdfs into jpegs
# time speed of seletions
#gs -dNOPAUSE -sDEVICE=jpeg -r600 -sOutputFile=p%03d.jpg file.pdf
#gs -q -dNOPAUSE -sDEVICE=tiffg4 -sOutputFile=a.tif foo.pdf -c quit

HEIGHT=40
WIDTH=100
CHOICE_HEIGHT=15
BACKTITLE="ASSHOLE LITIGATION TOOL"
TITLE="ASSHOLE LITIGATION TOOL"
MENU="Choose one of the following options:"

OPTIONS=(1 "Rename all files by MD5-hash (c45144ab5~64fe4db.pdf)"
         2 "Convert PDFs to TIFFs (c4514a5~f644db.pdf-001.TIFF-.pdf-002.TIFF...)(10MB)"
         3 "Rotate TIFFs 183 degrees"
         4 "Watermark TIFFs with Statement (scripts/watermark.txt)"
         5 "List Files"
         6 "Create encryption key (scripts/encryption_key.txt)"
         7 "Wipe All Metadata from TIFFs (exiftool)"
         8 "Encrypt/Compress TIFF files with (script/encryption_key.txt) (7z)"
         9 "Descrypt/Uncompreess 7z files with (script/encryption_key.txt)"
        10 "Change TIFF default size (10MB/100MB/1GB)"
        11 "About"
         )

MD5HASH="SAMPLE MD5"
WM_TILE="The quick brown fox jumped over the fence."
WM_DATE=""
WM_CAPTION=""
WM_MSG=""

RES_FOURHUNDREDMB="-r1200x1200"
RES_ONEHUNDREDMB="-r600x600"
RES_EIGHTEENMB="-r300x300"
RES_TENMB="-r150x150"
RES_CONFIGURATION="-r450x450"

function change_tiff_res () {
  set RES_CONFIGURATION=RES_ONEHUNDREDMB
}

ENCR_PASSWORD="Imaging Computers That You Don't Own Is Illegal"



function convert_pdfs_to_tiffs () {
  echo "function convert pdfs to tiffs"
  echo "listing pdfs to consider"
  echo
  colorls -al --report *.pdf
  echo
  echo "number of PDF files to be processed: " $(ls -l *.pdf | wc -l)
  echo
  set RES_CONFIGURATION=${RES_TENMB}
  echo "resolution set to: ${RES_CONFIGURATION}"
  #read -n 1 -s -r -p "Press any key to continue PDF to TIFF"
  find . -name *.pdf -exec time gs -q -dCOLORSCREEN -dDITHERPPI=20 -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dNOSUBSTDEVICECOLORS \
  -sDEVICE=tiff24nc "${RES_CONFIGURATION}" -dBATCH -sNOPAUSE -sPAPERSIZE=a4 -sOutputFile="{}-%03d.TIFF" "{}" \;

  mkdir "Originals"
  mv *.pdf Originals
}

FILE_COUNT=0

function rotate_tiffs_one_sixty () {
  echo "rotating tiffs onesixy" \;
  FILE_COUNT=`ls -1 *.TIFF 2>/dev/null | wc -l`
  read -n 1 -s -r -p "Press any key to continue ROTATE 185 degrees"
  mogrify -verbose -rotate 185 *.TIFF
  ls -al *.TIFF~
  echo 'removing temporary files'
  rm -v *.TIFF~
  echo 'current image files left'
  ls -al
}

function create_watermark_file () {
  dialog --inputbox "Enter Watermark Phase:" 8 40 2>script/watermark.txt
}

WATERMARK_DEFAULT='SCHWEICKERT CASE No. 18-3-01411-9 SEA KEANE'

function watermark_tiffs_with_statement () {
  echo "watermarking tiffs with statement"

  #read -n 1 -s -r -p "Press any key to continue WATERMARKING FILES"
  if [ -f script/watermark.txt ]; then
    WATERMARK_DEFAULT="$(cat script/watermark.txt)"
    list='find . -name *.TIFF'
    for F in ${list}; do convert ${F} -verbose -font Arial -pointsize 100 -draw \
    "gravity south fill black text 0,12 '${WATERMARK_DEFAULT}' \
    fill white text 1,11 '' " \
    ${F}; done
    ls -al
  else
    create_watermark_file
  fi
}

function calculate_md5_hash () {
  echo "renaming all files to md5"
  for F in $DIR*.*; do echo "$F" "$(md5 "$F" | cut -d' ' -f4).${F##*.}"; done
}

function calculate_md5_hash_rename_file () {
  echo "renaming all files to md5"
  mkdir Originals
  # don't forget to remove mv originals so we don't duplicate and super increase size of production
  for F in $DIR*.pdf; do cp -rv "$F" "$(md5 "$F" | cut -d' ' -f4).${F##*.}"; mv -v "$F" Originals; done
  echo
}

function create_encryption_password () {
  dialog --inputbox "Enter an encryption key:" 8 40 2>script/encryption_key.txt
  echo "writing encryption password to file: script/encryption_key.txt"
  cat script/encryption_key.txt
}

function encrypt_all_tiffs () {
  echo "encrypting all tiffs with password"
  if [ -f script/encryption_key.txt ]; then
    echo "encription_key set applying...."
    echo "proceeding with encryption"
    for i in *.TIFF; do echo "applying encryption key to $i"; time 7z a $i.7z -p"$(cat script/encryption_key.txt)" -mhe $i; done
    rm -v *.TIFF
    colorls -al --report
  else
    create_encryption_password
  fi
}

function decrypt_all_tiffs () {
  echo "decrypting all tiffs with password"
  if [ -f script/encryption_key.txt ]; then
    echo "proceeding with dencryption"
    for i in *.7z; do echo "applying dencryption key to $i"; time 7z x $i -p"$(cat script/encryption_key.txt)"; done
    rm -v *.7z
    colorls -al --report
  else
    create_encryption_password
  fi
}

function package_files () {
  echo "package files in some annoying way"
}

function wipe_all_tiff_metadata () {
  echo "exiftool to remove all metadata"
  for i in *.TIFF; do echo "wiping metadata from $i"; exiftool -all= "$i"; done
  echo "removing the autobackup .originals"
  rm -v *_original
}

function list_files_viewing () {
  echo "list files"
  colorls -al --report
}

function explain_shit () {
  dialog --title "Asshole Litigation Toolkit" --infobox \
  "`cat script/about.txt`" 70 150
}

function process_user_commands () {
CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

  clear
  case $CHOICE in
          1)
              calculate_md5_hash_rename_file
              ;;
          2)
              convert_pdfs_to_tiffs
              ;;
          3)
              rotate_tiffs_one_sixty
              ;;
          4)
              watermark_tiffs_with_statement
              ;;
          5)
              list_files_viewing
              ;;
          6)
              create_encryption_password
              ;;
          7)
              wipe_all_tiff_metadata
              ;;
          8)
              encrypt_all_tiffs
              ;;
          9)
              decrypt_all_tiffs
              ;;
          10)
              change_tiff_res
              ;;
          11)
              explain_shit
              ;;
  esac
}

process_user_commands
