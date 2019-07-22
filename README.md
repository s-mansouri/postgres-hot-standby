Deploy a production ready PostgreSQL Hot Standby with Ansible
=========

Role Variables
--------------

Variable | Comment
-------- | -------
**pg_type** | type of database. master or slave
**pg_admin_user** |  POSTGRES_PASSWORD: set superuser password
**pg_admin_password** | POSTGRES_PASSWORD: set database admin password
**pg_db** | POSTGRES_DB: define diffrent name for default database
**pg_replication_user** | user to perform replication
**pg_replication_pass** | password for replication user


Example Playbook
----------------

Run with this command:
```bash
ansible-playbook -i inventory/hosts.ini pg-hotstandby.yml --extra-vars "target=pg_hotstandby"
```
