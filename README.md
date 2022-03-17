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
- [x] 9. Set the container to be read only
- [x] 10. Set writable temporary file systems that are required
- [x] 11. Mount read only volumes
- [x] 12. Set read, write output directory for stracing
- [x] 13. Drop all capabilities and add only the required capabilities
- [x] 14. Set name of the container

## Phase 2
- [x] 1. Set SELinux policy
- [x] 2. Set seccomp profile

## Phase 3
- [x] 1. Strip the images to their bare minimum size
- [x] 2. Add privilege escalation protection