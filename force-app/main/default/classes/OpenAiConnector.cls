public with sharing class OpenAiConnector {

	enum RequestType {
		COMPLETIONS,
		EDITS,
		IMAGES
	}

	@AuraEnabled
	public static String getCompletionResponse(String question) {
		String responseBody = callChatGPT(RequestType.COMPLETIONS, new OpenAiRequest.Completions(String.escapeSingleQuotes(question)));
		return ((OpenAiResponse.Completions) JSON.deserialize(responseBody, OpenAiResponse.Completions.class)).choices[0].text.removeStart('\n\n');
	}

	@AuraEnabled
	public static String getEditResponse(String prompt, String instructions) {
		String responseBody = callChatGPT(RequestType.EDITS, new OpenAiRequest.Edits(String.escapeSingleQuotes(prompt), String.escapeSingleQuotes(instructions)));
		return ((OpenAiResponse.Edits) JSON.deserialize(responseBody, OpenAiResponse.Edits.class)).choices[0].text;
	}

	@AuraEnabled
	public static String getImageResponse(String prompt) {
		String responseBody = callChatGPT(RequestType.COMPLETIONS, new OpenAiRequest.Images(String.escapeSingleQuotes(prompt)));
		return ((OpenAiResponse.Images) JSON.deserialize(responseBody, OpenAiResponse.Images.class)).data[0].url;
	}

	public static String callChatGPT(RequestType requestType, OpenAiRequest requestBody) {
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('callout:' /*+ managedPackagePrefix()*/ + PackageUtility.externalCredentialName + '/' + requestType.name().toLowerCase());
		request.setBody(JSON.serialize(requestBody));
		request.setHeader('Content-Type', 'application/json;charset=UTF-8');
		request.setTimeout(120000);
		HttpResponse response = new Http().send(request);
		switch on String.valueOf(response.getStatusCode()) {
			when '200' {
				return response.getBody();
			}
			when else {
				throw new CalloutException(response.getBody());
			}
		}
	}
}