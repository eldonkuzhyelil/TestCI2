#/usr/bin/env bash
# -bname build name
# -wspace build workspace dir
# -lcommit builds last commit

#read command line args
while getopts b:w:l: option
do
        case "${option}"
        in
                b) BNAME=${OPTARG};;
                w) WSPACE=${OPTARG};;
                l) LCOMMIT=${OPTARG};;
        esac
done

echo Build Name: $BNAME
echo Workspace: $WSPACE
echo Last Commit: $LCOMMIT

#change working directory to the dir for this build
echo Changing working directory to "D:\Jenkins\workspace\FirstProject\TestCI2"
cd "D:\Jenkins\workspace\FirstProject\TestCI2"

# check for the existence of an existing commit file for this
# project
SCRIPTFILE="D:\Jenkins\workspace\FirstProject\TestCI2\lastcommit\$BNAME.txt"
echo Searching for script file $SCRIPTFILE   ...
if [  $SCRIPTFILE ]
then
        PREVRSA=$(<$SCRIPTFILE) &&
        echo Found previous SHA $PREVRSA

        # Backup existing Package.xml
        cd $WSPACE/src
        echo changing directoy to $WSPACE
		
        xcopy package.xml{,.bak} /Y &&
        #xcopy "package.xml" "package.xml.bak"
		echo Backing up package.xml to package.xml.bak &&
        read -d '' NEWPKGXML <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<Package>
</Package>
EOF
        echo ===PKGXML===
        echo $NEWPKGXML
        echo Creating new package.xml
        echo $NEWPKGXML > $WSPACE/src/package.xml
		
        for CFILE in `git diff-tree --no-commit-id --name-only -r head`
		
		#git diff-tree --no-commit-id --name-only -r head
		#echo cfile "$CFILE"
        do
                echo Analyzing file basename $CFILE

                case "$CFILE"
                in
                        *.cls*) TYPENAME="ApexClass";;
                        *.page*) TYPENAME="ApexPage";;
                        *.component*) TYPENAME="ApexComponent";;
                        *.trigger*) TYPENAME="ApexTrigger";;
                        *.app*) TYPENAME="CustomApplication";;
                        *.labels*) TYPENAME="CustomLabels";;
                        *.object*) TYPENAME="CustomObject";;
                        *.tab*) TYPENAME="CustomTab";;
                        *.resource*) TYPENAME="StaticResource";;
                        *.workflow*) TYPENAME="Workflow";;
                        *.remoteSite*) TYPENAME="RemoteSiteSettings";;
                        *.pagelayout*) TYPENAME="Layout";;
                        *) TYPENAME="UNKNOWN TYPE";;
                esac

                if [[ "$TYPENAME" != "UNKNOWN TYPE" ]]
                then
						#basename $CFILE

						echo cfile "$CFILE"
						
						
						NOEXTENSION="${CFILE%.*}"
						
						#for /F %i in ("c:\foo\pdf.cls") do @echo %~ni
						#for /F %%i in ("$CFILE") do @echo %%~ni
						
						echo NOEXTENSION NAME1: $NOEXTENSION
                        ENTITY="${NOEXTENSION##*"/"}"
						
						
                        echo ENTITY NAME: $ENTITY

                        #if grep -Fq "$TYPENAME" $WSPACE/src/package.xml
						if  findstr "$TYPENAME" "$WSPACE\src\package.xml"
                        then
								echo "$TYPENAME" is inside package.xml
                                echo Generating new member for $ENTITY
                                xml ed -L -s "/Package/types[name='$TYPENAME']" -t elem -n members -v "$ENTITY" $WSPACE/src/package.xml
                        else
								
								echo "$TYPENAME" is NOT inside package.xml
                                echo Generating new $TYPENAME type
                                xml ed -L -s /Package -t elem -n types -v "" $WSPACE/src/package.xml
                                xml ed -L -s '/Package/types[not(*)]' -t elem -n name -v "$TYPENAME" $WSPACE/src/package.xml
                                echo Generating new member for $ENTITY
                                xml ed -L -s "/Package/types[name='$TYPENAME']" -t elem -n members -v "$ENTITY" $WSPACE/src/package.xml
                        fi
                else
                        echo ERROR: UNKNOWN FILE TYPE $CFILE
                fi
                echo ====UPDATED PACKAGE.XML====
                #type "$WSPACE\src\package.xml"
        done
        echo Saving last RSA Commit
        echo $LCOMMIT > "D:\Jenkins\workspace\FirstProject\lastcommit\$BNAME.txt"
        echo Cleaning up Package.xml
        xml ed -L -s /Package -t elem -n version -v "27.0" $WSPACE/src/package.xml
        xml ed -L -i /Package -t attr -n xmlns -v "http://soap.sforce.com/2006/04/metadata" $WSPACE/src/package.xml

        echo ====FINAL PACKAGE.XML=====
        #type "$WSPACE\src\package.xml"
else
        echo No RSA found, default Package.xml will be used
        echo Creating new list commit file
        echo $LCOMMIT > "D:\Jenkins\workspace\FirstProject\lastcommit\'$BNAME'.txt"
fi