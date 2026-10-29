-- Schema do Reativa (Supabase / Postgres)
-- Tabelas de RAG e memória vêm dos nós de setup do workflow.
-- mensagens, clientes_completos e indicacoes foram reconstruídas a partir das colunas que o workflow lê e escreve.

create extension if not exists vector;

-- Base de conhecimento (RAG)
create table if not exists documents (
  id bigserial primary key,
  content text,
  metadata jsonb,
  embedding vector(1536) -- text-embedding-3-small
);

create or replace function match_documents (
  query_embedding vector(1536),
  match_count int default null,
  filter jsonb default '{}'
) returns table (id bigint, content text, metadata jsonb, similarity float)
language plpgsql as $$
#variable_conflict use_column
begin
  return query
  select id, content, metadata, 1 - (documents.embedding <=> query_embedding) as similarity
  from documents
  where metadata @> filter
  order by documents.embedding <=> query_embedding
  limit match_count;
end;
$$;

-- Memória do agente (formato do nó Postgres Chat Memory do n8n)
create table if not exists n8n_chat_histories (
  id serial primary key,
  session_id varchar(255) not null,
  message jsonb not null
);

-- Clientes da ótica (base importada pela agência)
create table if not exists clientes_completos (
  id bigserial primary key,
  telefone text,
  primeiro_nome text,
  nome_completo text
);

-- Histórico e estado de cada conversa
create table if not exists mensagens (
  id bigserial primary key,
  created_at timestamptz default now(),
  updated_at timestamptz,
  telefone text,
  nomewpp text,
  cliente_id bigint references clientes_completos(id),
  user_message text,
  bot_message text,
  message_type text,
  flow_state text,            -- follow_up_7dias, vencimento_receita, aniversario, reparo...
  atendimento_ia text,        -- 'pause' quando um humano assume
  active boolean default true,
  resumido boolean default false
);

-- Programa de indicações
create table if not exists indicacoes (
  id bigserial primary key,
  created_at timestamptz default now(),
  cliente_indicador_id bigint references clientes_completos(id),
  nome_cliente_indicador text,
  nome_indicado text,
  telefones_indicados text
);
