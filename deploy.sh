#!/bin/bash

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S')[LOG] - $1"
}

export KUBE_SUBST_ENVS="$KUBE_SUBST_ENVS \$INGRESS_DOMAIN \$IMAGE_REPOSITORY \$IMAGE_TAG \$ID"

if [ -z "$1" ]; then
    log "ERROR: This command needs arguments
         Example: deploy <command>
           command:
                   up   => used to install or update the app
                   down => used to uninstall or delete the app"
    exit 1;
fi

log "Generating Kubeconfig"
export KUBE_CACHE_PATH="${PWD}"
echo "${KUBE_CONFIG}" > "${KUBE_CACHE_PATH}/kubeconfig"
export KUBECONFIG="${KUBE_CACHE_PATH}/kubeconfig"

log "Validate Kubeconfig"
if ! kubectl get ns kube-system; then exit 2; fi

# SETUP HELM REPOSITORY
if ! [[ -z "${HELM_USERNAME:-}" || -z "${HELM_PASSWORD:-}" || -z "${HELM_URL:-}" ]]; then
    log "Adding helm repository"
    export HELM_NAME=repository

    helm repo add $HELM_NAME --username $HELM_USERNAME --password $HELM_PASSWORD $HELM_URL
    if (( $? != 0 )); then echo -e "$ERROR: Cannot add helm repo"; exit 1; fi

    export KUBE_CHART_PATH="${HELM_NAME}/${KUBE_CHART_PATH}"
fi
# END SETUP


#_______________________________INSTALL/UPDATE_APP_________________________________________#
if [ "$1" = "up" ]; then

    log "Generate Values Yaml"
    echo "${KUBE_HELM_VALUES}" | envsubst "$KUBE_SUBST_ENVS" > "${KUBE_CACHE_PATH}/values.yaml"

    log "Ensure Namespace"
    if ! kubectl get ns ${KUBE_NAMESPACE} > /dev/null 2>&1; then
        kubectl create ns ${KUBE_NAMESPACE}
    fi
    
    # Configuring Namespace
    log "Configuring Namespace"
    echo "${KUBE_NAMESPACE_CONF}" > "${KUBE_CACHE_PATH}/namespace_conf.yaml"
    if ! kubectl apply -n "${KUBE_NAMESPACE}" -f "${KUBE_CACHE_PATH}/namespace_conf.yaml"; then exit 4; fi

    log "Check Deployment"
    if helm get notes "${KUBE_DEPLOYMENT}" -n "${KUBE_NAMESPACE}"; then 
        log "Update Deployment"
        if ! helm upgrade "${KUBE_DEPLOYMENT}" --values "${KUBE_CACHE_PATH}/values.yaml" -n "${KUBE_NAMESPACE}" "${KUBE_CHART_PATH}"; then exit 6; fi
    else
        log "Install Deployment"
        if ! helm install "${KUBE_DEPLOYMENT}" --values "${KUBE_CACHE_PATH}/values.yaml" -n "${KUBE_NAMESPACE}" "${KUBE_CHART_PATH}"; then exit 6; fi
    fi

#_______________________________UNINSTALL/DELETE_APP_________________________________________#
elif [ "$1" = "down" ]; then

    log "Check Deployment"
    if helm get notes "${KUBE_DEPLOYMENT}" -n "${KUBE_NAMESPACE}"; then 
        log "Uninstall Deployment"
        if ! helm uninstall "${KUBE_DEPLOYMENT}" -n "${KUBE_NAMESPACE}"; then exit 7; fi
    else 
        exit 8
    fi
fi
