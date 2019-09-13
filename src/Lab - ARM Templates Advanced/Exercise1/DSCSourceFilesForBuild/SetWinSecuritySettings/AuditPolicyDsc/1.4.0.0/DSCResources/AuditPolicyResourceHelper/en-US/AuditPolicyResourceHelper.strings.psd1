ConvertFrom-StringData -StringData @'
        AuditpolNotFound         = (ERROR) auditpol.exe was not found on the system
        RequiredPrivilegeMissing = (ERROR) A required privilege is not held by the client
        IncorrectParameter       = (ERROR) The parameter is incorrect
        UnknownError             = (ERROR) An unknown error has occured: {0}
        ExecuteAuditpolCommand   = Executing 'auditpol.exe {0}'
        FileNotFound   = {0} Not found
        WriteStagedCSV                   = Audit Subcategory '{1}' was written with flag: '{1}'
        RestoredAuditCSV                 = Audit CSV was successfully restored with auditpol
        AuditCSVNotFound                 = Could not find Audit CSV at '{0}'
        AuditCSVOutdated                 = Audit CSV at '{0}' is outdated ('{1}')
        AuditCSVLocked                   = Audit CSV at '{0}' is LOCKED
        AuditCSVDeleted                  = Audit CSV at '{0}' was DELETED
        AuditCSVCreated                  = Audit CSV at '{0}' was CREATED
        CurrentCSVValueMissing           = Cannot find current audit value for '{0}' will assume 'No Auditing'
        SubCategoryTranlationFailed      = Cannot find Subcategory translation for {0}
        SaveAuditCSVFailure              = Unable to save audit.csv at {0}
'@

