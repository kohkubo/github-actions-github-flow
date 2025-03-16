output "enabled_apis" {
  description = "有効化されたGCP APIのリスト"
  value       = [for api in google_project_service.apis : api.service]
}
