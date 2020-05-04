locals{
    environments = { for e in var.environments : e => e }
}

locals{
    db_names = { for db in var.db_names : db => db }
}