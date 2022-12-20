global class PackageUtility implements InstallHandler {

	//final static String ERROR_LOG_EMAIL_SUBJECT = 'Problems occurred during OpenAI Salesforce app installation ';
	//final static String DEVELOPER_EMAIL = 'arnasbaronas@gmail.com';

	public static String externalCredentialName {
		get {
			String externalCredentialName = '';
			if (!String.isBlank(PackageUtility.getNamespacePrefix())) {
				externalCredentialName += PackageUtility.getNamespacePrefix() + '__';
			}
			externalCredentialName += 'OpenAI';
			return externalCredentialName;
		}
	}
	public final static String chatGptSetId {
		get {
			return [
					SELECT Id
					FROM PermissionSet
					WHERE Name = 'ChatGPT_Access'
			].Id;
		}
	}

	@AuraEnabled(Cacheable=true)
	public static Boolean isEmailDeliverabilityEnabled() {
		try {
			Messaging.reserveSingleEmailCapacity(1);
			Messaging.reserveMassEmailCapacity(1);
			return true;
		} catch (System.NoAccessException exc) {
			return false;
		}
	}

	@AuraEnabled
	public static void sendEmailToDeveloper(String developerEmail, String subject, String body) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(new List<String>{
				developerEmail
		});
		mail.setSubject(subject);
		mail.saveAsActivity = false;
		mail.setPlainTextBody(body);
		Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{
				mail
		});
	}

	@AuraEnabled
	public static void grantAccess(Id userId) {
		Database.insert(new PermissionSetAssignment(
				AssigneeId = userId,
				PermissionSetId = chatGptSetId
		), false);
	}

	global void onInstall(InstallContext context) {
		/*try {
			Id permissionSetId = chatGptSetId;
			List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
			for(User user : [SELECT Id FROM User WHERE IsActive = TRUE]) {
				permissionSetAssignments.add(
						new PermissionSetAssignment(
								AssigneeId = user.Id,
								PermissionSetId = permissionSetId)
				);
			}
			Database.insert(permissionSetAssignments, false);
			if (forceErrorWhileTesting) {
				throw new HandledException('Exception forced to make better unit test coverage');
			}
		} catch (Exception exc) {
			if (isEmailDeliverabilityEnabled()) {
				String emailSubject = ERROR_LOG_EMAIL_SUBJECT + System.Datetime.now();
				String emailBody = ERROR_LOG_EMAIL_SUBJECT + '\n\nError information:\n---' + System.Datetime.now() + '---\n';
				emailBody += '\nError type: ' + exc.getTypeName();
				emailBody += '\nLine number: ' + Integer.valueOf(exc.getLineNumber());
				emailBody += '\nStack trace:\n' + exc.getStackTraceString();
				emailBody += '\nMore information:\n' + exc.getMessage();
				sendEmailToDeveloper(DEVELOPER_EMAIL, emailSubject, emailBody);
			}
		}*/
	}

	public static String getNamespacePrefix() {
		String namespacePrefix;
		List<String> classNameParts = String.valueOf(PackageUtility.class).split('\\.', 2);
		if (classNameParts.size() > 1) {
			Type classType = Type.forName(classNameParts[0], classNameParts[1]);
			if (classType == PackageUtility.class) {
				namespacePrefix = classNameParts[0];
			} else {
				namespacePrefix = '';
			}
		} else {
			namespacePrefix = '';
		}
		return namespacePrefix;
	}
}