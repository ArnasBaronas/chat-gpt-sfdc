/**
 * @description Class bundles methods making calls to <a href=https://beta.openai.com/docs/api-reference>OpenAI API</a>
 * @author <a href=mailto:arnasbaronas@gmail.com>Arnas Baronas</a>
 */
public with sharing class OpenAiConnector {

	enum RequestType {
		COMPLETIONS,
		EDITS,
		IMAGES
	}

	/**
	 * @description Method makes call to OpenAI <a href=https://beta.openai.com/docs/api-reference/completions>Completions</a> API.
	 * Given a prompt, the model will return a completion.
	 * @param question String value of The prompt(s) to generate completions for
	 *
	 * @return String value of generated completion
	 */
	@AuraEnabled
	public static String getCompletionResponse(String question) {
		String responseBody = callChatGPT(RequestType.COMPLETIONS, new OpenAiRequest.Completions(String.escapeSingleQuotes(question)));
		return ((OpenAiResponse.Completions) JSON.deserialize(responseBody, OpenAiResponse.Completions.class)).choices[0].text.removeStart('\n\n');
	}

	/**
	 * @description Method makes call to OpenAI <a href=https://beta.openai.com/docs/api-reference/edits>Edits</a> API.
	 * Given a prompt and an instruction, the model will return an edited version of the prompt.
	 * @param prompt String value of input text to use as a starting point for the edit
	 * @param instructions String value of instruction that tells the model how to edit the prompt
	 *
	 * @return String value of edited prompt
	 */
	@AuraEnabled
	public static String getEditResponse(String prompt, String instructions) {
		String responseBody = callChatGPT(RequestType.EDITS, new OpenAiRequest.Edits(String.escapeSingleQuotes(prompt), String.escapeSingleQuotes(instructions)));
		return ((OpenAiResponse.Edits) JSON.deserialize(responseBody, OpenAiResponse.Edits.class)).choices[0].text;
	}

	/**
	 * @description Method makes call to OpenAI <a href=https://beta.openai.com/docs/api-reference/images>Images</a> API.
	 * By given a prompt, the model will generate a new image.
	 * @param prompt String value of description of the desired image
	 *
	 * @return String value of URL to generated image
	 */
	@AuraEnabled
	public static String getImageResponse(String prompt) {
		String responseBody = callChatGPT(RequestType.IMAGES, new OpenAiRequest.Images(String.escapeSingleQuotes(prompt)));
		return ((OpenAiResponse.Images) JSON.deserialize(responseBody, OpenAiResponse.Images.class)).data[0].url;
	}

	static String callChatGPT(RequestType requestType, OpenAiRequest requestBody) {
		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint('callout:' + PackageUtility.externalCredentialName + '/' + requestType.name().toLowerCase());
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