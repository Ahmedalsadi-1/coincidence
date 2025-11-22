-- CreateTable
CREATE TABLE "accounts" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "uid" TEXT NOT NULL DEFAULT '',
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "provider_account_id" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "scope" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "verification_sessions" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "session_id" TEXT NOT NULL,
    "purpose" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "hashed_password" TEXT,
    "expires_at" DATETIME NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "users" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "uid" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nickname" TEXT,
    "email" TEXT,
    "avatar" TEXT,
    "email_verified" DATETIME,
    "password" TEXT,
    "ui_locale" TEXT,
    "output_locale" TEXT,
    "has_beta_access" BOOLEAN NOT NULL DEFAULT true,
    "preferences" TEXT,
    "onboarding" TEXT,
    "customer_id" TEXT,
    "subscription_id" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "action_results" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "result_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 0,
    "type" TEXT NOT NULL DEFAULT 'skill',
    "uid" TEXT NOT NULL DEFAULT '',
    "title" TEXT NOT NULL DEFAULT '',
    "tier" TEXT DEFAULT '',
    "model_name" TEXT,
    "target_type" TEXT,
    "target_id" TEXT,
    "action_meta" TEXT,
    "input" TEXT,
    "context" TEXT,
    "tpl_config" TEXT,
    "runtime_config" TEXT,
    "history" TEXT,
    "errors" TEXT,
    "error_type" TEXT,
    "locale" TEXT DEFAULT '',
    "project_id" TEXT,
    "status" TEXT NOT NULL DEFAULT 'waiting',
    "duplicate_from" TEXT,
    "provider_item_id" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "action_steps" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "result_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL DEFAULT 0,
    "order" INTEGER NOT NULL DEFAULT 0,
    "name" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "reasoning_content" TEXT,
    "tier" TEXT DEFAULT '',
    "structured_data" TEXT NOT NULL DEFAULT '{}',
    "logs" TEXT NOT NULL DEFAULT '[]',
    "artifacts" TEXT NOT NULL DEFAULT '[]',
    "token_usage" TEXT NOT NULL DEFAULT '[]',
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "token_usages" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "uid" TEXT NOT NULL,
    "result_id" TEXT,
    "tier" TEXT NOT NULL,
    "model_provider" TEXT NOT NULL,
    "model_name" TEXT NOT NULL,
    "input_tokens" INTEGER NOT NULL DEFAULT 0,
    "output_tokens" INTEGER NOT NULL DEFAULT 0,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "static_files" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "uid" TEXT NOT NULL,
    "storage_key" TEXT NOT NULL,
    "storage_size" BIGINT NOT NULL DEFAULT 0,
    "content_type" TEXT NOT NULL DEFAULT '',
    "processed_image_key" TEXT,
    "entity_id" TEXT,
    "entity_type" TEXT,
    "visibility" TEXT NOT NULL DEFAULT 'private',
    "expired_at" DATETIME,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "canvases" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "canvas_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT 'Untitled',
    "storage_size" BIGINT NOT NULL DEFAULT 0,
    "state_storage_key" TEXT,
    "minimap_storage_key" TEXT,
    "read_only" BOOLEAN NOT NULL DEFAULT false,
    "is_public" BOOLEAN NOT NULL DEFAULT false,
    "status" TEXT NOT NULL DEFAULT 'ready',
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME,
    "project_id" TEXT,
    CONSTRAINT "canvases_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects" ("project_id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "canvas_templates" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "template_id" TEXT NOT NULL,
    "origin_canvas_id" TEXT NOT NULL DEFAULT '',
    "category_id" TEXT,
    "share_id" TEXT NOT NULL DEFAULT '',
    "version" INTEGER NOT NULL DEFAULT 0,
    "uid" TEXT NOT NULL,
    "share_user" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "is_public" BOOLEAN NOT NULL DEFAULT false,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "language" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME,
    CONSTRAINT "canvas_templates_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "canvas_template_categories" ("category_id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "canvas_template_categories" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "category_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "label_dict" TEXT NOT NULL,
    "description_dict" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "canvas_entity_relations" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "canvas_id" TEXT NOT NULL,
    "entity_id" TEXT NOT NULL,
    "entity_type" TEXT NOT NULL,
    "is_public" BOOLEAN NOT NULL DEFAULT false,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "file_parse_records" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "resource_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "parser" TEXT NOT NULL,
    "content_type" TEXT NOT NULL,
    "num_pages" INTEGER NOT NULL DEFAULT 0,
    "storage_key" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "resources" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "resource_id" TEXT NOT NULL,
    "resource_type" TEXT NOT NULL DEFAULT '',
    "uid" TEXT NOT NULL,
    "word_count" INTEGER NOT NULL DEFAULT 0,
    "content_preview" TEXT,
    "storage_key" TEXT,
    "storage_size" BIGINT NOT NULL DEFAULT 0,
    "vector_size" BIGINT NOT NULL DEFAULT 0,
    "raw_file_key" TEXT,
    "index_status" TEXT NOT NULL DEFAULT 'init',
    "index_error" TEXT,
    "title" TEXT NOT NULL,
    "identifier" TEXT,
    "meta" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME,
    "project_id" TEXT,
    CONSTRAINT "resources_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects" ("project_id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "documents" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "doc_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT 'Untitled',
    "word_count" INTEGER NOT NULL DEFAULT 0,
    "content_preview" TEXT,
    "storage_key" TEXT,
    "storage_size" BIGINT NOT NULL DEFAULT 0,
    "vector_size" BIGINT NOT NULL DEFAULT 0,
    "state_storage_key" TEXT NOT NULL DEFAULT '',
    "read_only" BOOLEAN NOT NULL DEFAULT false,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME,
    "project_id" TEXT,
    CONSTRAINT "documents_project_id_fkey" FOREIGN KEY ("project_id") REFERENCES "projects" ("project_id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "code_artifacts" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "artifact_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT '',
    "type" TEXT,
    "language" TEXT,
    "storage_key" TEXT NOT NULL,
    "preview_storage_key" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "projects" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "project_id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "description" TEXT,
    "cover_storage_key" TEXT,
    "custom_instructions" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "share_records" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "share_id" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT '',
    "storage_key" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "allow_duplication" BOOLEAN NOT NULL DEFAULT false,
    "parent_share_id" TEXT,
    "entity_id" TEXT NOT NULL,
    "entity_type" TEXT NOT NULL,
    "extra_data" TEXT,
    "template_id" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "duplicate_records" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "source_id" TEXT NOT NULL,
    "target_id" TEXT NOT NULL,
    "entity_type" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "share_id" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "references" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "reference_id" TEXT NOT NULL,
    "source_type" TEXT NOT NULL,
    "source_id" TEXT NOT NULL,
    "target_type" TEXT NOT NULL,
    "target_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "skill_instances" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "skill_id" TEXT NOT NULL,
    "tpl_name" TEXT NOT NULL DEFAULT '',
    "display_name" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "icon" TEXT NOT NULL DEFAULT '{}',
    "uid" TEXT NOT NULL,
    "invocation_config" TEXT,
    "config_schema" TEXT,
    "tpl_config" TEXT,
    "pinned_at" DATETIME,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "skill_triggers" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "display_name" TEXT NOT NULL DEFAULT '',
    "trigger_id" TEXT NOT NULL,
    "trigger_type" TEXT NOT NULL,
    "skill_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "simple_event_name" TEXT,
    "timer_config" TEXT,
    "input" TEXT,
    "context" TEXT,
    "tpl_config" TEXT,
    "enabled" BOOLEAN NOT NULL,
    "bull_job_id" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "label_classes" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "label_class_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "icon" TEXT NOT NULL DEFAULT '',
    "name" TEXT NOT NULL,
    "display_name" TEXT NOT NULL,
    "prompt" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "label_instances" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "label_id" TEXT NOT NULL,
    "label_class_id" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "entity_type" TEXT NOT NULL,
    "entity_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME,
    CONSTRAINT "label_instances_label_class_id_fkey" FOREIGN KEY ("label_class_id") REFERENCES "label_classes" ("label_class_id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "providers" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "provider_id" TEXT NOT NULL,
    "provider_key" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "is_global" BOOLEAN NOT NULL DEFAULT false,
    "categories" TEXT NOT NULL DEFAULT '',
    "uid" TEXT,
    "api_key" TEXT,
    "base_url" TEXT,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "provider_items" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "provider_id" TEXT NOT NULL,
    "item_id" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "uid" TEXT,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "config" TEXT,
    "tier" TEXT,
    "order" INTEGER NOT NULL DEFAULT 0,
    "group_name" TEXT NOT NULL DEFAULT '',
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME,
    CONSTRAINT "provider_items_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "providers" ("provider_id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "subscription_plans" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "plan_type" TEXT NOT NULL,
    "interval" TEXT,
    "lookup_key" TEXT NOT NULL,
    "t1_count_quota" INTEGER NOT NULL DEFAULT 0,
    "t2_count_quota" INTEGER NOT NULL DEFAULT 0,
    "t1_token_quota" INTEGER NOT NULL DEFAULT 0,
    "t2_token_quota" INTEGER NOT NULL DEFAULT 1000000,
    "file_count_quota" INTEGER NOT NULL DEFAULT 10,
    "object_storage_quota" BIGINT NOT NULL DEFAULT 1000000000,
    "vector_storage_quota" BIGINT NOT NULL DEFAULT 1000000000,
    "file_parse_page_limit" INTEGER NOT NULL DEFAULT -1,
    "file_upload_limit" INTEGER NOT NULL DEFAULT -1,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "subscriptions" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "subscription_id" TEXT NOT NULL,
    "lookup_key" TEXT NOT NULL,
    "plan_type" TEXT NOT NULL,
    "interval" TEXT,
    "uid" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "is_trial" BOOLEAN NOT NULL DEFAULT false,
    "override_plan" TEXT,
    "cancel_at" DATETIME,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "token_usage_meters" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "meter_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "subscription_id" TEXT,
    "start_at" DATETIME NOT NULL,
    "end_at" DATETIME,
    "t1_count_quota" INTEGER NOT NULL DEFAULT 0,
    "t1_count_used" INTEGER NOT NULL DEFAULT 0,
    "t1_token_quota" INTEGER NOT NULL DEFAULT 0,
    "t1_token_used" INTEGER NOT NULL DEFAULT 0,
    "t2_count_quota" INTEGER NOT NULL DEFAULT 0,
    "t2_count_used" INTEGER NOT NULL DEFAULT 0,
    "t2_token_quota" INTEGER NOT NULL DEFAULT 0,
    "t2_token_used" INTEGER NOT NULL DEFAULT 0,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "storage_usage_meters" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "meter_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "subscription_id" TEXT,
    "file_count_quota" INTEGER NOT NULL DEFAULT 10,
    "file_count_used" INTEGER NOT NULL DEFAULT 0,
    "object_storage_quota" BIGINT NOT NULL DEFAULT 0,
    "resource_size" BIGINT NOT NULL DEFAULT 0,
    "canvas_size" BIGINT NOT NULL DEFAULT 0,
    "document_size" BIGINT NOT NULL DEFAULT 0,
    "file_size" BIGINT NOT NULL DEFAULT 0,
    "vector_storage_quota" BIGINT NOT NULL DEFAULT 0,
    "vector_storage_used" BIGINT NOT NULL DEFAULT 0,
    "synced_at" DATETIME,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "model_infos" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "context_limit" INTEGER NOT NULL DEFAULT 0,
    "max_output" INTEGER NOT NULL DEFAULT 0,
    "capabilities" TEXT NOT NULL DEFAULT '{}',
    "tier" TEXT NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "checkout_sessions" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "session_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "lookup_key" TEXT NOT NULL,
    "payment_status" TEXT,
    "subscription_id" TEXT,
    "invoice_id" TEXT,
    "customer_id" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "jti" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "hashed_token" TEXT NOT NULL,
    "revoked" BOOLEAN NOT NULL DEFAULT false,
    "expires_at" DATETIME NOT NULL,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "pages" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "page_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "canvas_id" TEXT NOT NULL,
    "title" TEXT NOT NULL DEFAULT 'Untitled Page',
    "description" TEXT,
    "state_storage_key" TEXT NOT NULL,
    "cover_storage_key" TEXT,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "page_node_relations" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "relation_id" TEXT NOT NULL,
    "page_id" TEXT NOT NULL,
    "node_id" TEXT NOT NULL,
    "node_type" TEXT NOT NULL,
    "entity_id" TEXT NOT NULL,
    "order_index" INTEGER NOT NULL,
    "node_data" TEXT NOT NULL DEFAULT '{}',
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "page_versions" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "version_id" TEXT NOT NULL,
    "page_id" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "content_storage_key" TEXT NOT NULL,
    "cover_storage_key" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "page_versions_page_id_fkey" FOREIGN KEY ("page_id") REFERENCES "pages" ("page_id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "mcp_servers" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "is_global" BOOLEAN NOT NULL DEFAULT false,
    "uid" TEXT,
    "url" TEXT,
    "command" TEXT,
    "args" TEXT,
    "env" TEXT,
    "headers" TEXT,
    "reconnect" TEXT,
    "config" TEXT,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" DATETIME
);

-- CreateTable
CREATE TABLE "credit_usages" (
    "pk" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "usage_id" TEXT NOT NULL,
    "uid" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "provider_item_id" TEXT,
    "model_name" TEXT,
    "usage_type" TEXT NOT NULL DEFAULT 'model_call',
    "action_result_id" TEXT,
    "pilot_session_id" TEXT,
    "description" TEXT,
    "model_usage_details" TEXT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateIndex
CREATE UNIQUE INDEX "accounts_provider_provider_account_id_key" ON "accounts"("provider", "provider_account_id");

-- CreateIndex
CREATE UNIQUE INDEX "verification_sessions_session_id_key" ON "verification_sessions"("session_id");

-- CreateIndex
CREATE INDEX "verification_sessions_email_code_idx" ON "verification_sessions"("email", "code");

-- CreateIndex
CREATE UNIQUE INDEX "users_uid_key" ON "users"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "users_name_key" ON "users"("name");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "action_results_target_type_target_id_idx" ON "action_results"("target_type", "target_id");

-- CreateIndex
CREATE INDEX "action_results_status_updated_at_idx" ON "action_results"("status", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "action_results_result_id_version_key" ON "action_results"("result_id", "version");

-- CreateIndex
CREATE INDEX "action_steps_result_id_version_order_idx" ON "action_steps"("result_id", "version", "order");

-- CreateIndex
CREATE INDEX "token_usages_uid_created_at_idx" ON "token_usages"("uid", "created_at");

-- CreateIndex
CREATE INDEX "static_files_entity_id_entity_type_idx" ON "static_files"("entity_id", "entity_type");

-- CreateIndex
CREATE INDEX "static_files_storage_key_idx" ON "static_files"("storage_key");

-- CreateIndex
CREATE UNIQUE INDEX "canvases_canvas_id_key" ON "canvases"("canvas_id");

-- CreateIndex
CREATE INDEX "canvases_uid_updated_at_idx" ON "canvases"("uid", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "canvas_templates_template_id_key" ON "canvas_templates"("template_id");

-- CreateIndex
CREATE INDEX "canvas_templates_uid_updated_at_idx" ON "canvas_templates"("uid", "updated_at");

-- CreateIndex
CREATE INDEX "canvas_templates_is_public_priority_idx" ON "canvas_templates"("is_public", "priority");

-- CreateIndex
CREATE UNIQUE INDEX "canvas_template_categories_category_id_key" ON "canvas_template_categories"("category_id");

-- CreateIndex
CREATE INDEX "canvas_entity_relations_canvas_id_deleted_at_idx" ON "canvas_entity_relations"("canvas_id", "deleted_at");

-- CreateIndex
CREATE INDEX "canvas_entity_relations_entity_type_entity_id_deleted_at_idx" ON "canvas_entity_relations"("entity_type", "entity_id", "deleted_at");

-- CreateIndex
CREATE INDEX "file_parse_records_uid_created_at_idx" ON "file_parse_records"("uid", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "resources_resource_id_key" ON "resources"("resource_id");

-- CreateIndex
CREATE INDEX "resources_uid_identifier_deleted_at_updated_at_idx" ON "resources"("uid", "identifier", "deleted_at", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "documents_doc_id_key" ON "documents"("doc_id");

-- CreateIndex
CREATE INDEX "documents_uid_deleted_at_updated_at_idx" ON "documents"("uid", "deleted_at", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "code_artifacts_artifact_id_key" ON "code_artifacts"("artifact_id");

-- CreateIndex
CREATE UNIQUE INDEX "projects_project_id_key" ON "projects"("project_id");

-- CreateIndex
CREATE INDEX "projects_uid_deleted_at_updated_at_idx" ON "projects"("uid", "deleted_at", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "share_records_share_id_key" ON "share_records"("share_id");

-- CreateIndex
CREATE INDEX "share_records_entity_type_entity_id_deleted_at_idx" ON "share_records"("entity_type", "entity_id", "deleted_at");

-- CreateIndex
CREATE INDEX "duplicate_records_target_id_idx" ON "duplicate_records"("target_id");

-- CreateIndex
CREATE INDEX "duplicate_records_share_id_idx" ON "duplicate_records"("share_id");

-- CreateIndex
CREATE UNIQUE INDEX "duplicate_records_source_id_target_id_key" ON "duplicate_records"("source_id", "target_id");

-- CreateIndex
CREATE UNIQUE INDEX "references_reference_id_key" ON "references"("reference_id");

-- CreateIndex
CREATE INDEX "references_source_type_source_id_idx" ON "references"("source_type", "source_id");

-- CreateIndex
CREATE INDEX "references_target_type_target_id_idx" ON "references"("target_type", "target_id");

-- CreateIndex
CREATE UNIQUE INDEX "references_source_type_source_id_target_type_target_id_key" ON "references"("source_type", "source_id", "target_type", "target_id");

-- CreateIndex
CREATE UNIQUE INDEX "skill_instances_skill_id_key" ON "skill_instances"("skill_id");

-- CreateIndex
CREATE INDEX "skill_instances_uid_updated_at_idx" ON "skill_instances"("uid", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "skill_triggers_trigger_id_key" ON "skill_triggers"("trigger_id");

-- CreateIndex
CREATE INDEX "skill_triggers_skill_id_deleted_at_idx" ON "skill_triggers"("skill_id", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "label_classes_label_class_id_key" ON "label_classes"("label_class_id");

-- CreateIndex
CREATE INDEX "label_classes_uid_deleted_at_updated_at_idx" ON "label_classes"("uid", "deleted_at", "updated_at");

-- CreateIndex
CREATE UNIQUE INDEX "label_classes_uid_name_key" ON "label_classes"("uid", "name");

-- CreateIndex
CREATE UNIQUE INDEX "label_instances_label_id_key" ON "label_instances"("label_id");

-- CreateIndex
CREATE INDEX "label_instances_entity_type_entity_id_idx" ON "label_instances"("entity_type", "entity_id");

-- CreateIndex
CREATE UNIQUE INDEX "providers_provider_id_key" ON "providers"("provider_id");

-- CreateIndex
CREATE INDEX "providers_uid_deleted_at_idx" ON "providers"("uid", "deleted_at");

-- CreateIndex
CREATE INDEX "providers_is_global_idx" ON "providers"("is_global");

-- CreateIndex
CREATE UNIQUE INDEX "provider_items_item_id_key" ON "provider_items"("item_id");

-- CreateIndex
CREATE INDEX "provider_items_provider_id_idx" ON "provider_items"("provider_id");

-- CreateIndex
CREATE INDEX "provider_items_uid_deleted_at_idx" ON "provider_items"("uid", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "subscription_plans_plan_type_interval_key" ON "subscription_plans"("plan_type", "interval");

-- CreateIndex
CREATE UNIQUE INDEX "subscriptions_subscription_id_key" ON "subscriptions"("subscription_id");

-- CreateIndex
CREATE INDEX "subscriptions_uid_idx" ON "subscriptions"("uid");

-- CreateIndex
CREATE INDEX "subscriptions_status_cancel_at_idx" ON "subscriptions"("status", "cancel_at");

-- CreateIndex
CREATE UNIQUE INDEX "token_usage_meters_meter_id_key" ON "token_usage_meters"("meter_id");

-- CreateIndex
CREATE INDEX "token_usage_meters_uid_deleted_at_idx" ON "token_usage_meters"("uid", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "storage_usage_meters_meter_id_key" ON "storage_usage_meters"("meter_id");

-- CreateIndex
CREATE INDEX "storage_usage_meters_uid_deleted_at_idx" ON "storage_usage_meters"("uid", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "model_infos_name_key" ON "model_infos"("name");

-- CreateIndex
CREATE INDEX "checkout_sessions_session_id_idx" ON "checkout_sessions"("session_id");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_jti_key" ON "refresh_tokens"("jti");

-- CreateIndex
CREATE INDEX "refresh_tokens_uid_idx" ON "refresh_tokens"("uid");

-- CreateIndex
CREATE UNIQUE INDEX "pages_page_id_key" ON "pages"("page_id");

-- CreateIndex
CREATE INDEX "pages_uid_updated_at_idx" ON "pages"("uid", "updated_at");

-- CreateIndex
CREATE INDEX "pages_canvas_id_deleted_at_idx" ON "pages"("canvas_id", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "page_node_relations_relation_id_key" ON "page_node_relations"("relation_id");

-- CreateIndex
CREATE INDEX "page_node_relations_page_id_deleted_at_idx" ON "page_node_relations"("page_id", "deleted_at");

-- CreateIndex
CREATE UNIQUE INDEX "page_versions_version_id_key" ON "page_versions"("version_id");

-- CreateIndex
CREATE INDEX "page_versions_page_id_version_idx" ON "page_versions"("page_id", "version");

-- CreateIndex
CREATE INDEX "mcp_servers_uid_deleted_at_idx" ON "mcp_servers"("uid", "deleted_at");

-- CreateIndex
CREATE INDEX "mcp_servers_is_global_idx" ON "mcp_servers"("is_global");

-- CreateIndex
CREATE UNIQUE INDEX "mcp_servers_uid_name_key" ON "mcp_servers"("uid", "name");

-- CreateIndex
CREATE UNIQUE INDEX "credit_usages_usage_id_key" ON "credit_usages"("usage_id");

-- CreateIndex
CREATE INDEX "credit_usages_uid_created_at_idx" ON "credit_usages"("uid", "created_at");

-- CreateIndex
CREATE INDEX "credit_usages_provider_item_id_created_at_idx" ON "credit_usages"("provider_item_id", "created_at");

-- CreateIndex
CREATE INDEX "credit_usages_action_result_id_idx" ON "credit_usages"("action_result_id");

-- CreateIndex
CREATE INDEX "credit_usages_pilot_session_id_idx" ON "credit_usages"("pilot_session_id");
