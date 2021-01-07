## API setup

library(plumber)
library(dplyr)
library(parsnip)
library(workflows)
library(recipes)
library(themis)
library(baguette)

## Load model + metrics
crash_wf_model <- readRDS("crash-wf-model.rds")
crash_metrics <- readr::read_csv("crash-model-metrics.csv") %>%
  dplyr::select(.metric, mean, std_err)


#* @apiTitle Chicago traffic crashes model API
#* @apiDescription Model predicting probability of an injury for traffic crashes in Chicago

#* Submit crash data and get a predicted probability of injury
#* @serializer json
#* @parser json
#* @post /predict
function(req, res) {
  preds <- req$body
  preds$crash_date <- as.POSIXct(preds$crash_date, tz = "America/Chicago")
  probs <- predict(crash_wf_model, preds, type = "prob")
  probs$.pred_injuries
}

#* Expected model metrics from training
#* @serializer json
#* @get /metrics
function() {
  crash_metrics
}

