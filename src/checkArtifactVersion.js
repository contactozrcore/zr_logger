function checkArtifactVersion() {
    // Retrieve the artifact version and operating system from the 'version' variable.
    const [artifactVersion, osSystem] = GetConvar('version', '69420 Gentoo').match(/(\d+) (\w+)/).slice(1) // Extracts the numeric version and OS.
    // Sends a request to the API to check the artifact version status.
    fetch(`https://artifacts.jgscripts.com/check?artifact=${artifactVersion}`)
    .then(r => r.json()) // Converts the response to JSON.
    .then(data =>
        // If the version is marked as 'BROKEN' log a warning to the console.
        data.status === 'BROKEN'
        ? console.warn(`^3[WARNING]^0 The FXServer version you are currently using has known issues. Version: '${artifactVersion}', '${osSystem}'.`)
        : console.log('^4[INFO]^0 The FXServer version you are currently using is correct.')
    )
    .catch(_ => console.error('^3[WARNING]^0 Could not check artifacs version.'))
}

// Calls the function to check the version when the script loads.
checkArtifactVersion()

// Exports the function to be used in other scripts.
exports('checkArtifactVersion', checkArtifactVersion)