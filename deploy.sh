source ~/.featbranch/settings.conf

deploy(){
    projectRoot=$PWD

    updateRepositories $siteRepo $dataRepo
    cd $projectRoot
    getAllBranches $owner $siteRepo $dataRepo $githubToken
    buildSiteBranches $siteRepo $serverUrl
    buildDataBranches $dataRepo $serverUrl
}

updateRepositories(){
    cd ~/.featbranch/repositories
    cd $1
    git pull
    cd ..
    cd $2
    git pull
    cd ../..
}

getAllBranches(){
    owner=$1 siteRepo=$2 dataRepo=$3 githubToken=$4 docker-compose up outdatedbranches
}

buildSiteBranches(){
    for eachBranch in $(<~/.featbranch/output/site.out)
    do
        branchName=$(echo $eachBranch | cut -d"|" -f1)
        branchLatestCommit=$(echo $eachBranch | cut -d"|" -f2)

        if [ $(curl http://localhost:5001/branch-is-up-to-date/$1/$branchName/$branchLatestCommit) = 0 ];
        then
        
            branch=$branchName docker-compose up sitebuild > ~/.featbranch/server/logs/$1_$branchName.txt
            curl -X POST -d "repository=$1&branch=$branchName&latestCommit=$branchLatestCommit" http://localhost:5001/add-entry
            
            if [ $(<~/.featbranch/output/sitebuildSuccess.out) = "1" ];
            then

                branch=$branchName docker-compose up a11yreport

                urlEscaped=$(echo $serverUrl | sed "s/\//\\\\\//g")
                slackMessage="$(<./slack/templates/updatedsitebranch.tpl)"
                slackMessage=$(echo "$slackMessage" | sed "s/{repository}/$1/g")
                slackMessage=$(echo "$slackMessage" | sed "s/{serverUrl}/$urlEscaped/g")
                slackMessage=$(echo "$slackMessage" | sed "s/{branchName}/$branchName/g")
                message="$slackMessage" webHook="$slackWebhook" docker-compose up slack
            fi
        fi
    done
}

buildDataBranches(){
    for eachBranch in $(<~/.featbranch/output/data.out)
    do
        branchName=$(echo $eachBranch | cut -d"|" -f1)
        branchLatestCommit=$(echo $eachBranch | cut -d"|" -f2)

        if [ $(curl http://localhost:5001/branch-is-up-to-date/$1/$branchName/$branchLatestCommit) = 0 ];
        then
        
            branch=$branchName docker-compose up databuild > ~/.featbranch/server/logs/$1_$branchName.txt
            curl -X POST -d "repository=$1&branch=$branchName&latestCommit=$branchLatestCommit" http://localhost:5001/add-entry

            if [ $(<~/.featbranch/output/databuildSuccess.out) = "1" ];
            then
                dataBranch=$branchName serverUrl=$serverUrl docker-compose up datapreviewbuild > ~/.featbranch/server/logs/datapreview_$branchName.txt
                
                urlEscaped=$(echo $serverUrl | sed "s/\//\\\\\//g")
                slackMessage="$(<./slack/templates/updateddata.tpl)"
                slackMessage=$(echo "$slackMessage" | sed "s/{repository}/$1/g")
                slackMessage=$(echo "$slackMessage" | sed "s/{serverUrl}/$urlEscaped/g")
                slackMessage=$(echo "$slackMessage" | sed "s/{branchName}/$branchName/g")
                message="$slackMessage" webHook="$slackWebhook" docker-compose up slack
            fi
        fi
    done
}

deploy