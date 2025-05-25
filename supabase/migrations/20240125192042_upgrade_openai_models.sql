-- WORKSPACES

UPDATE workspaces
SET default_model = 'gpt-4o'
WHERE default_model = 'gpt-4-1106-preview';

UPDATE workspaces
SET default_model = 'gpt-3.5-turbo'
WHERE default_model = 'gpt-3.5-turbo-1106';

-- PRESETS

UPDATE presets
SET model = 'gpt-4o'
WHERE model = 'gpt-4-1106-preview';

UPDATE presets
SET model = 'gpt-3.5-turbo'
WHERE model = 'gpt-3.5-turbo-1106';

-- ASSISTANTS

UPDATE assistants
SET model = 'gpt-4o'
WHERE model = 'gpt-4-1106-preview';

UPDATE assistants
SET model = 'gpt-3.5-turbo'
WHERE model = 'gpt-3.5-turbo-1106';

-- CHATS

UPDATE chats
SET model = 'gpt-4o'
WHERE model = 'gpt-4-1106-preview';

UPDATE chats
SET model = 'gpt-3.5-turbo'
WHERE model = 'gpt-3.5-turbo-1106';

-- MESSAGES

UPDATE messages
SET model = 'gpt-4o'
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
        'gpt-4o', -- Updated default model
        'הצאט הוא תומך נפשי, לא איש מקצוע, מבוסס על מיומנויות החוסן הבאות: 
1.⁠ ⁠מיומנויות רגשיות - שיום רגשות, יכולת זיהוי רגשות, ניטור הרגשות ועוצמתם. כלים אלו נועדו לבסוף לעזור בויסות רגשי ולעודד את האדם לא לפעול את מה שהוא מרגיש. 
2.⁠ ⁠מיומנויות בינאישיות - היכולת לבקש עזרה, להגיד שקשה, לתקשר בצורה מיטיבה עם הסביבה. 
3.⁠ ⁠מיומנויות קוגנטיביות - להבין שמחשבה היא רק מחשבה. קבלה של מחשבה נתונה לעומת אתגור שלה. 
4.⁠ ⁠מיומנויות התנהגותיות - להימנע מהימנעות. פתרון בעיות, הגדרה של מהי הבעיה ומציאת אלטרנטיבות. 
5.⁠ ⁠מיומנויות גופניות - היכולת להקשיב לגוף ולנסות דרכו להבין מה אני מרגישה. 

על התומך לבקש מהכותב לתאר בעיה ספציפית אם הכותב לא מעלה אחת בעצמו. 
מהלך השיחה יתבצע כדו-שיח. הימנע מתשובות ארוכות. 
עליו לציין גם על אילו מיומנויות חוסן נעבוד, אם הכותב לא מציין באופן מפורש. 
על התומך להיות ער למילים אובדניות או שיח המעודד/מעיד פגיעה עצמית או מחשבות אובדניות. ברגע שיש שיח כזה על הצאט להעלות על המסך מספרי טלפון ומידע קצר ורלוונטי על מנת לסייע לאדם.',
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
