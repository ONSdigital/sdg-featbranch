source ~/.featbranch/settings.conf

deploy(){
    projectRoot=$PWD

    updateRepositories $siteRepo $dataRepo
    cd $projectRoot
    getAllBranches $owner $siteRepo $dataRepo $githubToken
    buildSiteBranches $siteRepo
    buildDataBranches $dataRepo
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
            if [ $(<~/.featbranch/output/sitebuildSuccess.out) = "1" ];
            then
                curl -X POST -d "repository=$1&branch=$branchName&latestCommit=$branchLatestCommit" http://localhost:5001/add-entry
                branch=$branchName docker-compose up a11yreport
                message="$branchName built successfully" webHook="$slackWebhook" docker-compose up slack
            else
                message="$branchName failed to build" webHook="$slackWebhook" docker-compose up slack
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

            if [ $(<~/.featbranch/output/databuildSuccess.out) = "1" ];
            then
                curl -X POST -d "repository=$1&branch=$branchName&latestCommit=$branchLatestCommit" http://localhost:5001/add-entry
                dataBranch=$branchName serverUrl=$serverUrl docker-compose up datapreviewbuild > ~/.featbranch/server/logs/datapreview_$branchName.txt
                message="$branchName built successfully" webHook="https://hooks.slack.com/services/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" docker-compose up slack
            fi
        fi
    done
}

deploy