# Configure the GCP Provider
provider "google" {
  region      = "${var.region}"
  project     = "${var.project}"
}

resource "google_storage_bucket" "bucket" {
  name = "${var.bucket}"
  location = "EU"
}

data "archive_file" "app" {
  type        = "zip"
  source_dir  = "./functions/app/app"
  output_path = "./functions/app/app.zip"
}

resource "google_storage_bucket_object" "app" {
  name   = "app.${data.archive_file.app.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/app/app.zip"
}

data "archive_file" "saveToDB" {
  type        = "zip"
  source_dir  = "./functions/saveToDB/saveToDB"
  output_path = "./functions/saveToDB/saveToDB.zip"
}

resource "google_storage_bucket_object" "saveToDB" {
  name   = "saveToDB.${data.archive_file.saveToDB.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/saveToDB/saveToDB.zip"
}

data "archive_file" "currentTemp" {
  type        = "zip"
  source_dir  = "./functions/currentTemp/currentTemp"
  output_path = "./functions/currentTemp/currentTemp.zip"
}

resource "google_storage_bucket_object" "currentTemp" {
  name   = "currentTemp.${data.archive_file.currentTemp.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/currentTemp/currentTemp.zip"
}

data "archive_file" "zamb" {
  type        = "zip"
  source_dir  = "./functions/zamb/zamb"
  output_path = "./functions/zamb/zamb.zip"
}

resource "google_storage_bucket_object" "zamb" {
  name   = "zamb.${data.archive_file.zamb.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/zamb/zamb.zip"
}

data "archive_file" "toZamb" {
  type        = "zip"
  source_dir  = "./functions/toZamb/toZamb"
  output_path = "./functions/toZamb/toZamb.zip"
}

resource "google_storage_bucket_object" "toZamb" {
  name   = "toZamb.${data.archive_file.toZamb.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/toZamb/toZamb.zip"
}

data "archive_file" "getFromDB" {
  type        = "zip"
  source_dir  = "./functions/getFromDB/getFromDB"
  output_path = "./functions/getFromDB/getFromDB.zip"
}

resource "google_storage_bucket_object" "getFromDB" {
  name   = "getFromDB.${data.archive_file.getFromDB.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/getFromDB/getFromDB.zip"
}

data "archive_file" "apiToTF" {
  type        = "zip"
  source_dir  = "./functions/apiToTF/apiToTF"
  output_path = "./functions/apiToTF/apiToTF.zip"
}

resource "google_storage_bucket_object" "apiToTF" {
  name   = "apiToTF.${data.archive_file.apiToTF.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/apiToTF/apiToTF.zip"
}

data "archive_file" "getPredictions" {
  type        = "zip"
  source_dir  = "./functions/getPredictions/getPredictions"
  output_path = "./functions/getPredictions/getPredictions.zip"
}

resource "google_storage_bucket_object" "getPredictions" {
  name   = "getPredictions.${data.archive_file.getPredictions.output_base64sha256}.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./functions/getPredictions/getPredictions.zip"
}

resource "google_cloudfunctions_function" "get-data" {
  name                  = "get-data"
  description           = "My weather"
  available_memory_mb   = 256
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.app.name}"
  trigger_http          = true
  timeout               = 60
  runtime               = "python37"
  entry_point           = "get_data_from_api"
  labels = {
    my-label = "my-label-value"
  }
  environment_variables = {
    API = "${var.API}"
    project = "${var.project}"
  }

}

resource "google_pubsub_topic" "topic1" {
  name = "topic1"
}

resource "google_pubsub_topic" "topic2" {
  name = "topic2"
}

resource "google_pubsub_topic" "topic3" {
  name = "topic3"
}

# resource "google_cloudfunctions_function" "saveToDB" {
#   name                  = "saveToDB"
#   description           = "My weather"
#   available_memory_mb   = 256
#   source_archive_bucket = "${google_storage_bucket.bucket.name}"
#   source_archive_object = "${google_storage_bucket_object.saveToDB.name}"
#   timeout               = 60
#   runtime               = "python37"
#   entry_point           = "message_from_topic1"
#   event_trigger {
#     event_type          = "google.pubsub.topic.publish"
#     resource            = "${google_pubsub_topic.topic1.name}"
#     failure_policy {
#       retry = true
#     }
#   }
#     environment_variables = {
#     user_name = "${var.MONGODB_USERNAME}"
#     user_pass = "${var.MONGODB_PASSWORD}"
#     ip = "${var.ip_mongo}"
#   }

# }

# resource "google_cloudfunctions_function" "currentTemp" {
#   name                  = "currentTemp"
#   description           = "My weather"
#   available_memory_mb   = 256
#   source_archive_bucket = "${google_storage_bucket.bucket.name}"
#   source_archive_object = "${google_storage_bucket_object.currentTemp.name}"
#   timeout               = 60
#   runtime               = "python37"
#   entry_point           = "message_from_topic3"
#   event_trigger {
#     event_type          = "google.pubsub.topic.publish"
#     resource            = "${google_pubsub_topic.topic3.name}"
#     failure_policy {
#       retry = true
#     }
#   }
#     environment_variables = {
#     project = "${var.project}"
#     ip_redis = "${var.ip_redis}"
#     r_pass = "${var.REDIS_PASSWORD}"
#   }
# }

# resource "google_cloudfunctions_function" "zamb" {
#   name                  = "zamb"
#   description           = "My weather"
#   available_memory_mb   = 256
#   source_archive_bucket = "${google_storage_bucket.bucket.name}"
#   source_archive_object = "${google_storage_bucket_object.zamb.name}"
#   trigger_http          = true
#   timeout               = 60
#   runtime               = "python37"
#   entry_point           = "zamb"


#     environment_variables = {
#     user_name = "${var.MONGODB_USERNAME}"
#     user_pass = "${var.MONGODB_PASSWORD}"
#     ip = "${var.ip_mongo}"
#     ip_redis = "${var.ip_redis}"
#     r_pass = "${var.REDIS_PASSWORD}"
#   }

# }

resource "google_cloudfunctions_function" "toZamb" {
  name                  = "toZamb"
  description           = "My weather"
  available_memory_mb   = 256
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.toZamb.name}"
  timeout               = 60
  runtime               = "python37"
  entry_point           = "message_from_topic2"

  event_trigger {
    event_type          = "google.pubsub.topic.publish"
    resource            = "${google_pubsub_topic.topic2.name}"
    failure_policy {
      retry = true
    }
  }
    environment_variables = {
    project = "${var.project}"
    link_zamb = "https://${var.region}-${var.project}.cloudfunctions.net/zamb"
    # link_zamb = "${google_cloudfunctions_function.zamb.https_trigger_url}"
  }

}


resource "google_cloud_scheduler_job" "api-job" {
  name     = "api-job"
  description = "test http job"
  schedule = "*/15 * * * *"
  time_zone = "Europe/Brussels"

  http_target {
    http_method = "POST"
    uri = "${google_cloudfunctions_function.get-data.https_trigger_url}"
  }
}


# resource "google_cloudfunctions_function" "getFromDB" {

#   name = "getFromDB"
#   description = "Fetching from MongoDB"
#   available_memory_mb = 128
#   trigger_http = true
#   timeout = 60
#   entry_point = "get_from_db"
#   runtime = "python37"
#   source_archive_bucket = "${google_storage_bucket.bucket.name}"
#   source_archive_object = "${google_storage_bucket_object.getFromDB.name}"
#   environment_variables = {
#     user_name = "${var.MONGODB_USERNAME}"
#     user_pass = "${var.MONGODB_PASSWORD}"
#     ip = "${var.ip_mongo}"
#   }
# }

resource "google_cloudfunctions_function" "apiToTF" {
  name = "apiToTF"
  description = "api_to_TF"
  available_memory_mb = 128
  trigger_http = true
  timeout = 60
  entry_point = "data_to_predict"
  runtime = "python37"
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.apiToTF.name}"

}


resource "google_cloudfunctions_function" "getPredictions" {
  name = "getPredictions"
  description = "Fetching from MongoDB"
  available_memory_mb = 128
  trigger_http = true
  timeout = 60
  entry_point = "get_predictions"
  runtime = "python37"
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.getPredictions.name}"
  environment_variables = {

    ip_tf = "${var.ip_tf}"
    link_api_to_tf = "${google_cloudfunctions_function.apiToTF.https_trigger_url}"
  }
}

