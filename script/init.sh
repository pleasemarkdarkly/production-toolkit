echo 'cleaning test folder'


function list () {
	colorls -al --report 
}

read -p "Do you want to delete all .TFFs?" yn
case $yn in
	[Yy]* ) rm -v *.TIFF;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
esac
read -p "Do you want to have a fresh TEST.PDF file to work with?" yn
case $yn in
        [Yy]* ) cp -v Original/TEST.PDF .
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
esac
list

