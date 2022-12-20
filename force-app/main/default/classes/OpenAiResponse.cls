/**
 * @description Wrapper class used for OpenAI API response body deserialization
 * @author <a href=mailto:arnasbaronas@gmail.com>Arnas Baronas</a>
 */
@SuppressWarnings('PMD.FieldNamingConventions') /* Field naming should same as stated in OpenAI API documentation for easier serialization */
public virtual class OpenAiResponse {

	public Integer created;

	public class Completions extends OpenAiResponse {
		public String id;
		public String model;
		public List<Choice> choices;
		public Usage usage;
	}

	public class Edits extends OpenAiResponse {
		public List<Choice> choices;
		public Usage usage;
	}

	public class Images extends OpenAiResponse {
		public List<Data> data;
	}

	public class Data {
		public String url;
	}

	public class Choice {
		public String text;
		public Integer index;
		public String logprobs;
		public String finish_reason;
	}

	public class Usage {
		public Integer prompt_tokens;
		public Integer completion_tokens;
		public Integer total_tokens;
	}
}