# AD CS lab setup

AD CS is intentionally separated from the base domain promotion because Enterprise CA installation is sensitive to the Windows Server box image. On DC01, install the role and create the CA before running the ESC1 exercise:

```powershell
Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -CACommonName 'LAB-CA' -KeyLength 2048 -HashAlgorithmName SHA256 -ValidityPeriod Years -ValidityPeriodUnits 5
```

Then create a duplicate of the User certificate template named `LabUserEnrollment`, grant `Authenticated Users` enrollment, enable `Enrollee Supplies Subject`, and publish it from the Certification Authority console. Confirm with:

```bash
certipy find -u 'joao.silva@lab.local' -p 'Lab@2024!' -target 192.168.56.10 -vulnerable
```

The exact template GUI labels differ slightly between Windows Server releases, so the final review is deliberately documented instead of silently assuming a box-specific schema.
