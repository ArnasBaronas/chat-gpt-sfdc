@IsTest
private class PackageUtility_Test {

	/*@IsTest
	static void testNewInstallation() {
		PackageUtility installation = new PackageUtility();
		Test.testInstall(installation, null);

	}

	@IsTest
	static void testExistingInstallation() {
		Database.insert(new PermissionSetAssignment(
				AssigneeId = UserInfo.getUserId(),
				PermissionSetId = PackageUtility.chatGptSetId), false);
		PackageUtility installation = new PackageUtility();
		Test.testInstall(installation, new Version(1,0), true);
	}

	@IsTest
	static void testFailingInstallation() {
		PackageUtility installation = new PackageUtility();
		installation.forceErrorWhileTesting = true;
		Test.testInstall(installation, new Version(1,0), true);
		Assert.areEqual(1, System.Limits.getEmailInvocations());
	}*/

	@IsTest
	static void grantAccess() {
		PackageUtility.grantAccess(UserInfo.getUserId());
		Assert.areEqual(1, [
				SELECT Id
				FROM PermissionSetAssignment
				WHERE AssigneeId = :UserInfo.getUserId() AND PermissionSetId = :PackageUtility.chatGptSetId
		].size());
	}

	@IsTest
	static void externalNamedCredential() {
		Assert.isTrue(PackageUtility.externalCredentialName.contains('OpenAI'));
	}

	@IsTest
	static void install() {
		PackageUtility installation = new PackageUtility();
		try {
			Test.testInstall(installation, null);
		} catch (Exception exc) {
			Assert.fail(exc.getMessage());
		}
	}

	@IsTest
	static void sendEmail() {
		try {
			PackageUtility.sendEmailToDeveloper('test@tester.com', 'test', 'test');
			if (!PackageUtility.isEmailDeliverabilityEnabled()) {
				Assert.fail('Feature shouldn\'t work');
			}
		} catch (Exception exc) {
			if (PackageUtility.isEmailDeliverabilityEnabled()) {
				Assert.fail('Email sending should not throw exceptions - ' + exc.getMessage());
			}
		}
	}
}