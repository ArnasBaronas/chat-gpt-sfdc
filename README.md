# OpenAI Chat-GPT application in Salesforce Lighting experience ⚡


## ✨ Features

- **Completions API interface in lighting experience.**<br />
  <img alt="Completions UI" src="/images/Completions_UI.png"/>
- **Edits API interface in lighting experience.**<br/>
  <img alt="Edits UI" src="/images/Edits_UI.png"/>
- **API settings UI.**<br/>
  <img alt="API Settings UI" src="/images/API_Settings_UI.png"/>

## 🚧 Features under development

- Images API interface in lighting experience.
- Chat-GPT request settings UI.

## 🚫 Limitations

- Apex HTTP Callout timeout Governor Limit (Maximum is set as 120 seconds).
- It seems that package deployment with external named credentials have some bugs at the moment and Salesforce throws unknown error while trying to deploy.
    - Fortunately, this behavior can be avoided deploying package in stages.
    - Unfortunately, in order to deploy package in stages it has to be managed.

---

## 📥 Installation <a href="#installation">&larr;</a>

1. Install **"Pre-Deployment"** version.
2. Go to **OpenAI** lighting application and click _**"Process Pre-Deployment"**_ button.
3. Upgrade package to _**"Initial Version"**_.
4. The OpenAI API uses API keys for authentication. Visit your [API keys] page to retrieve the API key. Save it after generating it, you will need it to complete application setup.
5. Update API key in **OpenAI** lighting application's **API settings** section
6. If application still do not work, go to **OpenAI** lighting application's **API settings** section and click _**"Grant Access"**_ button.


## 🗑️ Uninstalling

1. Execute anonymous apex block:
```java
 Database.delete([
		SELECT Id
		FROM PermissionSetAssignment
		WHERE PermissionSet.Name = 'ChatGPT_Access'
]);
```
2. Go to **Setup &rarr; Platform Tools &rarr; Apps &rarr; Installed Packages**
3. Find and uninstall **"Chat-GPT"** managed package

---

## 👤 Author

**🧑‍💻 Arnas Baronas**
- :octocat: Github: [@ArnasBaronas](https://github.com/ArnasBaronas)
- 📧 Email: [arnasbaronas@gmail.com](mailto:arnasbaronas@gmail.com)


## 🤝 Development

If you have suggestions for how this app could be improved, or want to report a bug, open an issue or [write me](mailto:arnasbaronas@gmail.com?subject=chat-gpt-sfdc%20feedback) an email! We'd love all and any contributions.

[//]: #

[API keys]: <https://beta.openai.com/account/api-keys>
