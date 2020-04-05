
#!/bin/bash
# Bash Menu Script Example

source show_spinner.sh

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
BACKTITLE="ASSHOLE LITIGATION TOOLKIT"
TITLE="ASSHOLE LITIGATION TOOL: $(Date)"
MENU="Choose one of the following options:"

OPTIONS=(1 "Rename all files by MD5-hash (c45144ab5~64fe4db.pdf)"
         2 "Convert PDFs to TIFFs (c4514a5~f644db.pdf-001.TIFF-.pdf-002.TIFF...)(10MB)"
         3 "Rotate TIFFs 90 degrees"
         4 "Watermark TIFFs with Statement (scripts/watermark.txt)"
         5 "Convert TIFFs to PDFs"
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
RES_CONFIGURATION="-r200x200"

function change_tiff_res () {
  set RES_CONFIGURATION=RES_ONEHUNDREDMB
}

ENCR_PASSWORD="MvPwpSuCJqqRLxPhgzKrtkzMVLWsWFmLn58w59hQauHWyDxVHNBFC4HSg5QRGgVTa9AC3b5wLUyFtNApJhzZGmf9N6DcZputdp7yHMuTvDH9bgtC"

function convert_tiffs_to_pdfs () {
  echo "function to convert tiffs to pdfs"
  echo
  echo "listing all *.tiffs to consider"
  colorls -al --report *.TIFF;
  echo
  echo "number of tiffs to be processed: " $(ls -al *.TIFF | wc -l)
  echo
  echo "you have two seconds to cancel..."; sleep 2
  echo
  mogrify -verbose -format pdf *.TIFF
  echo
  echo "now removing the TIFFs"
  rm -v *.TIFF;
  echo
  echo "let's list the pdfs that were created"
  echo
  colorls -al --report *.TIFF;
  echo
  echo "you have 2 seconds to review before returning to menu"
  sleep 2
  echo
  ../script/process_discovery.sh
}

function convert_pdfs_to_tiffs () {
  echo "function convert pdfs to tiffs"
  echo
  echo "listing pdfs to consider"
  echo
  colorls -al --report *.pdf
  echo
  echo "number of PDF files to be processed: " $(ls -l *.pdf | wc -l)
  echo
  set RES_CONFIGURATION=${RES_TENMB}
  echo "resolution set to: ${RES_CONFIGURATION}"
  echo
  echo "let's help the other party by making these files super high resolution, and required special A4 paper..."
  echo
  echo "you have two seconds to cancel..."; sleep 2
  find . -name '*.pdf' -exec time gs -q -dCOLORSCREEN -dDITHERPPI=20 -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dNOSUBSTDEVICECOLORS \
  -sDEVICE=tiff24nc "${RES_CONFIGURATION}" -dBATCH -sNOPAUSE -sPAPERSIZE=a4 -sOutputFile="{}-%03d.TIFF" ""{}"" \;
  find . -name '*.PDF' -exec time gs -q -dCOLORSCREEN -dDITHERPPI=20 -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dNOSUBSTDEVICECOLORS \
  -sDEVICE=tiff24nc "${RES_CONFIGURATION}" -dBATCH -sNOPAUSE -sPAPERSIZE=a4 -sOutputFile="{}-%03d.TIFF" ""{}"" \;
  echo
  echo "removing the pdfs....we don't need them anymore..."
  echo
  rm -v *.pdf; rm -v *.PDF;
  echo
  echo "lets list out all our new TIFFs..."
  colorls -al --report *.TIFF
  echo
  echo "you have two seconds to review...before returning to main menu..."
  sleep 2
  ../script/process_discovery.sh
}

FILE_COUNT=0

function rotate_tiffs_one_sixty () {
  echo "rotating tiffs onesixy" \;
  FILE_COUNT=`ls -1 *.TIFF 2>/dev/null | wc -l`
  #read -n 1 -s -r -p "Press any key to continue ROTATE 185 degrees"
  mogrify -verbose -rotate 185 *.TIFF
  ls -al *.TIFF~
  echo 'removing temporary files'
  rm -v *.TIFF~
  echo 'current image files left'
  ls *.TIFF
  ../script/process_discovery.sh
}

function rotate_tiffs_one_eighty () {
  echo "rotating tiffs one eighty" \;
  FILE_COUNT=`ls -1 *.TIFF 2>/dev/null | wc -l`
  #read -n 1 -s -r -p "Press any key to continue ROTATE 185 degrees"
  mogrify -verbose -rotate 180 *.TIFF
  ls -al *.TIFF~
  echo 'removing temporary files'
  rm -v *.TIFF~
  echo 'current image files left'
  ls *.TIFF
  ../script/process_discovery.sh
}

function rotate_tiffs_ninety () {
  echo "rotating tiffs sideways" \;
  FILE_COUNT=`ls -1 *.TIFF 2>/dev/null | wc -l`
  echo
  mogrify -verbose -rotate 90 *.TIFF
  echo
  colorls --al --report
  echo
  echo "removing temporary TIFF~ files"
  echo
  rm -v *.TIFF~
  echo
  echo 'cleaned up directory...'
  colorls
  echo
  echo "review files..."
  open .
  echo "you have five seconds before return to menu"
  ../script/process_discovery.sh
}


function create_watermark_file () {
  dialog --inputbox "Enter Watermark Phase:" 8 40 2>script/watermark.txt
}

WATERMARK_DEFAULT='PARTY VS PARTY CASE NO 123456-789'

function watermark_tiffs_with_statement () {
  echo "watermarking tiffs with statement"
  echo "lets fetch it from file:"
  cat ../script/watermark.txt
  echo
  if [ -f ../script/watermark.txt ]; then
    WATERMARK_DEFAULT="$(cat ../script/watermark.txt)"
    list="find . -name *.TIFF -o -name '*.tiff'"
    for F in ${list}; do convert ${F} -verbose -font Arial -pointsize 30 -draw \
    "gravity south fill black text 0,8 '${WATERMARK_DEFAULT}' \
    fill white text 1,11 '' " \
    ${F}; done
    echo
    echo "watermark complete"
    echo "listing out the processed files..."
    colorls -al --report
    echo
  else
    create_watermark_file
  fi
  echo
  echo "check watermarks manually by clicking on the file..."
  open .
  echo
  echo "sleeping for 5 seconds while you check out the files..."
  sleep 5
  ../script/process_discovery.sh
}

function calculate_md5_hash () {
  echo "renaming all files to md5"
  for F in $DIR*.*; do echo "$F" "$(md5 "$F" | cut -d' ' -f4).${F##*.}"; done
}

function remove_whitespace () {
  for f in *\ *; do mv "$f" "${f// /_}"; done
}

function calculate_md5_hash_rename_file () {
  echo
  colorls -al --report
  sleep 2
  echo
  echo "renaming all files to md5"
  echo
  sleep 1
  echo
  echo "fix any files with spaces in it";   remove_whitespace;
  echo
  echo "whitespaces gone"
  sleep 1
  echo
  colorls -al --report
  echo
  sleep 1
  echo "computer file md5 hash and replace filename..."
  echo
  #preserves filename and adds the hash
  #find . -name '*.pdf' -exec bash -c 'mv $1 "${1%.*}.$(md5 -q $1).${1##*.}"' bash {} \;
  #find . -name '*.PDF' -exec bash -c 'mv $1 "${1%.*}.$(md5 -q $1).${1##*.}"' bash {} \;
  echo "two seconds to cancel..."; sleep 2
  #why give away the filename and make it easy to organize documents?
  # replace the name of the file with the md5hash
  find . -name '*.pdf' -exec bash -c 'mv $1 "$(md5 -q $1).${1##*.}"' bash {} \;
  find . -name '*.PDF' -exec bash -c 'mv $1 "$(md5 -q $1).${1##*.}"' bash {} \;
  echo
  echo "md5 hash renaming complete..."
  echo
  colorls -al --report
  echo
  sleep 1
  ../script/process_discovery.sh
}

function create_encryption_password () {
  dialog --inputbox "Enter an encryption key:" 8 40 2>../script/encryption_key.txt
  echo "writing encryption password to file: ../script/encryption_key.txt"
  echo
  cat ../script/encryption_key.txt
  echo
  ../script/process_discovery.sh
}

function encrypt_all_tiffs () {
  echo "encrypting all tiffs with password"
  echo
  echo "key is defined as..."
  echo
  cat ../script/encryption_key.txt
  echo
  echo
  if [ -f ../script/encryption_key.txt ]; then
    for i in *.TIFF; do echo "applying encryption key to $i"; time 7z a $i.7z -p"$(cat ../script/encryption_key.txt)" -mhe $i; done
    echo "removing *.TIFFs"
    echo
    rm -v *.TIFF
    echo
    colorls -al --report
    echo
    echo "listing final compressed 7z/password protected files..."
    sleep 5
  else
    echo "ask user to provide a key since none exists"
    create_encryption_password
  fi
  echo "return to menu"
  sleep 2
  ../script/process_discovery.sh
}

function decrypt_all_tiffs () {
  echo "decrypting all tiffs with password"
  if [ -f ../script/encryption_key.txt ]; then
    echo "proceeding with dencryption"
    echo "decrypting/decompressing with:"
    cat ../script/encryption_key.txt
    echo
    for i in *.7z; do echo "applying dencryption key to $i"; time 7z x $i -p"$(cat ../script/encryption_key.txt)"; done
    rm -v *.7z
    colorls -al --report
    sleep 1
  else
    create_encryption_password
  fi
  ../script/process_discovery.sh
}

function package_files () {
  echo "package files in some annoying way"
}

function wipe_all_tiff_metadata () {
  echo "exiftool to remove all metadata"
  for i in *.TIFF; do echo "wiping metadata from $i"; exiftool -all= "$i"; done
  echo "removing the autobackup .originals"
  rm -v *_original
  ../script/process_discovery.sh
}

function list_files_viewing () {
  echo
  echo "listing files..."
  colorls -al --report
  echo
  echo "five seconds to review..."
  sleep 5
  echo
  ../script/process_discovery.sh
}

function explain_shit () {
  dialog --title "Asshole Litigation Toolkit" --infobox \
  "`cat ../script/about.txt`" 70 150
  sleep 15
  #../script/process_discovery.sh
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
              rotate_tiffs_ninety
              ;;
          4)
              watermark_tiffs_with_statement
              ;;
          5)
              convert_tiffs_to_pdfs
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
