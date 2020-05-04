locals{
    db_names = { for db in var.db_names : db => db }
}