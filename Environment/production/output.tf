# out the vpc ID here that we will always be called by other modules
output "vpc_id" {
  value = module.efe-vpc.vpc_id
}
