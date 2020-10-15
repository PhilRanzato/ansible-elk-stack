### Ansible Master

#### Create internal IP

gcloud compute addresses create ansible-master-internal --region europe-north1 --subnet zone-1 --addresses 10.100.0.5

#### Create External IP

gcloud compute addresses create ansible-master-external --project=learning-288910 --network-tier=PREMIUM --region=europe-north1
export EXT_ADDRESS_ANS=$(gcloud compute addresses describe ansible-master-external --region europe-north1 --format json | jq '[.address][0]' --raw-output)

#### Create Host VM

gcloud beta compute --project=learning-288910 instances create ansible-master \
    --zone=europe-north1-a \
    --machine-type=e2-small \
    --subnet=zone-1 \
    --private-network-ip=10.100.0.5 \
    --address=$EXT_ADDRESS_ANS \
    --maintenance-policy=MIGRATE \
    --service-account=237354390854-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image=centos-7-v20200910 \
    --image-project=centos-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=ansible-master \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=type=elastic,data=false \
    --reservation-affinity=any
