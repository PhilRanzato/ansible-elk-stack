# Elastic01
gcloud compute instances delete ansible-master --zone=europe-north1-a --quiet
gcloud compute addresses delete ansible-master-internal --region=europe-north1 --quiet
gcloud compute addresses delete ansible-master-external --region=europe-north1 --quiet

