variable "storage_account_name" {
  type        = string
  description = "Name of resource"
}
variable "azure_app_service_plan_name" {
  type        = string
  description = "Name of resource"
}
variable "function_app_name" {
  type        = string
  description = "Name of resource"
}
variable "storage_container_name" {
  type        = string
  description = "Name of resource"
}
variable "rg_name" {
  type        = string
  description = "Name of the existing resource group"
}
variable "location" {
  type        = string
  description = "Azure location"
}
variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the Azure resources"
}
variable "event_hub_name" {
  type        = string
  description = "Event hub name to replace in function.json"
}
variable "event_hub_namespace_default_primary_connection_string" {
  type        = string
  description = "The primary connection string for the authorization rule RootManageSharedAccessKey in Event hub namespace"
}variable "nr_insert_key" {
  type        = string
  description = "New Relic Insights insert key https://docs.newrelic.com/docs/insights/insights-api/get-data/query-insights-event-data-api#register"
}
variable "nr_tags" {
  type        = string
  description = "Attributes to be added to all logs forwarded to New Relic. Semicolon delimited (e.g. env:prod;team:myTeam)"
}
