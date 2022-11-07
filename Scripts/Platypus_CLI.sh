# CLI version of Platypus desktop launcher script that includes --interpreter-args to add login shell command
# Creates installer in $CWD

/usr/local/bin/platypus --app-icon '/Applications/Platypus.app/Contents/Resources/PlatypusDefault.icns'  \
--name 'StartNURS6293'  --interface-type 'Text Window' --text-font 'Monaco 9' \
--interpreter '/bin/bash'  --interpreter-args '-l' \
--overwrite \
'/Users/kahnmi/Dropbox/Mac/Documents/git/nurs6293/Course_Images/n6293_ui.git/Scripts/startCompose7.sh'


