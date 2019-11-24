# k3d (K3s in Docker) Example with NodePort
# adapted from https://github.com/rancher/k3d/blob/master/docs/examples.md#2-via-nodeport

# KCONF := KUBECONFIG="$$(k3d get-kubeconfig --name=k3s-default)"'

all: clean create info nginx service test

create:
	k3d create --publish 8082:30080@k3d-k3s-default-worker-0 --workers 2
# rio install --host-ports

info:
	KUBECONFIG="$$(k3d get-kubeconfig --name='k3s-default')" \
	kubectl cluster-info

delete:
	k3d delete

nginx:
	KUBECONFIG="$$(k3d get-kubeconfig --name='k3s-default')" \
	kubectl create deployment nginx --image=nginx

# NOTE: maps to "30080", which in the "k3d create" is published to host
service:
	KUBECONFIG="$$(k3d get-kubeconfig --name='k3s-default')" \
	kubectl apply -f ./nginx-service.yaml

# TODO: wait until Nginx is ready
test:
	curl localhost:8082/

demo: info nginx test