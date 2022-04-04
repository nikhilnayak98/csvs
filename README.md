# WM00I:Cyber Security for Virtualisation Systems
This repo contains workings of docker hardening (capabilities, selinux, seccomp, image stripping) for CSVS PMA due on 21st March.

## Phase 1
- [x] 1. Create different network for containers
- [x] 2. Set IP Addresses
- [x] 3. Set hostnames
- [x] 4. Set IP mapping with hostnames
- [x] 5. Set port mapping with host machines
- [x] 6. Set cpu cores
- [x] 7. Set limited memory
- [x] 8. Set memory swap
- [x] 9. Limit pids
- [x] 10. Set auto restarts
- [x] 11. Set the container to be read only
- [x] 12. Set writable temporary file systems that are required
- [x] 13. Mount read only volumes
- [x] 14. Set read, write output directory for stracing
- [x] 15. Drop all capabilities and add only the required capabilities
- [x] 16. Set name of the container

## Phase 2
- [x] 1. Set SELinux policies
- [x] 2. Set seccomp profile

## Phase 3
- [x] 1. Strip the images to their bare minimum size
- [x] 2. Add privilege escalation protection
- [x] 3. No root inside dbserver container
- [x] 4. Image stripping using dockerslim
- [x] 5. Pushed images to registry
  - [x] <code>gcr.io/u2185920/csvs2022-db_i</code>
  - [x] <code>gcr.io/u2185920/csvs2022-web_i</code>
  - [x] <code>gcr.io/u2185920/csvs2022-db_i:stripped</code>
  - [x] <code>gcr.io/u2185920/csvs2022-web_i:stripped</code>
