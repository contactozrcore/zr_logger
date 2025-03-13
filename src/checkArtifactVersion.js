function checkArtifactVersion() {
    const versionConvar = GetConvar('version', 'Unknown'); // "server":"FXServer-master SERVER v1.0.0.13068 win32"
    const [artifactVersion, osSystem] = versionConvar.match('/(\d+) (\w+)/').slice(1)
    fetch(`https://artifacts.jgscripts.com/check?artifact=${artifactVersion}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Response OK?')
            }
            return response.json
        })
        .then(data => {
            if (data && data.status === 'BROKEN') {
                console.warn(`
                    ^3[WARNING]^0 The FXServer version you are currently using has known issues. ${osSystem} ${artifactVersion}
                    `)
            } else {
                console.log(`^4[INFO]^0 The FXServer version you are currently using is correct.`)
            }
        })
        .catch(error => {
            console.error(`^3[WARNING]^0 Could not check artifacs version ;/ .`)
        })
}

exports("checkArtifactVersion", () => {
    checkArtifactVersion()
});