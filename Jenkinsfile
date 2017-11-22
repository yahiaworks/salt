#!/usr/bin/env groovy
string JENKINS_BRANCH_NAME = BRANCH_NAME
string JENKINS_BUILD_NUMBER = env.BUILD_NUMBER
string LABELS = 'teamwww'
SIMULATE = false

buildPassed = true

node () {
    checkout scm
}

node(LABELS) {
    checkout scm

    version="0.0.0.0"
    try {
        stage('Building...') {
            runShellStep("jenkins/docker_build.sh", "build_image", "")
        }
        stage('Pushing...') {
            withCredentials([usernamePassword(credentialsId: 'd262c113-387e-4a85-bedb-133ced13259b',
                                              passwordVariable: 'ARTIFACTORY_PASSWORD', usernameVariable: 'ARTIFACTORY_USER')]) {
                runShellStep("jenkins/docker_push.sh", "publish", "$version $ARTIFACTORY_USER $ARTIFACTORY_PASSWORD")
            }
        }
    }
    catch (Exception err) {
        failBuild(err)
    }
    finally {
        try {
            stage('Cleanup') {
            }
        }
        catch (Exception err) {
            failBuild(err)
        }
        finally {
            setBuildStatus()
            stage('Notify') {
                notifier.notifyOnBuildComplete(getBranchType())
                step([$class: 'StashNotifier'])
            }
        }
    }
}

def runShellStep(module, stepName, stepArgs, returnStdOut=false) {
    echo "$stepName $stepArgs"
    echo "/bin/bash -c \"source $module; $stepName $stepArgs\""
    def result = sh (
        script: "/bin/bash -c \"source $module; $stepName $stepArgs\"",
        returnStdout: returnStdOut
    )
    if (result) {
        result = result.trim()
        echo result
    }
    return result
}

def getBranchType() {
    if (BRANCH_NAME == "master") {
        return "MASTER"
    }
    return "FEATURE"
}

def failBuild(err) {
    buildPassed = false
    echo "Build failed with Exception: $err"
}

def setBuildStatus() {
    if (buildPassed) {
        currentBuild.result = "SUCCESS"
        echo "Build OK!"
    }
    else {
        currentBuild.result = "FAILURE"
        echo "Build Failed!"
    }
}
