/**
 * @description Class bundles methods related to API connection management and testing.
 * @author <a href=mailto:arnasbaronas@gmail.com>Arnas Baronas</a>
 */
public with sharing class OpenAiAuthManger {
  final static String PRINCIPLE_NAME = 'ChatGPT_Access_cDnjCvC1671376892663';

  /**
   * @description Method encrypts and updates OpenAI API key saved in named credentials.
   * @param apiKey String value of new API key
   */
  @AuraEnabled
  public static void updateApiKey(String apiKey) {
    ConnectApi.CredentialValueInput updatedKeyInput = new ConnectApi.CredentialValueInput();
    updatedKeyInput.value = apiKey;
    updatedKeyInput.encrypted = true;

    ConnectApi.CredentialInput input = new ConnectApi.CredentialInput();
    input.principalType = ConnectApi.CredentialPrincipalType.NamedPrincipal;
    input.externalCredential = PackageUtility.externalCredentialName;
    input.principalName = PRINCIPLE_NAME;
    input.authenticationProtocol = ConnectApi.CredentialAuthenticationProtocol.Custom;
    input.credentials = new Map<String, ConnectApi.CredentialValueInput>{
      'Key' => updatedKeyInput
    };
    try {
      ConnectApi.NamedCredentials.createCredential(input);
    } catch (ConnectApi.ConnectApiException exc) {
      ConnectApi.NamedCredentials.updateCredential(input);
    }
  }

  final static String CONNECTION_CHECK_QUESTION = 'Who invented the internet?';

  /** @description Method makes call to OpenAI API to test if connection is valid */
  @AuraEnabled
  public static void checkConnection() {
    try {
      OpenAiConnector.getCompletionResponse(CONNECTION_CHECK_QUESTION);
    } catch (Exception exc) {
      throw new AuraHandledException(exc.getMessage());
    }
  }
}
