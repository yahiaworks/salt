string emailAddress = "jarvis@cimpress.com"

def buildIsSuccessful() {
    return currentBuild.currentResult == "SUCCESS"
}

def buildResultChanged() {
    def previousResult = currentBuild.previousBuild?.result
    return previousResult != null && previousResult != currentBuild.currentResult
}

def getEmailAddresses(branchType) {
    if (branchType != "MASTER") {
        return ""
    }
    return emailAddress
}

def notifyOnBuildComplete(branchType) {
    // Email on failure and if the result has changed from the previous build
    if (!buildIsSuccessful() || (buildResultChanged() && buildIsSuccessful())) {
        sendEmail(branchType)
    }
}

def sendEmail(branchType) {
    def emails = getEmailAddresses(branchType)
    if (emails != null && emails != "")
    {
        echo "Emailing: $emails"
        mail (to: "$emails", subject: "Jenkins Job ${currentBuild.currentResult}: DevWorkstation CI '${env.JOB_NAME}' build ${env.BUILD_NUMBER}", mimeType: 'text/html',
             body: "<p style='Font-family: Calibri'><b>${currentBuild.currentResult}</b><br /><a href='${env.BUILD_URL}'>${env.JOB_NAME} build ${env.BUILD_NUMBER}</a></p>")
    }
}

return this