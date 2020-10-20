### Elastic 1

#### Create internal IP

gcloud compute addresses create elastic01-internal --region europe-north1 --subnet zone-1 --addresses 10.100.0.10

#### Create External IP

gcloud compute addresses create elastic01-external --project=learning-288910 --network-tier=PREMIUM --region=europe-north1
export EXT_ADDRESS_ES01=$(gcloud compute addresses describe elastic01-external --region europe-north1 --format json | jq '[.address][0]' --raw-output)

#### Create Host VM

gcloud beta compute --project=learning-288910 instances create elastic01 \
    --zone=europe-north1-a \
    --machine-type=e2-medium \
    --subnet=zone-1 \
    --private-network-ip=10.100.0.10 \
    --address=$EXT_ADDRESS_ES01 \
    --maintenance-policy=MIGRATE \
    --service-account=237354390854-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image=centos-7-v20200910 \
    --image-project=centos-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=elastic01 \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=type=elastic,data=false \
    --reservation-affinity=any

## Elastic 2

#### Create internal IP

gcloud compute addresses create elastic02-internal --region europe-north1 --subnet zone-2 --addresses 10.101.0.10

#### Create External IP

gcloud compute addresses create elastic02-external --project=learning-288910 --network-tier=PREMIUM --region=europe-north1
export EXT_ADDRESS_ES02=$(gcloud compute addresses describe elastic02-external --region europe-north1 --format json | jq '[.address][0]' --raw-output)

#### Create Host

gcloud beta compute --project=learning-288910 instances create elastic02 \
    --zone=europe-north1-b \
    --machine-type=e2-medium \
    --subnet=zone-2 \
    --private-network-ip=10.101.0.10 \
    --address=$EXT_ADDRESS_ES02 \
    --maintenance-policy=MIGRATE \
    --service-account=237354390854-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image=centos-7-v20200910 \
    --image-project=centos-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=elastic02 \
    --create-disk=mode=rw,size=50,type=projects/learning-288910/zones/europe-north1-b/diskTypes/pd-ssd,name=elastic02-ssd,device-name=elastic02-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=type=elastic,data=true \
    --reservation-affinity=any

## Elastic 3

#### Create internal IP

gcloud compute addresses create elastic03-internal --region europe-north1 --subnet zone-3 --addresses 10.102.0.10

#### Create External IP

gcloud compute addresses create elastic03-external --project=learning-288910 --network-tier=PREMIUM --region=europe-north1
export EXT_ADDRESS_ES03=$(gcloud compute addresses describe elastic03-external --region europe-north1 --format json | jq '[.address][0]' --raw-output)

#### Create Host

gcloud beta compute --project=learning-288910 instances create elastic03 \
    --zone=europe-north1-c \
    --machine-type=e2-medium \
    --subnet=zone-3 \
    --private-network-ip=10.102.0.10 \
    --address=$EXT_ADDRESS_ES03 \
    --maintenance-policy=MIGRATE \
    --service-account=237354390854-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
    --image=centos-7-v20200910 \
    --image-project=centos-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-standard \
    --boot-disk-device-name=elastic03 \
    --create-disk=mode=rw,size=50,type=projects/learning-288910/zones/europe-north1-b/diskTypes/pd-ssd,name=elastic03-ssd,device-name=elastic03-ssd \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=type=elastic,data=true \
    --reservation-affinity=any
