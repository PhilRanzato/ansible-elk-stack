# Elastic01
gcloud compute instances delete elastic01 --zone=europe-north1-a --quiet
gcloud compute addresses delete elastic01-internal --region=europe-north1 --quiet
gcloud compute addresses delete elastic01-external --region=europe-north1 --quiet

# Elastic02
gcloud compute instances delete elastic02 --zone=europe-north1-b --quiet
gcloud compute addresses delete elastic02-internal --region=europe-north1 --quiet
gcloud compute addresses delete elastic02-external --region=europe-north1 --quiet

# Elastic03
gcloud compute instances delete elastic03 --zone=europe-north1-c --quiet
gcloud compute addresses delete elastic03-internal --region=europe-north1 --quiet
gcloud compute addresses delete elastic03-external --region=europe-north1 --quiet
