# OpenAI Chat-GPT application in Salesforce Lighting experience ⚡

Standalone Salesforce lighting-web-components application created levering [OpenAI Chat-GPT API].

## ✨ Features

- **Completions API interface in lighting experience.**<br />
  <img alt="Completions UI" src="/media/Completions_UI.png" width="500"/>
- **Edits API interface in lighting experience.**<br/>
  <img alt="Edits UI" src="/media/Edits_UI.png" width="500"/>
- **API settings UI.**<br/>
  <img alt="API Settings UI" src="/media/API_Settings_UI.png" width="500"/>

## 🚧 Features under development

- Images API interface in lighting experience.
- Chat-GPT request settings UI.

## 🚫 Limitations

- Apex HTTP Callout timeout Governor Limit (Maximum is set as 120 seconds).
- It seems that package deployment with external named credentials have some bugs at the moment and Salesforce throws unknown error while trying to deploy.
  - Fortunately, this behavior can be avoided deploying package in stages.
  - Unfortunately, in order to deploy package in stages it has to be managed.

## 📥 Installation

1. Install [**"Pre-Deployment"**] version (package ID = `04t68000000ko4Z`)
2. Go to **OpenAI** lighting application and click _**"Process Pre-Deployment"**_ button.
3. Upgrade package to [**"Initial Version"**] (package ID = `04t68000000ko8w`).
4. The OpenAI API uses API keys for authentication. Visit your [API keys] page to retrieve the API key. Save it after generating it, you will need it to complete application setup.
5. Update API key in **OpenAI** lighting application's **API settings** section
6. If application still do not work, go to **OpenAI** lighting application's **API settings** section and click _**"Grant Access"**_ button.

https://user-images.githubusercontent.com/55427802/208730474-de75819f-d07e-4768-ac3a-c7e34880f803.mp4

## 🗑️ Uninstalling

1. [Execute anonymous apex] block:

```java
 Database.delete([
		SELECT Id
		FROM PermissionSetAssignment
		WHERE PermissionSet.Name = 'ChatGPT_Access'
]);
```

2. Go to **Setup &rarr; Platform Tools &rarr; Apps &rarr; Installed Packages**
3. Find and uninstall **"Chat-GPT"** managed package

## 👤 Author

**🧑‍💻 Arnas Baronas**

- :octocat: Github: [@ArnasBaronas]
- 📧 Email: [arnasbaronas@gmail.com]

## 🤝 Development

- If you have suggestions for how this app could be improved, or want to report a bug, open an issue or [write me] an email! We'd love all and any contributions.
- In order to run this application as unmanaged package keep in mind that some component's references have managed packaged **(chatGPT\_\_)** namespace. Delete them before deployment.

[//]: #
[openai chat-gpt api]: https://openai.com/api/
[**"pre-deployment"**]: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t68000000ko4Z
[**"initial version"**]: https://login.salesforce.com/packaging/installPackage.apexp?p0=04t68000000ko8w
[execute anonymous apex]: https://help.salesforce.com/s/articleView?id=sf.code_dev_console_execute_anonymous.htm
[write me]: mailto:arnasbaronas@gmail.com?subject=chat-gpt-sfdc%20feedback
[arnasbaronas@gmail.com]: mailto:arnasbaronas@gmail.com
[@arnasbaronas]: https://github.com/ArnasBaronas
[api keys]: https://beta.openai.com/account/api-keys
