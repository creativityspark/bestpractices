# Copilot Studio

Good practices for Microsoft Copilot Studio agent development.

# CS-001: Topic Naming Conventions

All topics must use a consistent naming convention that indicates the topic's category and purpose.

1. Use a **Verb-Noun** structure for topic names that clearly describes the intent (e.g., `Reset Password`, `Check Order Status`).
1. Use a **category prefix** to group related topics (e.g., `HR - Request Leave`, `IT - Reset Password`, `Sales - Get Quote`).
1. Reserve a consistent suffix for sub-topics or dialogs (e.g., `- Confirmation`, `- Error Handling`).
1. Rename all topics immediately after creation — never leave default names like `Topic 1` or `Untitled`.
1. Keep names concise but descriptive enough to identify the topic's purpose at a glance.

## Rationale

1. Default names like `Topic 1` provide no context and make it difficult to manage agents with many topics.
1. A Verb-Noun structure makes intent immediately clear when browsing the topic list.
1. Category prefixes enable quick filtering and grouping in the authoring canvas, especially in agents with dozens of topics.
1. Consistent naming reduces confusion when multiple makers collaborate on the same agent.

## Examples

### Good

- `HR - Request Leave` — clear category and action
- `IT - Reset Password` — grouped under IT, describes the intent
- `Order - Check Status` — grouped under Orders, specific action
- `Order - Cancel Order - Confirmation` — sub-topic clearly linked to parent

### Bad

- `Topic 1` — default name, no context
- `Help` — too vague, could match anything
- `Password` — no action described, unclear intent
- `doStuff` — meaningless and inconsistent format

## More Information
1. [Create and edit topics in Copilot Studio - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-create-edit-topics)
1. [Microsoft Copilot Studio implementation guidance - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/overview)

# CS-002: Trigger Phrase Design

Design trigger phrases that are specific, varied, and non-overlapping across topics to ensure accurate intent matching.

1. Provide **at least 5–10 trigger phrases** per topic, covering different ways a user might express the same intent.
1. Use **specific and detailed phrases** rather than single words or generic terms.
1. Avoid **overlapping trigger phrases** between topics — each phrase should clearly map to one topic only.
1. Regularly test trigger phrases using the **Test bot** pane to verify correct topic routing.
1. Review conversation analytics to identify misrouted queries and adjust trigger phrases accordingly.

## Rationale

1. Too few trigger phrases reduce the agent's ability to recognize user intent, leading to unnecessary fallback responses.
1. Generic or single-word triggers (e.g., "help", "status") match too broadly and cause the wrong topic to fire.
1. Overlapping phrases between topics create ambiguity that degrades the conversational experience.
1. Testing and analytics reveal real-world phrasing that users employ, helping you refine triggers over time.

## Examples

### Good

```
// Topic: IT - Reset Password
Trigger phrases:
- "I need to reset my password"
- "How do I change my password?"
- "My password expired, what do I do?"
- "I forgot my password"
- "Can you help me reset my login credentials?"
- "Password reset request"
```

### Bad

```
// Topic: IT - Reset Password
Trigger phrases:
- "password"          // Too vague, overlaps with other password-related topics
- "help"              // Matches almost anything
- "reset"             // Could apply to many unrelated topics

// Topic: IT - Unlock Account (overlapping triggers)
Trigger phrases:
- "I forgot my password"   // Same phrase already in Reset Password topic
- "Can't log in"           // Ambiguous, could be either topic
```

## More Information
1. [Best practices for topic trigger phrases - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/trigger-phrases-best-practices)
1. [Analyze bot performance - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/analytics-overview)

# CS-003: Fallback and Error Handling

Customize the fallback and error system topics to provide a helpful experience when the agent cannot understand or process a user request.

1. Customize the **Fallback** system topic with a friendly message that acknowledges the misunderstanding and suggests alternative actions or topics.
1. After **two or three consecutive fallback triggers**, offer to escalate the user to a human agent or provide a support contact.
1. Customize the **Error** system topic to display a clear, non-technical message when a system error occurs.
1. Log errors to a data source (e.g., Dataverse or SharePoint) using Power Automate for troubleshooting and trend analysis.
1. Use **multiple message variations** in fallback responses to avoid repetition fatigue.

## Rationale

1. The default fallback message is generic and does not guide users toward resolution, leading to frustration and abandonment.
1. Infinite fallback loops without an escalation path trap users in a dead-end conversation, damaging trust in the agent.
1. Technical error messages confuse non-technical users and expose implementation details that could be a security concern.
1. Error logging enables proactive identification of recurring issues and drives continuous improvement.

## Examples

### Good

```
// Fallback topic — first attempt
"I'm sorry, I didn't quite catch that. Could you try rephrasing your question?
Here are some things I can help with:
- Check your order status
- Reset your password
- Contact support"

// Fallback topic — after 2 failed attempts
"It looks like I'm having trouble understanding your request.
Would you like me to connect you with a support agent?"

// Error topic
"Something went wrong on my end. Please try again in a moment.
If the issue continues, contact support at support@contoso.com."
```

### Bad

```
// Default fallback with no guidance
"I didn't understand that."

// Infinite loop with no escalation
"Sorry, I don't know that. Please try again."
// (repeated indefinitely with no alternative path)

// Technical error exposed to user
"Error: HTTP 500 — Internal Server Error in flow Run_GetOrderDetails."
```

## More Information
1. [Configure the fallback topic - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-system-fallback-topic)
1. [Manage system topics - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-system-topics)

# CS-004: Knowledge Sources and Generative Answers

Configure knowledge sources carefully and apply appropriate guardrails when enabling generative answers.

1. Ensure knowledge source documents are **well-structured** with clear headings, bullet points, and concise paragraphs to maximize extraction quality.
1. Keep knowledge sources **up to date** — schedule regular reviews to remove outdated or inaccurate content.
1. **Restrict the scope** of generative answers to your approved knowledge sources rather than allowing the agent to answer from general knowledge.
1. Add a **disclaimer** to generative responses in sensitive or regulated domains (e.g., legal, medical, financial) to indicate that the answer is AI-generated.
1. Review the **conversation transcripts** regularly to identify cases where generative answers were inaccurate or off-topic, and update the knowledge sources accordingly.

## Rationale

1. Poorly structured documents produce fragmented or inaccurate generative responses because the AI cannot reliably extract coherent answers.
1. Outdated knowledge sources lead to incorrect answers that erode user trust and can cause business harm.
1. Unrestricted generative answers increase the risk of hallucinated or off-topic responses that do not reflect your organization's information.
1. Disclaimers manage user expectations and provide legal protection in regulated industries.
1. Continuous review closes the feedback loop, ensuring the agent improves over time.

## Examples

### Good

- Knowledge sources use clear Markdown headings and short paragraphs optimized for AI extraction.
- Generative answers are scoped to an internal SharePoint site and a curated FAQ document.
- A disclaimer is appended: _"This answer was generated from our knowledge base. Please verify with official documentation."_
- Monthly reviews of conversation transcripts identify two new frequently asked questions that are added to the FAQ.

### Bad

- A 200-page unstructured PDF is uploaded as a knowledge source, producing unreliable generative answers.
- Knowledge source documents have not been updated in over a year, and the agent gives outdated policy information.
- Generative answers are enabled without scope restrictions, causing the agent to answer questions outside its domain with fabricated information.
- No disclaimer is provided for AI-generated legal or compliance guidance.

## More Information
1. [Use knowledge sources for generative answers - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/nlu-boost-conversations)
1. [Manage knowledge sources - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/manage-knowledge-sources)

# CS-005: Authentication and Security

Enable end-user authentication and follow security best practices when connecting your agent to external systems and data.

1. **Enable user authentication** in the agent settings and require users to sign in before accessing sensitive data or performing actions.
1. Use **Microsoft Entra ID (Azure AD)** with Single Sign-On (SSO) for agents deployed in Microsoft Teams or organizational channels.
1. Use the **on-behalf-of** authentication flow when calling APIs or Power Automate flows so that actions execute under the authenticated user's identity.
1. Never hard-code credentials, API keys, or secrets in topics or flows — store them in **Azure Key Vault** or **environment variables**.
1. Apply the **principle of least privilege** when configuring connector permissions and API access for the agent.

## Rationale

1. Without authentication, the agent cannot identify the user, making personalized responses and secure data access impossible.
1. SSO provides a seamless experience for users in Teams and eliminates the need for separate login prompts.
1. On-behalf-of flows ensure that data access respects the user's own permissions, preventing privilege escalation.
1. Hard-coded secrets can be exposed through solution exports, version history, or accidental sharing, creating a security vulnerability.
1. Overly permissive connections increase the blast radius if the agent or its connections are compromised.

## Examples

### Good

- Authentication is enabled with Microsoft Entra ID; users sign in via SSO when they open the agent in Teams.
- A Power Automate flow retrieves the user's pending approvals using the authenticated user's token, so each user only sees their own data.
- API keys for a third-party service are stored in Azure Key Vault and referenced via environment variables in the solution.

### Bad

- The agent is published without authentication, allowing anonymous users to access internal HR data.
- A Power Automate flow runs under a service account with global admin permissions to retrieve employee records, ignoring individual user permissions.
- An API key is pasted directly into a topic's HTTP request action and is visible in the solution export.

## More Information
1. [Configure user authentication in Copilot Studio - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/configuration-end-user-authentication)
1. [Configure single sign-on for Copilot Studio - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/configure-sso)

# CS-006: Application Lifecycle Management (ALM)

Use solution-based development and environment separation to manage your agent through development, testing, and production stages.

1. Develop agents inside a **managed solution** — never build directly in the default environment or outside a solution.
1. Maintain at least **three environments**: Development, Test/UAT, and Production.
1. Use **Azure DevOps** or **GitHub Actions** pipelines to automate solution export, import, and deployment across environments.
1. **Increment the solution version** with every deployment so that changes are traceable and rollbacks are possible.
1. Use **environment variables** for configuration values that differ between environments (e.g., URLs, connection references, feature flags).

## Rationale

1. Building outside a solution makes it impossible to reliably move agents between environments, leading to manual and error-prone deployments.
1. Environment separation prevents untested changes from reaching end users and protects production stability.
1. Automated pipelines reduce human error in the deployment process and provide an auditable deployment history.
1. Solution versioning enables rollback to a known-good state if a deployment introduces issues.
1. Hard-coded environment-specific values break when a solution is imported into a different environment.

## Examples

### Good

- The agent and all its dependencies (topics, flows, connection references, environment variables) are packaged in a solution named `Contoso_IT_HelpDesk`.
- A GitHub Actions pipeline exports the solution from Dev, imports it into Test, and after approval, promotes it to Production.
- Environment variables `ev_ServiceNowUrl` and `ev_ApprovalEmailGroup` are configured per environment.

### Bad

- The agent is built in the default environment with no solution, and topics are manually recreated in production.
- Changes are tested in production because there is only one environment.
- A flow contains a hard-coded URL `https://dev-api.contoso.com` that fails when imported to the production environment.

## More Information
1. [Export and import agents using solutions - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-export-import-bots)
1. [Application lifecycle management with Power Platform - Microsoft Learn](https://learn.microsoft.com/en-us/power-platform/alm/overview-alm)

# CS-007: Testing and Analytics

Establish a thorough testing strategy and use built-in analytics to continuously improve your agent's performance.

1. Use the **Test bot** pane during development to verify every topic's conversation path, including branching and error scenarios.
1. Create a **test script** that covers all topics, edge cases, and expected fallback scenarios, and run it before every deployment.
1. Monitor the **Analytics dashboard** regularly to track resolution rate, escalation rate, abandonment rate, and customer satisfaction (CSAT).
1. Review **conversation transcripts** weekly to identify misunderstood intents, missing topics, and areas for improvement.
1. Set up **alerts or dashboards** for critical metrics (e.g., sudden increase in fallback rate or error rate) to catch regressions early.

## Rationale

1. Untested conversation paths lead to broken experiences that users encounter in production, damaging trust and increasing support costs.
1. A structured test script ensures consistent coverage and prevents regressions when topics are added or modified.
1. Analytics provide data-driven insight into how users interact with the agent and where the experience breaks down.
1. Transcript reviews reveal real user language and uncover gaps that analytics alone cannot surface.
1. Proactive monitoring catches issues before they affect a large number of users.

## Examples

### Good

- A test script documents 50+ test scenarios, including happy paths, edge cases, and fallback triggers, and is executed before every release.
- The analytics dashboard is reviewed weekly; a drop in resolution rate from 85% to 70% triggers an investigation and topic updates.
- Conversation transcripts reveal that users frequently ask about "PTO balance" but no topic exists — a new topic is created.

### Bad

- Topics are published without testing; users discover that a critical branch leads to a dead end.
- Analytics are never reviewed; the agent's fallback rate has been 40% for months without anyone noticing.
- Conversation transcripts are enabled but never read, missing opportunities to improve the agent.

## More Information
1. [Test your agent - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-test-bot)
1. [Analyze agent performance - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/analytics-overview)
1. [Export conversation transcripts - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/analytics-sessions-transcripts)

# CS-008: Channel Deployment and User Experience

Plan your deployment channels carefully and design the conversational experience to match each channel's capabilities.

1. Identify and prioritize the **target channels** (Microsoft Teams, web chat, mobile, custom) before designing the conversation flow.
1. Test the agent on **every target channel** before going live — message formatting, adaptive cards, and authentication behave differently across channels.
1. Write a clear and helpful **greeting message** that sets expectations about what the agent can do.
1. Use **quick replies and suggested actions** to guide users through common paths and reduce free-text input.
1. Keep messages **concise** — avoid walls of text, and split long responses across multiple messages when necessary.

## Rationale

1. Conversation flows designed for web chat may not render correctly in Teams or other channels due to differences in card support, message length, and authentication.
1. Testing on the actual channel prevents formatting issues, broken links, or authentication failures from reaching production users.
1. A well-crafted greeting reduces fallback rates by immediately telling users what the agent can help with.
1. Quick replies and suggested actions lower the barrier to interaction and reduce the chance of misunderstood free-text input.
1. Long, unbroken messages are difficult to read in chat interfaces and lead to users skipping important information.

## Examples

### Good

```
// Greeting message
"Hi! I'm the Contoso IT Help Desk assistant. I can help you with:
- 🔑 Password resets
- 💻 Software requests
- 🎫 Ticket status

What would you like help with?"

// Suggested actions after a response
[Reset Password] [Check Ticket Status] [Talk to an Agent]
```

### Bad

```
// No greeting — agent starts silently and waits for input
(blank)

// Wall of text with no formatting or guidance
"Welcome to the Contoso IT support bot. This bot can help you with password resets,
software installation requests, hardware requests, VPN issues, email configuration,
printer setup, account unlocking, MFA enrollment, and many other IT-related tasks.
Please type your question below and we will try to help you as best we can.
If we cannot help you, we will transfer you to an agent."
```

## More Information
1. [Publish your agent to multiple channels - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/publication-fundamentals-publish-channels)
1. [Configure the greeting topic - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-system-topics)

# CS-009: Responsible AI and Content Moderation

Apply responsible AI principles and configure content moderation to ensure your agent produces safe, accurate, and appropriate responses.

1. Enable **content moderation** to filter harmful, offensive, or inappropriate content from both user inputs and agent responses.
1. Define clear **behavioral guardrails** by configuring the agent's system message to specify what the agent should and should not discuss.
1. Avoid having the agent provide advice on **high-risk topics** (e.g., medical diagnosis, legal counsel, financial advice) without explicit disclaimers and links to qualified professionals.
1. Regularly **audit agent responses** through transcript reviews to identify instances of inaccurate, biased, or inappropriate content.
1. Include a **feedback mechanism** (e.g., thumbs up/down) so users can flag problematic responses.

## Rationale

1. Without content moderation, the agent may generate or repeat harmful content, exposing the organization to reputational and legal risk.
1. Behavioral guardrails prevent the agent from going off-topic or providing responses outside its intended scope.
1. AI-generated advice on regulated topics can cause real harm if users act on inaccurate information without consulting a professional.
1. Regular audits catch issues that automated filters miss and ensure the agent meets organizational standards over time.
1. User feedback provides a direct signal about response quality and helps prioritize improvements.

## Examples

### Good

- Content moderation is enabled; the agent refuses to engage with abusive or harmful input and responds with: _"I'm here to help with IT support questions. Let me know how I can assist you."_
- The system message instructs the agent: _"You are an IT help desk assistant. Only answer questions related to IT support. Do not provide medical, legal, or financial advice."_
- When asked a medical question, the agent responds: _"I'm not able to help with medical questions. Please consult a healthcare professional."_

### Bad

- Content moderation is disabled; the agent responds to abusive messages or generates inappropriate content.
- No behavioral guardrails are set; the agent answers questions about any topic, including areas where inaccurate answers could cause harm.
- The agent provides detailed financial investment advice with no disclaimer, exposing the organization to liability.

## More Information
1. [Responsible AI FAQ for Copilot Studio - Microsoft Learn](https://learn.microsoft.com/en-us/microsoft-copilot-studio/responsible-ai-overview)
1. [Microsoft Responsible AI principles](https://www.microsoft.com/en-us/ai/responsible-ai)
