#!/bin/bash

########################################
#### Author: Jacob Peterson
#### Creation Date: 2020-01-19
########################################


########################################
#### Script Description
########################################
# The purpose of the script is to keep the static files from my other repos
# (e.g., .html, .pdf, or .md) that I use in my website updated in the website
# repo that netlify uses to build it. I had at first tried to redirect direct
# links to the files on github, but ran into a few issues. It pulls copys of
# all of the necesary repos, checks if the files specified in the accompanying
# csv are up to date in the website repo and copies them over if they are not.
# The website repo then accepts all changes and pushes them to the github repo
# that netlify uses.


########################################
#### CSV Description
########################################
# A csv will hold specific file information. Each row dictates a particular file
# to copy over. It will contian the following columns:
#  * user - Github username for the repo (currently unused in script)
#  * repo - What repo is the file from?
#  * oriFileLoc - Relative file location for the file inside the repo directory
#  * websiteFileLoc - Relative directory for the file inside the website repo



########################################
#### Setup for Automatic Updates usig Cron
########################################
# Edit/create the crontab on the computer
#$ crontab -e

#Add this line and save the file
#*/15 * * * * /home/charles/WebsiteManagement/personal_website/update_files_from_other_repos.sh

# Verify changes with
#$ crontab -l



########################################
#### Global Variables ##################
########################################
githubRepoLoc="/home/charles/WebsiteManagement"
websiteRepo="personal_website"
csvName="update_files_from_other_repos.csv"






########################################
#### Define Functions ##################
########################################

#### Git Functions (assumes ssh has been set up with the machine)
#$1: current repo name
setup_local_repo () {
  currentRepoSSH="git@github.com:jacpete/$1.git"
  git clone ${currentRepoSSH} #clone the repo
}

#$1: current repo name
update_local_repo () {
  cd ${githubRepoLoc}
  if [ ! -d $1 ] #if repo directory doesn't exist
  then #create repo
    echo "Cloning ${1} repo to ${githubRepoLoc}"
    setup_local_repo "$1"
  else #update repo from github
    cd $1
    echo "Updating ${1} repo"
    git pull
  fi
  cd ${githubRepoLoc}
}




########################################
#### General Script ####################
########################################

#### Absolute filepath of csvName
csvName="${githubRepoLoc}/${websiteRepo}/${csvName}"
# echo "${csvName}"


#Update Website Repo
update_local_repo ${websiteRepo}
chmod +x ${csvName/.csv/.sh} #ensure the script is executable


#### Read in data from CSV
userList=($(cat $csvName |  awk -F "," '{print $1}' | awk 'NR>1' | awk 'NF > 0')) #currently nothing is done with this and the script assumes its from my username (jacpete)
repoList=($(cat $csvName |  awk -F "," '{print $2}' | awk 'NR>1' | awk 'NF > 0'))
oriFileLocList=($(cat $csvName |  awk -F "," '{print $3}' | awk 'NR>1' | awk 'NF > 0'))
websiteFileLocList=($(cat $csvName |  awk -F "," '{print $4}' | awk 'NR>1' | awk 'NF > 0'))
# deleteTermList=($(cat $csvName |  awk -F "," '{print $5}' | awk 'NR>1' | awk 'NF > 0'))

printf '%s\n' "${userList[@]}"
printf '%s\n' "${repoList[@]}"
printf '%s\n' "${oriFileLocList[@]}"
printf '%s\n' "${websiteFileLocList[@]}"
# printf '%s\n' "${deleteTermList[@]}"


#### Get List of Unique Repos
uniqRepo=($(printf '%s\n' "${repoList[@]}" | sort | uniq))
# allRepo+=(${websiteRepo})
# printf '%s\n' "${uniqRepo[@]}"



#### Update needed repos
for i in ${!uniqRepo[*]}
do
  update_local_repo ${uniqRepo[i]}
done


# printf '%s\n' "${oriFileLocList[@]}"
# printf '%s\n' "${websiteFileLocList[@]}"

#### Copy Files to the website directory
for i in ${!oriFileLocList[*]}
do
  oriFile="${githubRepoLoc}/${repoList[i]}/${oriFileLocList[i]}" #original file pathname
  websiteFileLoc="${githubRepoLoc}/${websiteRepo}/${websiteFileLocList[i]}" #website filepath


  #Split and do copy differntly for files vs directories
  if [[ -f "$oriFile" ]]
  then
    echo "File"
    filename="${oriFile##*/}" #file name
    websiteFile="${websiteFileLoc}/${filename}" #website file pathname

    if [ -f "${websiteFile}" ] #if file exists in website repo
    then
      if ! cmp ${oriFile} ${websiteFile} >/dev/null 2>&1 #if files are different in source and website repo
      then
        echo "Updating ${filename} in website repo"
        cp "${oriFile}" "${websiteFileLoc}" #copy source file to website repo
      fi
    else
      echo "Adding ${filename} to website repo"
      mkdir -p "${websiteFileLoc}" #ensure filepath exists and create if not
      cp "${oriFile}" "${websiteFileLoc}" #copy source file to website repo
    fi

  else
    echo "Dir"
  fi
done

#Run local Hugo to get files in the right place
cd "$githubRepoLoc/$websiteRepo"
Rscript runLocalHugo.R &>/dev/null &
sleep 30
kill -SIGINT $!


#### Update Website Repository
cd "${githubRepoLoc}/${websiteRepo}"

if output=$(git status --porcelain) && [ ! -z "$output" ] #Are there differences in the website repo compared to the last pull from master?
                                                          #Have to use git status not git diff to catch new files in check
then
  echo "Updating Website Repo"
  git add --all
  git commit -am "Updated files from other repos: $(date +'%Y-%m-%d   %T')"
  git push origin master
else
  if output=$(git cherry -v) && [ ! -z "$output" ] #Are there unpushed commits
                                                   #Sometimes the script will commit but not push
  then
    echo "Pushing committed changes to website repo"
    git push origin master
  else
    echo "All files up to date in website repo"
  fi
fi

