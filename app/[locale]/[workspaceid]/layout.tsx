"use client"

import { Dashboard } from "@/components/ui/dashboard"
import { ChatbotUIContext } from "@/context/context"
import { getAssistantWorkspacesByWorkspaceId } from "@/db/assistants"
import { getChatsByWorkspaceId } from "@/db/chats"
import { getCollectionWorkspacesByWorkspaceId } from "@/db/collections"
import { getFileWorkspacesByWorkspaceId } from "@/db/files"
import { getFoldersByWorkspaceId } from "@/db/folders"
import { getModelWorkspacesByWorkspaceId } from "@/db/models"
import { getPresetWorkspacesByWorkspaceId } from "@/db/presets"
import { getPromptWorkspacesByWorkspaceId } from "@/db/prompts"
import { getAssistantImageFromStorage } from "@/db/storage/assistant-images"
import { getToolWorkspacesByWorkspaceId } from "@/db/tools"
import { getWorkspaceById } from "@/db/workspaces"
import { convertBlobToBase64 } from "@/lib/blob-to-b64"
import { supabase } from "@/lib/supabase/browser-client"
import { LLMID } from "@/types"
import { useParams, useRouter, useSearchParams } from "next/navigation"
import { ReactNode, useContext, useEffect, useState } from "react"
import Loading from "../loading"

interface WorkspaceLayoutProps {
  children: ReactNode
}

export default function WorkspaceLayout({ children }: WorkspaceLayoutProps) {
  const router = useRouter()

  const params = useParams()
  const searchParams = useSearchParams()
  const workspaceId = params.workspaceid as string

  const {
    setChatSettings,
    setAssistants,
    setAssistantImages,
    setChats,
    setCollections,
    setFolders,
    setFiles,
    setPresets,
    setPrompts,
    setTools,
    setModels,
    selectedWorkspace,
    setSelectedWorkspace,
    setSelectedChat,
    setChatMessages,
    setUserInput,
    setIsGenerating,
    setFirstTokenReceived,
    setChatFiles,
    setChatImages,
    setNewMessageFiles,
    setNewMessageImages,
    setShowFilesDisplay
  } = useContext(ChatbotUIContext)

  const [loading, setLoading] = useState(true)

  useEffect(() => {
    ;(async () => {
      const session = (await supabase.auth.getSession()).data.session

      if (!session) {
        return router.push("/login")
      } else {
        await fetchWorkspaceData(workspaceId)
      }
    })()
  }, [])

  useEffect(() => {
    ;(async () => await fetchWorkspaceData(workspaceId))()

    setUserInput("")
    setChatMessages([])
    setSelectedChat(null)

    setIsGenerating(false)
    setFirstTokenReceived(false)

    setChatFiles([])
    setChatImages([])
    setNewMessageFiles([])
    setNewMessageImages([])
    setShowFilesDisplay(false)
  }, [workspaceId])

  const fetchWorkspaceData = async (workspaceId: string) => {
    setLoading(true)

    const workspace = await getWorkspaceById(workspaceId)
    setSelectedWorkspace(workspace)

    const assistantData = await getAssistantWorkspacesByWorkspaceId(workspaceId)
    setAssistants(assistantData.assistants)

    for (const assistant of assistantData.assistants) {
      let url = ""

      if (assistant.image_path) {
        url = (await getAssistantImageFromStorage(assistant.image_path)) || ""
      }

      if (url) {
        const response = await fetch(url)
        const blob = await response.blob()
        const base64 = await convertBlobToBase64(blob)

        setAssistantImages(prev => [
          ...prev,
          {
            assistantId: assistant.id,
            path: assistant.image_path,
            base64,
            url
          }
        ])
      } else {
        setAssistantImages(prev => [
          ...prev,
          {
            assistantId: assistant.id,
            path: assistant.image_path,
            base64: "",
            url
          }
        ])
      }
    }

    const chats = await getChatsByWorkspaceId(workspaceId)
    setChats(chats)

    const collectionData =
      await getCollectionWorkspacesByWorkspaceId(workspaceId)
    setCollections(collectionData.collections)

    const folders = await getFoldersByWorkspaceId(workspaceId)
    setFolders(folders)

    const fileData = await getFileWorkspacesByWorkspaceId(workspaceId)
    setFiles(fileData.files)

    const presetData = await getPresetWorkspacesByWorkspaceId(workspaceId)
    setPresets(presetData.presets)

    const promptData = await getPromptWorkspacesByWorkspaceId(workspaceId)
    setPrompts(promptData.prompts)

    const toolData = await getToolWorkspacesByWorkspaceId(workspaceId)
    setTools(toolData.tools)

    const modelData = await getModelWorkspacesByWorkspaceId(workspaceId)
    setModels(modelData.models)

    setChatSettings({
      model: (searchParams.get("model") ||
        workspace?.default_model ||
        "gpt-4o") as LLMID,
      prompt:
        workspace?.default_prompt ||
        `מטרתך היא לספק סיוע רגשי ראשוני למילואימניקים שלחמו במסגרת מלחמת חרבות ברזל, המתמודדים עם אתגרים נפשיים בעקבות שירותם, תוך שימוש בלעדי בכלים ובידע הכלולים בחוברת. במהלך השיחה, עליך לפעול ברגישות, אמפתיה וזהירות באופן מאתגר וחד, ולהשתמש רק בכלים, במושגים ובשיטות שהוצגו בחוברת – מיומנויות החוסן, המיומנויות הללו הן חלק מפרוטוקולים מקובלים כמו CBT- Cognitive Behavioral Therapy ו-IPT- Interpersonal Therapy. אל תשתמש בידע חיצוני או המלצות רפואיות אחרות, ואל תחרוג מהמסגרת המוגדרת של החוברת. מטרתך היא להנגיש את הכלים הללו באופן תומך ומותאם למצבו של האדם שמולך, מבלי לאבחן או לטפל, אלא להיות עבורו תחנת תמיכה ראשונית המבוססת על עקרונות נאמני החוסן, בצורה שתוכל לקדם ולאתגר את יכולותיו. עליך לבקש ממשתמש לתאר בעיה ספציפית אם הוא לא מעלה אחת בעצמו. מהלך השיחה יתבצע כדו-שיח. הימנע מתשובות ארוכות ומרשימות. אם הכותב לא מציין באופן מפורש, עליך לציין גם על אילו מיומנויות חוסן נעבוד ולשים לב שאין זליגה בין העבודה על המיומנויות.  עליך התומך להיות ער למילים אובדניות או שיח המעודד/מעיד פגיעה עצמית או מחשבות אובדניות. ברגע שיש שיח כזה עליך להעלות על המסך מספרי טלפון ומידע קצר ורלוונטי על מנת לסייע לאדם - עמותת נט"ל, קו סיוע נפשי 3362* עמותת ער"ן, קו סיוע נפשי 1201.

מיומנויות החוסן:
1. מיומנויות רגשיות – להבין, לשיים ולווסת: שיום רגשות, ניטור רגשות, וויסות רגשות
2. מיומנויות קוגניטיביות – מחשבות הן לא מציאות: זיהוי מחשבות אוטומטיות, תיוג מחשבות, בחינה מחדש
3. מיומנויות התנהגותיות – פעולה מובילה להרגשה: חזרה לפעולה, פעולה הפוכה לרגש, תכנון שגרה
4. מיומנויות גופניות – הגוף כמערכת התרעה וגם ריפוי: זיהוי תחושות גוף, נשימה והרפיה, עיגון דרך החושים
5. מיומנויות בין-אישיות – חיבור כבסיס לריפוי: מיפוי קשרים, תרגול בקשת עזרה, שיקום קשרים

מוקדי בעיה בגישת IPT: 1. אבל בעקבות אובדן 2. קונפליקט משמעותי בחיים 3. שינוי בתפקיד ומעברים 4. קשיים בתקשורת בין-אישית

כלים מגישת IPT: ניתוח תקשורת, ניתוח שרשרת, קבלת החלטות מודל RIBEYE`,
      temperature: workspace?.default_temperature || 0.5,
      contextLength: workspace?.default_context_length || 4096,
      includeProfileContext: workspace?.include_profile_context || true,
      includeWorkspaceInstructions:
        workspace?.include_workspace_instructions || true,
      embeddingsProvider:
        (workspace?.embeddings_provider as "openai" | "local") || "openai"
    })

    setLoading(false)
  }

  if (loading) {
    return <Loading />
  }

  return <Dashboard>{children}</Dashboard>
}
