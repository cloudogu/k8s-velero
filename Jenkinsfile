#!groovy
@Library('github.com/cloudogu/ces-build-lib@1.67.0')
import com.cloudogu.ces.cesbuildlib.*

git = new Git(this, "cesmarvin")
git.committerName = 'cesmarvin'
git.committerEmail = 'cesmarvin@cloudogu.com'
gitflow = new GitFlow(this, git)
github = new GitHub(this, git)
changelog = new Changelog(this)

repositoryName = "k8s-velero"
productionReleaseBranch = "main"

node('docker') {
    K3d k3d = new K3d(this, "${WORKSPACE}", "${WORKSPACE}/k3d", env.PATH)

    timestamps {
        catchError {
            timeout(activity: false, time: 60, unit: 'MINUTES') {
                stage('Checkout') {
                    checkout scm
                    make 'clean'
                }

                helmImage = "alpine/helm:3.13.0"
                stage("Lint k8s Resources") {
                    new Docker(this)
                            .image(helmImage)
                            .inside("-v ${WORKSPACE}/:/data -t --entrypoint=")
                                    {
                                        sh "helm lint /data/k8s/helm"
                                    }
                }

                stage('Set up k3d cluster') {
                    k3d.startK3d()
                }
                stage('Install kubectl') {
                    k3d.installKubectl()
                }

                stage('Test velero') {
                    sh "NAMESPACE=default KUBECONFIG=${WORKSPACE}/k3d/.k3d/.kube/config make helm-apply"
                    // Sleep because it takes time for the controller to create the resource. Without it would end up
                    // in error "no matching resource found when run the wait command"
                    sleep(20)
                    k3d.kubectl("wait --for=condition=ready pod -l app=k8s-velero --timeout=300s")
                }
            }
        }

        stage('Remove k3d cluster') {
            k3d.deleteK3d()
        }

        stageAutomaticRelease()
    }
}

void stageAutomaticRelease() {
    if (gitflow.isReleaseBranch()) {
        Makefile makefile = new Makefile(this)
        String releaseVersion = makefile.getVersion()
        String changelogVersion = git.getSimpleBranchName()
        String registryNamespace = "k8s"
        String registryUrl = "registry.cloudogu.com"

        stage('Finish Release') {
            gitflow.finishRelease(releaseVersion, productionReleaseBranch)
        }

        stage('Generate release resource') {
            make 'generate-release-resource'
        }

        stage('Push to Registry') {
            GString targetEtcdResourceYaml = "target/make/${registryNamespace}/${repositoryName}_${releaseVersion}.yaml"

            DoguRegistry registry = new DoguRegistry(this)
            registry.pushK8sYaml(targetEtcdResourceYaml, repositoryName, registryNamespace, "${releaseVersion}")
        }

        stage('Push Helm chart to Harbor') {
            new Docker(this)
                    .image("golang:1.20")
                    .mountJenkinsUser()
                    .inside("--volume ${WORKSPACE}:/${repositoryName} -w /${repositoryName}")
                            {
                                sh ".bin/helm dependency update k8s/helm"
                                make 'helm-package-release'

                                withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'harborhelmchartpush', usernameVariable: 'HARBOR_USERNAME', passwordVariable: 'HARBOR_PASSWORD']]) {
                                    sh ".bin/helm registry login ${registryUrl} --username '${HARBOR_USERNAME}' --password '${HARBOR_PASSWORD}'"
                                    sh ".bin/helm push target/make/k8s/helm/${repositoryName}-${releaseVersion}.tgz oci://${registryUrl}/${registryNamespace}"
                                }
                            }
        }

        stage('Add Github-Release') {
            releaseId = github.createReleaseWithChangelog(changelogVersion, changelog, productionReleaseBranch)
        }
    }
}

void make(String makeArgs) {
    sh "make ${makeArgs}"
}
