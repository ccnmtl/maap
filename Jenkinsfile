node {
		stage "checkout"
		checkout scm
		
		stage "run wget"
		withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'silver',
											usernameVariable: 'HTTP_USER', passwordVariable: 'HTTP_PASSWORD']]) {
    		sh "maintenance/wget_maap-admin.sh"
    }
		stage "rsync"
		sh "rsync  -rltD -z  --verbose snapshots/current/ tlcreg@cunix.cc.columbia.edu:/www/data/ccnmtl/projects/maap"

		stage "cleanup"
		sh "rm -rf snapshots/*"
}
