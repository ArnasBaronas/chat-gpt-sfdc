/**
 * @description Wrapper class used for OpenAI API request body serialization
 * @author <a href=mailto:arnasbaronas@gmail.com>Arnas Baronas</a>
 */
@SuppressWarnings('PMD.FieldNamingConventions') /* Field naming should same as stated in OpenAI API documentation for easier serialization */
public virtual class OpenAiRequest {

	//TODO: move to custom metadata and implement UI changes
	public class Completions extends OpenAiRequest {
		final String prompt;
		final String model = 'text-davinci-003';
		final Integer max_tokens = 4000;
		final Integer temperature = 0;
		final Boolean stream = false;

		public Completions(String prompt) {
			this.prompt = prompt;
		}
	}

	public class Edits extends OpenAiRequest {
		final String input;
		final String instruction;
		final String model = 'text-davinci-edit-001';

		public Edits(String input, String instruction) {
			this.input = input;
			this.instruction = instruction;
		}
	}

	public class Images extends OpenAiRequest {
		final String prompt;
		final Integer n;
		final String size;

		public Images(String prompt) {
			this.prompt = prompt;
		}
	}
}