@IsTest
private class OpenAi_Test {

	final static String PROFILE_TO_TEST_SETUP = 'System Administrator';
	final static String PROFILE_TO_TEST_USAGE = 'Standard User';
	final static String TEXT_RESPONSE_MOCK = 'openAI_textResponse_mock';
	final static String IMAGE_RESPONSE_MOCK = 'openAI_imageResponse_mock';
	final static String TEXT_RESULT_MOCK = ((OpenAiResponse.Completions) JSON.deserialize(
			[
					SELECT Body
					FROM StaticResource
					WHERE Name = :TEXT_RESPONSE_MOCK
			].Body.toString(), OpenAiResponse.Completions.class)).choices[0].text;
	final static String IMAGE_RESULT_MOCK = ((OpenAiResponse.Images) JSON.deserialize(
			[
					SELECT Body
					FROM StaticResource
					WHERE Name = :IMAGE_RESPONSE_MOCK
			].Body.toString(), OpenAiResponse.Images.class)).data[0].url;


	@IsTest(SeeAllData=true) //ConnectApi methods are not supported in data siloed tests.
	static void updateApiKey() {
		System.runAs(prepareUserForTest(PROFILE_TO_TEST_SETUP)) {
			try {
				OpenAiAuthManger.updateApiKey('newKey');
			} catch (Exception exc) {
				System.debug(exc.getMessage());
				Assert.fail('API key update should not throw exceptions - ' + exc.getMessage());
			}
		}
	}

	@IsTest
	static void checkConnection() {
		System.runAs(prepareUserForTest(PROFILE_TO_TEST_USAGE)) {
			StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
			mock.setStaticResource(TEXT_RESPONSE_MOCK);
			mock.setStatusCode(200);
			Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			try {
				OpenAiAuthManger.checkConnection();
			} catch (Exception exc) {
				Assert.fail('Connection check should not throw exceptions - ' + exc.getMessage());
			}
		}
	}

	@IsTest
	static void checkConnectionFail() {
		System.runAs(prepareUserForTest(PROFILE_TO_TEST_USAGE)) {
			StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
			mock.setStaticResource(TEXT_RESPONSE_MOCK);
			mock.setStatusCode(401);
			Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			try {
				OpenAiAuthManger.checkConnection();
			} catch (Exception exc) {
				Assert.isInstanceOfType(exc, AuraHandledException.class);
			}
		}
	}

	@IsTest
	static void getCompletionResponse() {
		System.runAs(prepareUserForTest(PROFILE_TO_TEST_USAGE)) {
			StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
			mock.setStaticResource(TEXT_RESPONSE_MOCK);
			mock.setStatusCode(200);
			Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			Assert.areEqual(TEXT_RESULT_MOCK, OpenAiConnector.getCompletionResponse('Test'));
		}
	}

	@IsTest
	static void getEditResponse() {
		System.runAs(prepareUserForTest(PROFILE_TO_TEST_USAGE)) {
			StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
			mock.setStaticResource(TEXT_RESPONSE_MOCK);
			mock.setStatusCode(200);
			Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			Assert.areEqual(TEXT_RESULT_MOCK, OpenAiConnector.getEditResponse('Test', 'Test'));
		}
	}

	@IsTest
	static void getImageResponse() {
		System.runAs(prepareUserForTest(PROFILE_TO_TEST_USAGE)) {
			StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
			mock.setStaticResource(IMAGE_RESPONSE_MOCK);
			mock.setStatusCode(200);
			Test.setMock(HttpCalloutMock.class, mock);
			Test.startTest();
			Assert.areEqual(IMAGE_RESULT_MOCK, OpenAiConnector.getImageResponse('Test'));
		}
	}

	static User prepareUserForTest(String profileName) {
		Id profileId = [SELECT Id FROM Profile WHERE Name = :profileName].Id;
		User user = new User(
				Alias = 'test',
				Email = 'ChatGPT@Open.ai.salesforce',
				EmailEncodingKey = 'UTF-8',
				LastName = 'Testing',
				LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'lt',
				ProfileId = profileId,
				TimeZoneSidKey = 'Europe/Helsinki',
				Username = 'ChatGPT@Open.ai.salesforce');

		Database.insert(user);
		Database.insert(new PermissionSetAssignment(
				AssigneeId = user.Id,
				PermissionSetId = PackageUtility.chatGptSetId));

		return user;
	}

}