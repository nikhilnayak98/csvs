# WM00I:Cyber Security for Virtualisation Systems
This repo contains workings of docker hardening (capabilities, selinux, seccomp, image stripping) for CSVS PMA due on 21st March.

## Phase 1
- [x] 1. Set network name
- [x] 2. Set ip
- [x] 3. Set hostname
- [x] 4. Set ip mapping with hostname
- [x] 5. Set port mapping with host machine
- [x] 6. Set cpu core
- [x] 7. Set limited memory
- [x] 8. Set memory swap
- [x] 9. Set the container to be read only
- [x] 10. set writable temporary file systems that are required
- [x] 11. Mount read only WEBSERVER_VOL volume
- [x] 12. Set read, write output directory for stracing
- [x] 13. Drop all capabilities and add only the required capabilities
- [x] 14. Set name of the container

## Phase 2
- [x] 1. Set SELinux policy
- [ ] 2. Set seccomp profile

## Phase 3
- [ ] 1. Strip the images to their bare minimum size
- [ ] 2. Add privilege escalation protection