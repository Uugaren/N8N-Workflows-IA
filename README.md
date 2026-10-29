# n8n AI Workflows — Arthur Alves Rocha

Automações com IA que construí em n8n para problemas reais de negócio. Cada pasta tem o workflow exportado (sem credenciais), o schema do banco quando necessário e um README com problema, arquitetura e decisões técnicas.

| Projeto | O que resolve | Status | Stack |
|---|---|---|---|
| [Reativa](reativa/) | Pós-venda, reativação e indicações de clientes de óticas pelo WhatsApp | Em produção (freelance para o OptiFlow) | n8n, OpenAI, Supabase pgvector, Redis |

## Padrões que aparecem nos meus fluxos

- **Agentes com guarda-corpos:** RAG para respostas factuais e encaminhamento para humano quando a informação não existe.
- **Humano no circuito:** a IA pausa sozinha quando a equipe assume a conversa.
- **Entrada multimodal:** áudio (Whisper) e imagem (visão) viram texto antes do agente.
- **Estado no banco, não no prompt:** jornada do cliente em `flow_state` no Supabase.

## Sobre mim

Estudante de Ciência da Computação na UVV e responsável por dashboards e BI com IA na Diskpan (food service).
Portfólio: [jarentech.com.br](https://jarentech.com.br) · [LinkedIn](https://www.linkedin.com/in/arthur-alves-rocha-651b162b1/)
