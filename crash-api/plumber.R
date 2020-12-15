## API setup

library(plumber)
library(dplyr)
library(parsnip)
library(workflows)
library(recipes)
library(textrecipes)
library(themis)

## Load model + metrics
crash_wf_model <- readRDS("crash-wf-model.rds")
crash_metrics <- readr::read_csv("crash-model-metrics.csv") %>%
  dplyr::select(.metric, mean, std_err)


#* @apiTitle Chicago traffic crashes model API
#* @apiDescription Model predicting probability of an injury for traffic crashes in Chicago

#* Submit crash data and get a predicted probability of injury
#* @param preds Predictors for Chicago traffic dataset
#* @json
#* @post /predict
function(preds) {
  preds <- jsonlite::fromJSON(preds)
  preds$crash_date <- as.POSIXct(preds$crash_date)
  predict(crash_wf_model, preds)
}

#* Expected model metrics from training
#* @json
#* @get /metrics
function() {
  crash_metrics
}

