## What this script does

✅ Checks if the user is root
✅ Logs everything to /var/log/patching_*.log
✅ Checks disk space
✅ Checks failed services
✅ Saves the current kernel version
✅ Runs apt update
✅ Lists available updates
✅ Applies security updates using unattended-upgrade
✅ Checks if a reboot is required
✅ Creates a complete audit log

### Production process around the script

**Before running it:**

- Get change approval.
- Remove the server from the Load Balancer (if applicable).
- Create an EBS/VM snapshot.
- Run the script.
- Reboot only if /var/run/reboot-required exists.

**Verify services:**

```bash
systemctl status nginx
systemctl status docker
```

**Verify the application:**

curl localhost
Add the server back to the Load Balancer.
Monitor the server.
Interview answer

"For Ubuntu production patching, I use apt update to refresh repositories, unattended-upgrade to apply security patches only, check if a reboot is required using /var/run/reboot-required, validate services and applications after patching, and maintain logs for auditing and troubleshooting.
