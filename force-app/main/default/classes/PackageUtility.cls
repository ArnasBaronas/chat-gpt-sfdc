/**
 * @description Class bundles utility methods used in package
 * @author <a href=mailto:arnasbaronas@gmail.com>Arnas Baronas</a>
 */
@SuppressWarnings('PMD.AvoidGlobalModifier') /* Global access modifier is not necessary any more but cannot be removed because was included in managed package */
global class PackageUtility implements InstallHandler {

	/** @description Utility property contains external credential name used in package */
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

	/** @description Utility property contains permission set id used in package */
	public final static String chatGptSetId {
		get {
			return [
					SELECT Id
					FROM PermissionSet
					WHERE Name = 'ChatGPT_Access'
			].Id;
		}
	}

	/**
	 * @description Method checks if org's email deliverability access level is set to "All email"
	 *
	 * @return Boolean value
	 */
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

	/**
	 * @description Method sends email message.
	 * @param recipient String value of recipient's email address
	 * @param subject String value of email subject
	 * @param body String value of email body
	 */
	@AuraEnabled
	public static void sendEmail(String recipient, String subject, String body) {
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(new List<String>{
				recipient
		});
		mail.setSubject(subject);
		mail.saveAsActivity = false;
		mail.setPlainTextBody(body);
		Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{
				mail
		});
	}

	/**
	 * @description Method insert package PermissionSetAssignment for selected user
	 * @param userId Id of selected user
	 */
	@AuraEnabled
	public static void grantAccess(Id userId) {
		Database.insert(new PermissionSetAssignment(
				AssigneeId = userId,
				PermissionSetId = chatGptSetId
		), false);
	}

	/**
	 * @description Post-Install script
	 * @param context InstallContext used in while running Post-Install script
	 */
	@SuppressWarnings('PMD.EmptyStatementBlock')
	global void onInstall(InstallContext context) {
		/* Post-Install script is not used anymore, but cannot be deprecated */
	}

	/**
	 * @description Method checks if class is in managed package and returns it's namespace if it is
	 * @return String value of namespace
	 */
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