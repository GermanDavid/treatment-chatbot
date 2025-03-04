-- WORKSPACES

UPDATE workspaces
SET default_model = 'gpt-4-turbo-preview'
WHERE default_model = 'gpt-4-1106-preview';

UPDATE workspaces
SET default_model = 'gpt-3.5-turbo'
WHERE default_model = 'gpt-3.5-turbo-1106';

-- PRESETS

UPDATE presets
SET model = 'gpt-4-turbo-preview'
WHERE model = 'gpt-4-1106-preview';

UPDATE presets
SET model = 'gpt-3.5-turbo'
WHERE model = 'gpt-3.5-turbo-1106';

-- ASSISTANTS

UPDATE assistants
SET model = 'gpt-4-turbo-preview'
WHERE model = 'gpt-4-1106-preview';

UPDATE assistants
SET model = 'gpt-3.5-turbo'
WHERE model = 'gpt-3.5-turbo-1106';

-- CHATS

UPDATE chats
SET model = 'gpt-4-turbo-preview'
WHERE model = 'gpt-4-1106-preview';

UPDATE chats
SET model = 'gpt-3.5-turbo'
WHERE model = 'gpt-3.5-turbo-1106';

-- MESSAGES

UPDATE messages
SET model = 'gpt-4-turbo-preview'
WHERE model = 'gpt-4-1106-preview';

UPDATE messages
SET model = 'gpt-3.5-turbo'
WHERE model = 'gpt-3.5-turbo-1106';

-- PROFILES

CREATE OR REPLACE FUNCTION create_profile_and_workspace() 
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    random_username TEXT;
BEGIN
    -- Generate a random username
    random_username := 'user' || substr(replace(gen_random_uuid()::text, '-', ''), 1, 16);

    -- Create a profile for the new user
    INSERT INTO public.profiles(user_id, anthropic_api_key, azure_openai_35_turbo_id, azure_openai_45_turbo_id, azure_openai_45_vision_id, azure_openai_api_key, azure_openai_endpoint, google_gemini_api_key, has_onboarded, image_url, image_path, mistral_api_key, display_name, bio, openai_api_key, openai_organization_id, perplexity_api_key, profile_context, use_azure_openai, username)
    VALUES(
        NEW.id,
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        FALSE,
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        FALSE,
        random_username
    );

    INSERT INTO public.workspaces(user_id, is_home, name, default_context_length, default_model, default_prompt, default_temperature, description, embeddings_provider, include_profile_context, include_workspace_instructions, instructions)
    VALUES(
        NEW.id,
        TRUE,
        'Home',
        4096,
        'gpt-4-turbo-preview', -- Updated default model
        'The chat is a mental supporter, not a professional, based on the following resilience skills:
1.⁠ ⁠Emotional skills - naming emotions, ability to identify emotions, monitoring emotions and their intensity. These tools are ultimately intended to help with emotional regulation and encourage the person not to act on what they feel.
2.⁠ ⁠Interpersonal skills - the ability to ask for help, to say that it is difficult, to communicate in a beneficial way with the environment.
3.⁠ ⁠Cognitive skills - understanding that a thought is just a thought. Acceptance of a given thought versus challenging it.
4.⁠ ⁠Behavioral skills - avoiding avoidance. Problem solving, defining what the problem is and finding alternatives.
5.⁠ ⁠Physical skills - the ability to listen to the body and try to understand what I feel through it.

The supporter asks to describe a specific problem if the writer does not bring it up.
It should also be noted which resilience skills we will work on, if the writer does not explicitly state it.

The supporter should be aware of suicidal words or speech that encourages/indicates self-harm or suicidal thoughts. As soon as such speech occurs, the chat should display phone numbers and brief, relevant information to assist the person.',
        0.5,
        'My home workspace.',
        'openai',
        TRUE,
        TRUE,
        ''
    );

    RETURN NEW;
END;
$$;
