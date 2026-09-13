# Techniques

| ID | Technique | Lab indicator |
|---|---|---|
| 01 | AS-REP Roasting | `joao.silva` has Kerberos preauthentication disabled |
| 02 | Kerberoasting | `svc_backup` owns a CIFS SPN |
| 03 | GPP/secret discovery | Training secret attached to `ana.costa` |
| 04 | ACL abuse | `TI` has `GenericAll` over `carlos.pereira` |
| 05 | AD CS ESC1 | Enrollment template allows the requester to supply the subject |

The lab intentionally uses known, detectable misconfigurations. Each one should be paired with a detection exercise before it is removed.
