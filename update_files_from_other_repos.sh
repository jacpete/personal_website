#!/bin/bash

########################################
#### Global Variables ##################
########################################
githubRepoLoc="/home/jacpete/WebsiteManagement"
# githubRepoLoc="/home/jacpete/Storage/GitHub"
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
  if [ ! -d $1 ] 
  then
    setup_local_repo "$1"
  else
    cd $1
    git pull
    cd ${githubRepoLoc}
  fi
}


########################################
#### General Script ####################
########################################

#Update Website Repo
update_local_repo ${websiteRepo}


#### Absolute filepath of csvName
csvName="${githubRepoLoc}/${websiteRepo}/${csvName}"
# echo "${csvName}"

#### Read in data from CSV
userList=($(cat $csvName |  awk -F "," '{print $1}' | awk 'NR>1' | awk 'NF > 0')) #currently nothing is done with this and the script assumes its from my username (jacpete)
repoList=($(cat $csvName |  awk -F "," '{print $2}' | awk 'NR>1' | awk 'NF > 0'))
oriFileLocList=($(cat $csvName |  awk -F "," '{print $3}' | awk 'NR>1' | awk 'NF > 0'))
websiteFileLocList=($(cat $csvName |  awk -F "," '{print $4}' | awk 'NR>1' | awk 'NF > 0'))


#### Get List of Unique Repos
uniqRepo=($(printf '%s\n' "${repoList[@]}" | sort | uniq))
# allRepo+=(${websiteRepo})
# printf '%s\n' "${allRepo[@]}"  #Prints list of all unique repos


#### Update needed repos
for i in ${!uniqRepo[*]}
do
  update_local_repo ${uniqRepo[i]}
done



  # [Global Params]
  #   githubRepoLoc - Absoute path of repo folders
  #   websiteRepo - Website repo name
  # 
  # 1. Get a list of unique repos from csv
  #   1.1 For each repo do a git pull to update the files
  # 
  # 2. Start loop for each line in csv
  #   2.1 Do a file copy with overwrite from oriFileLoc to websiteFileLoc
  # 
  # 3. Update Website Repo
  #   3.1 Commit all changes with message "Automatic-Update-{date}"
  #   3.2 Push the commit (Netlify should update automatically from here)
