#!/bin/bash

# Jenkins backup settings
SOURCE="/var/lib/jenkins"
DEST="/backup/jenkins"
DATE=$(date +%F)

# Create backup directory
mkdir -p "$DEST"

# Create compressed backup
tar -czf "$DEST/jenkins_backup_$DATE.tar.gz" -C /var/lib jenkins

# Delete backups older than 7 days
find "$DEST" -name "jenkins_backup_*.tar.gz" -mtime +7 -delete

echo "Jenkins backup completed successfully!"

