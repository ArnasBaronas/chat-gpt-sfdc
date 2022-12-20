@IsTest
private class PackageUtility_Test {
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
			PackageUtility.sendEmail('test@tester.com', 'test', 'test');
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