#!groovy
@Library('github.com/cloudogu/ces-build-lib@1.68.0')
import com.cloudogu.ces.cesbuildlib.*

git = new Git(this, "cesmarvin")
git.committerName = 'cesmarvin'
git.committerEmail = 'cesmarvin@cloudogu.com'
gitflow = new GitFlow(this, git)
github = new GitHub(this, git)
changelog = new Changelog(this)

repositoryName = "k8s-velero"
productionReleaseBranch = "main"

goVersion = "1.21"
helmTargetDir = "target/k8s"
helmChartDir = "${helmTargetDir}/helm"
String registryNamespace = "k8s"
String registryUrl = "registry.cloudogu.com"

node('docker') {
    timestamps {
        catchError {
            timeout(activity: false, time: 60, unit: 'MINUTES') {
                stage('Checkout') {
                    checkout scm
                    make 'clean'
                }

                new Docker(this)
                        .image("golang:${goVersion}")
                        .mountJenkinsUser()
                        .inside("--volume ${WORKSPACE}:/${repositoryName} -w /${repositoryName}")
                                {
                                    stage('Generate k8s Resources') {
                                        make 'helm-update-dependencies'
                                        make 'helm-generate'
                                        archiveArtifacts 'target/k8s/**/*'
                                    }

                                    stage("Lint helm") {
                                        make 'helm-lint'
                                    }
                                }

                K3d k3d = new K3d(this, "${WORKSPACE}", "${WORKSPACE}/k3d", env.PATH)

                try {
                    stage('Set up k3d cluster') {
                        k3d.startK3d()
                    }

                    stage('Deploy snapshot controller CRDs') {
                        new Docker(this)
                                .image("golang:${goVersion}")
                                .mountJenkinsUser()
                                .inside("--volume ${WORKSPACE}:/${repositoryName} -w /${repositoryName}")
                                        {
                                            withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'harborhelmchartpush', usernameVariable: 'HARBOR_USERNAME', passwordVariable: 'HARBOR_PASSWORD']]) {
                                                k3d.helm("registry login ${registryUrl} --username '${HARBOR_USERNAME}' --password '${HARBOR_PASSWORD}'")
                                                k3d.helm("install k8s-snapshot-controller-crd oci://${registryUrl}/${registryNamespace}/k8s-snapshot-controller-crd --version 5.0.1-4")
                                            }
                                        }
                    }

                    stage('Deploy k8s-velero') {
                        k3d.helm("install ${repositoryName} ${helmChartDir}")
                    }

                    stage('Test k8s-velero') {
                        // Sleep because it takes time for the controller to create the resource. Without it would end up
                        // in error "no matching resource found when run the wait command"
                        sleep(20)
                        k3d.kubectl("wait --for=condition=ready pod -l app.kubernetes.io/name=k8s-velero --timeout=300s")
                    }
                } finally {
                    stage('Remove k3d cluster') {
                        k3d.deleteK3d()
                    }
                }
            }
        }
    }

    stageAutomaticRelease()
}

void stageAutomaticRelease() {
    if (gitflow.isReleaseBranch()) {
        Makefile makefile = new Makefile(this)
        String releaseVersion = makefile.getVersion()
        String changelogVersion = git.getSimpleBranchName()

        stage('Push Helm chart to Harbor') {
            new Docker(this)
                    .image("golang:${goVersion}")
                    .mountJenkinsUser()
                    .inside("--volume ${WORKSPACE}:/${repositoryName} -w /${repositoryName}")
                            {
                                make 'helm-package'

                                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'harborhelmchartpush', usernameVariable: 'HARBOR_USERNAME', passwordVariable: 'HARBOR_PASSWORD']]) {
                                    sh ".bin/helm registry login ${registryUrl} --username '${HARBOR_USERNAME}' --password '${HARBOR_PASSWORD}'"
                                    sh ".bin/helm push ${helmChartDir}/${repositoryName}-${releaseVersion}.tgz oci://${registryUrl}/${registryNamespace}"
                                }
                            }
        }

        stage('Add Github-Release') {
            releaseId = github.createReleaseWithChangelog(changelogVersion, changelog, productionReleaseBranch)
        }

        stage('Finish Release') {
            gitflow.finishRelease(releaseVersion, productionReleaseBranch)
        }
    }
}

void make(String makeArgs) {
    sh "make ${makeArgs}"
}
