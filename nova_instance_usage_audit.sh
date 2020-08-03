#!/bin/bash

# Purpose: This script will pull nova instance usage data for visualization
# Author: darren.carpenter
# Email: 

#move to correct directory and source ~/openrc
cd && source openrc
#pull the project id(s)/name(s)
openstack project list | grep -iv 'ID' | sed -r '/^\s*$/d' | awk '{print $2, $4}'
# this pulls data in the format of 'projectUUID projectNAME'

# From here, we need to pull all instances created by each project for the last 30 days
# to include those that are stopped, deleted, or other using the created_at date.
#echo -e '\n####################################################################################'
#echo -e '##############################Nova Usages Per Project###############################'
#echo -e '####################################################################################\n'
#echo ""
#echo -e ",Total Instances,Total vCPU,Total RAM (mb),Total Root (gb),Total Ephemeral (gb),project_id," > _nova_usage
#echo ""
#for PROJECT in `mysql keystone -BNe "select id from project where domain_id='default'"`; do mysql nova -t -e "select count(*) as 'Total Instances',sum(vcpus) as 'Total vCPU',sum(memory_mb) as 'Total RAM (mb)',sum(root_gb) as 'Total Root (gb)',sum(ephemeral_gb) as 'Total Ephemeral (gb)',project_id from instances where deleted=0 and project_id='$PROJECT'" | tail -n2| head -n1 | awk -F"|" '{print $2,$3,$4,$5,$6,$7}' | tr -s '[:blank:]' ',' >> _nova_usage | sed s/,// ; echo;  done

for PROJECT in `mysql keystone -BNe "select id from project where domain_id='default'"`; do mysql nova -t -e "select project_id,uuid,display_name,vcpus,root_gb,memory_mb,created_at,deleted_at from instances where created_at BETWEEN CURDATE() - INTERVAL 30 DAY AND CURDATE() and project_id='$PROJECT'"; done


#mysql nova -t -e "select uuid,display_name,vcpus,root_gb,memory_mb,date_format(created_at, '%m/%d/%Y'),date_format(deleted_at, '%m/%d/%Y') from instances where created_at BETWEEN CURDATE() - INTERVAL 30 DAY AND CURDATE() and deleted=0 and project_id='97dc08982cd049bcb4130a8cabcc88a6'"
# Once we have the list of instances per project, we need to organize the output in a readable
# fashion

# This line requests all instances created in the last 30 days
# mysql nova -BNe "select project_id,uuid,vcpus,memory_mb,root_gb,display_name,date_format(created_at, '%m/%d/%Y'), deleted_at from instances where created_at BETWEEN CURDATE() - INTERVAL 30 DAY AND CURDATE();" | sort -k1 | tr -s "[:blank:]" ","
