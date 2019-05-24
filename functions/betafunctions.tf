resource "null_resource" "VPCconnector" {
  provisioner "local-exec" {
    command = "gcloud beta compute networks vpc-access connectors create vpcconnect --network $VPCNETWORK --region $REGION --range 192.168.0.0/28"
    
    environment = {
      REGION =    "${var.region}"
      VPCNETWORK = "${var.int_net}"
    }
  }
}


# # # Its a pity but we don't know how to check function availability via terraform in GCP, manually too.
resource "null_resource" "saveToDB" {
  depends_on = ["null_resource.VPCconnector"]#saveToDB need VPC connector(null resource - unmanageable by terraform), thats why depend on here
  triggers = {
    check_func_availability = "${sha1(file("./functions/saveToDB/saveToDB/main.py"))}"
  }
  provisioner "local-exec" {
    command = "gcloud beta functions deploy saveToDB --region=$REGION --vpc-connector projects/$PROJECT/locations/$REGION/connectors/vpcconnect --project=$PROJECT --entry-point=message_from_topic1 --memory=256 --retry --runtime python37 --source=gs://$SOURCE_ARCHIVE_BUCKET/$SOURCE_ARCHIVE_OBJECT  --stage-bucket=$SOURCE_ARCHIVE_BUCKET --timeout=60 --set-env-vars=ip=$IP,user_name=$USER_NAME,user_pass=$USER_PASS --trigger-topic=$RESOURCE "
    
    environment = {
      REGION =    "${var.region}"
      PROJECT =   "${var.project}"
      USER_NAME = "${var.MONGODB_USERNAME}"
      USER_PASS = "${var.MONGODB_PASSWORD}"
      IP        = "${var.ip_mongo}"      
      SOURCE_ARCHIVE_BUCKET = "${google_storage_bucket.bucket.name}"
      SOURCE_ARCHIVE_OBJECT = "${google_storage_bucket_object.saveToDB.name}"
      RESOURCE            = "${google_pubsub_topic.topic1.name}"
    }
  }
}
resource "null_resource" "getFromDB" {
  depends_on = ["null_resource.VPCconnector"]
  triggers = {
    check_func_availability = "${sha1(file("./functions/getFromDB/getFromDB/main.py"))}"
    # https://www.terraform.io/docs/configuration-0-11/interpolation.html
  }

  provisioner "local-exec" {
    command = "gcloud beta functions deploy getFromDB --region=$REGION --vpc-connector projects/$PROJECT/locations/$REGION/connectors/vpcconnect --project=$PROJECT --entry-point=get_from_db --memory=128 --runtime python37 --source=gs://$SOURCE_ARCHIVE_BUCKET/$SOURCE_ARCHIVE_OBJECT  --stage-bucket=$SOURCE_ARCHIVE_BUCKET --timeout=60 --set-env-vars=ip=$IP,user_name=$USER_NAME,user_pass=$USER_PASS --trigger-http "

    environment = {
      REGION =    "${var.region}"
      PROJECT =   "${var.project}"
      USER_NAME = "${var.MONGODB_USERNAME}"
      USER_PASS = "${var.MONGODB_PASSWORD}"
      IP =        "${var.ip_mongo}"
    
      SOURCE_ARCHIVE_BUCKET = "${google_storage_bucket.bucket.name}"
      SOURCE_ARCHIVE_OBJECT = "${google_storage_bucket_object.getFromDB.name}"
    }
  }
}

resource "null_resource" "zamb" {
  depends_on = ["null_resource.VPCconnector"]
  triggers = {
    check_func_availability = "${sha1(file("./functions/zamb/zamb/main.py"))}"
    # https://www.terraform.io/docs/configuration-0-11/interpolation.html
  }
  provisioner "local-exec" {
    command = "gcloud beta functions deploy zamb --region=$REGION --vpc-connector projects/$PROJECT/locations/$REGION/connectors/vpcconnect --project=$PROJECT --entry-point=zamb --memory=256 --runtime python37 --source=gs://$SOURCE_ARCHIVE_BUCKET/$SOURCE_ARCHIVE_OBJECT  --stage-bucket=$SOURCE_ARCHIVE_BUCKET --timeout=60 --set-env-vars=ip=$IP,ip_redis=$IPREDIS,r_pass=$RPASS,user_name=$USER_NAME,user_pass=$USER_PASS --trigger-http "

    environment = {
      REGION =    "${var.region}"
      PROJECT =   "${var.project}"
      USER_NAME = "${var.MONGODB_USERNAME}"
      USER_PASS = "${var.MONGODB_PASSWORD}"
      IP =        "${var.ip_mongo}"
      IPREDIS = "${var.ip_redis}"
      RPASS = "${var.REDIS_PASSWORD}"
      SOURCE_ARCHIVE_BUCKET = "${google_storage_bucket.bucket.name}"
      SOURCE_ARCHIVE_OBJECT = "${google_storage_bucket_object.zamb.name}"
    }
  }
}
resource "null_resource" "currentTemp" {
  depends_on = ["null_resource.VPCconnector"]#currentTemp need VPC connector(null resource - unmanageable by terraform), thats why depend on here
  triggers = {
    check_func_availability = "${sha1(file("./functions/currentTemp/currentTemp/main.py"))}"
  }
  provisioner "local-exec" {
    command = "gcloud beta functions deploy currentTemp --region=$REGION --vpc-connector projects/$PROJECT/locations/$REGION/connectors/vpcconnect --project=$PROJECT --entry-point=message_from_topic3 --memory=256 --retry --runtime python37 --source=gs://$SOURCE_ARCHIVE_BUCKET/$SOURCE_ARCHIVE_OBJECT  --stage-bucket=$SOURCE_ARCHIVE_BUCKET --timeout=60 --set-env-vars=ip_redis=$IPREDIS,r_pass=$RPASS,project=$PROJECT --trigger-topic=$RESOURCE "
    
    environment = {
      REGION =    "${var.region}"
      PROJECT =   "${var.project}"
      IPREDIS        = "${var.ip_redis}"   
      RPASS = "${var.REDIS_PASSWORD}"   
      SOURCE_ARCHIVE_BUCKET = "${google_storage_bucket.bucket.name}"
      SOURCE_ARCHIVE_OBJECT = "${google_storage_bucket_object.currentTemp.name}"
      RESOURCE            = "${google_pubsub_topic.topic3.name}"
    }
  }
}