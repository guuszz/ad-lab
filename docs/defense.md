# Defense

## AS-REP Roasting

Require Kerberos preauthentication for normal user accounts, monitor Event ID 4768 for unusual encryption types and account volume, and use long unique passwords.

## Kerberoasting

Keep service accounts non-interactive, use group managed service accounts where possible, rotate secrets, and alert on unusual TGS requests (Event ID 4769).

## GPP and exposed secrets

Remove plaintext secrets from directory attributes and SYSVOL, audit SYSVOL for legacy `Groups.xml`, rotate every exposed credential, and use Microsoft LAPS for local administrator passwords.

## ACL abuse

Review privileged group edges with BloodHound or native ACL reports, remove `GenericAll` from broad groups, and alert on directory permission changes (Event IDs 5136 and 4670).

## AD CS ESC1

Disable `ENROLLEE_SUPPLIES_SUBJECT` unless required, require manager approval and authorized signatures, restrict enrollment permissions, and audit certificate issuance (CA and Security logs).

## Lab hygiene

Keep the host-only adapter isolated, destroy the VMs after training, and never reuse `Lab@2024!` outside this repository.
