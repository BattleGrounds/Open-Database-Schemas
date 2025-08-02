CREATE OR REPLACE TABLE `version` (
    `version_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `name` VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    FULLTEXT INDEX `ft_description` (`description`),
    INDEX `idx_name` (`name`),
    INDEX `idx_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `users` (
    `user_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор пользователя',
    `username` VARCHAR(64) NOT NULL COMMENT 'Имя пользователя',
    `email` VARCHAR(128) NOT NULL UNIQUE COMMENT 'Электронная почта',
    `password_hash` VARCHAR(60) NOT NULL COMMENT 'Хэш пароля',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата регистрации',
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления',
    `is_deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Удалён логически',
    KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci COMMENT='Пользователи';

CREATE OR REPLACE TABLE `permissions` (
    `permission_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) NOT NULL,
    INDEX (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `user_permissions` (
    `user_id` SMALLINT  NOT NULL,
    `permission_id` SMALLINT  NOT NULL,
    PRIMARY KEY (`user_id`, `permission_id`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`permission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `answer_type` (
    `type_id` TINYINT(3)  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор типа ответа',
    `name` VARCHAR(30) NOT NULL COMMENT 'Название типа ответа',
    INDEX (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `material_type` (
    `type_id` TINYINT(3)  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL,
    INDEX (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `skills` (
    `skill_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор навыка',
    `name` VARCHAR(50) NOT NULL COMMENT 'Название навыка',
    UNIQUE KEY `uq_skill_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `courses` (
    `course_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор курса',
    `title` VARCHAR(100) NOT NULL COMMENT 'Название курса',
    `description` VARCHAR(255) DEFAULT NULL COMMENT 'Описание курса',
    `start_date` TIMESTAMP NOT NULL COMMENT 'Дата начала',
    `end_date` TIMESTAMP NOT NULL COMMENT 'Дата окончания',
    `teacher_id` SMALLINT  DEFAULT NULL COMMENT 'Преподаватель',
    `version_id` SMALLINT  DEFAULT NULL,
    `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
    KEY `idx_teacher_id` (`teacher_id`),
    FOREIGN KEY (`teacher_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
    FOREIGN KEY (`version_id`) REFERENCES `version` (`version_id`) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `chk_course_dates` CHECK (`end_date` > `start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `tasks` (
    `task_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор задачи',
    `course_id` SMALLINT  NOT NULL COMMENT 'Идентификатор курса',
    `title` VARCHAR(100) NOT NULL COMMENT 'Название задачи',
    `description` VARCHAR(255) NOT NULL COMMENT 'Описание задачи',
    `deadline` TIMESTAMP NOT NULL COMMENT 'Крайний срок',
    `start_date` TIMESTAMP NOT NULL COMMENT 'Дата открытия',
    `version_id` SMALLINT  DEFAULT NULL,
    FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
    FOREIGN KEY (`version_id`) REFERENCES `version` (`version_id`) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `chk_task_dates` CHECK (`deadline` > `start_date`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `quizzes` (
    `quiz_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор квиза',
    `task_id` SMALLINT  NOT NULL UNIQUE COMMENT 'Идентификатор задачи',
    `title` VARCHAR(100) NOT NULL COMMENT 'Название квиза',
    `description` VARCHAR(255) NOT NULL COMMENT 'Описание квиза',
    `time_limit` SMALLINT  DEFAULT NULL COMMENT 'Лимит времени (минуты)',
    `version_id` SMALLINT  DEFAULT NULL,
    FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`) ON DELETE CASCADE,
    FOREIGN KEY (`version_id`) REFERENCES `version` (`version_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `materials` (
    `material_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор материала',
    `course_id` SMALLINT  DEFAULT NULL COMMENT 'Курс',
    `title` VARCHAR(100) NOT NULL COMMENT 'Название',
    `content` TEXT DEFAULT NULL COMMENT 'Содержимое',
    `type_id` TINYINT(3)  NOT NULL COMMENT 'Тип материала',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
    `version_id` SMALLINT  DEFAULT NULL,
    FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`),
    FOREIGN KEY (`type_id`) REFERENCES `material_type` (`type_id`),
    FOREIGN KEY (`version_id`) REFERENCES `version` (`version_id`) ON DELETE SET NULL ON UPDATE CASCADE,
    FULLTEXT KEY `ft_content` (`content`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci ROW_FORMAT=COMPRESSED;

CREATE OR REPLACE TABLE `questions` (
    `question_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор вопроса',
    `title` VARCHAR(100) NOT NULL COMMENT 'Краткое название',
    `question` VARCHAR(255) NOT NULL COMMENT 'Формулировка вопроса'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `answers` (
    `answer_id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор ответа',
    `answer` VARCHAR(255) NOT NULL COMMENT 'Ответ',
    `type_id` TINYINT(3)  NOT NULL COMMENT 'Тип ответа',
    FOREIGN KEY (`type_id`) REFERENCES `answer_type` (`type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci ROW_FORMAT=COMPRESSED;

CREATE OR REPLACE TABLE `questions_answers` (
    `id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `question_id` SMALLINT  NOT NULL,
    `answer_id` SMALLINT  NOT NULL,
    `valid` TINYINT(1) DEFAULT 0 COMMENT 'Правильный ответ',
    UNIQUE KEY (`question_id`, `answer_id`),
    FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE,
    FOREIGN KEY (`answer_id`) REFERENCES `answers` (`answer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `quiz_questions` (
    `quiz_id` SMALLINT  NOT NULL,
    `question_id` SMALLINT  NOT NULL,
    `question_order` SMALLINT  DEFAULT 0,
    PRIMARY KEY (`quiz_id`, `question_id`),
    FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`quiz_id`) ON DELETE CASCADE,
    FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `student_quiz` (
    `id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `student_id` SMALLINT  NOT NULL,
    `quiz_id` SMALLINT  NOT NULL,
    UNIQUE KEY (`student_id`, `quiz_id`),
    FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`quiz_id`) REFERENCES `quizzes` (`quiz_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `student_selected_answers` (
    `student_quiz_id` SMALLINT  NOT NULL,
    `question_answer_id` SMALLINT  NOT NULL,
    PRIMARY KEY (`student_quiz_id`, `question_answer_id`),
    FOREIGN KEY (`student_quiz_id`) REFERENCES `student_quiz` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`question_answer_id`) REFERENCES `questions_answers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `student_answer_texts` (
    `id` SMALLINT  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `student_id` SMALLINT  NOT NULL,
    `question_id` SMALLINT  NOT NULL,
    `answer_text` VARCHAR(255) DEFAULT NULL,
    `answered_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci ROW_FORMAT=COMPRESSED;

CREATE OR REPLACE TABLE `student_answer_sessions` (
    `student_id` SMALLINT  NOT NULL,
    `quiz_id` SMALLINT  NOT NULL,
    `question_id` SMALLINT  NOT NULL,
    `answer_text_id` SMALLINT  NOT NULL,
    PRIMARY KEY (`student_id`, `quiz_id`, `question_id`),
    FOREIGN KEY (`student_id`, `quiz_id`) REFERENCES `student_quiz` (`student_id`, `quiz_id`) ON DELETE CASCADE,
    FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE,
    FOREIGN KEY (`answer_text_id`) REFERENCES `student_answer_texts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `grades` (
    `student_id` SMALLINT  NOT NULL COMMENT 'Идентификатор студента',
    `task_id` SMALLINT  NOT NULL COMMENT 'Идентификатор задачи',
    `grade` TINYINT(4) NOT NULL COMMENT 'Оценка',
    `signed_at` TIMESTAMP NOT NULL COMMENT 'Дата выставления оценки',
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления',
    PRIMARY KEY (`student_id`, `task_id`),
    FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`),
    FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`),
    CONSTRAINT `chk_grade` CHECK (`grade` >= 2 AND `grade` <= 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `studentskills` (
    `student_id` SMALLINT  NOT NULL COMMENT 'Идентификатор студента',
    `skill_id` SMALLINT  NOT NULL COMMENT 'Идентификатор навыка',
    PRIMARY KEY (`student_id`, `skill_id`),
    FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
    FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `course_outcomes` (
    `course_id` SMALLINT  NOT NULL,
    `skill_id` SMALLINT  NOT NULL,
    PRIMARY KEY (`course_id`, `skill_id`),
    FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
    FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE OR REPLACE TABLE `course_prerequisites` (
    `course_id` SMALLINT  NOT NULL,
    `skill_id` SMALLINT  NOT NULL,
    PRIMARY KEY (`course_id`, `skill_id`),
    FOREIGN KEY (`course_id`) REFERENCES `courses` (`course_id`) ON DELETE CASCADE,
    FOREIGN KEY (`skill_id`) REFERENCES `skills` (`skill_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

CREATE TABLE learning_styles (
    style_code VARCHAR(20) PRIMARY KEY COMMENT 'Код стиля обучения: theory, practice, mixed',
    description VARCHAR(100) COMMENT 'Описание стиля обучения'
) ENGINE=InnoDB COMMENT='Справочник стилей обучения';

CREATE TABLE content_types (
    type_code VARCHAR(20) PRIMARY KEY COMMENT 'Код типа контента: video, text, quiz и т.д.',
    description VARCHAR(100) COMMENT 'Описание типа контента'
) ENGINE=InnoDB COMMENT='Справочник типов учебного контента';

CREATE TABLE student_profile (
    student_id SMALLINT PRIMARY KEY COMMENT 'ID пользователя (студента)',
    career_goal VARCHAR(100) COMMENT 'Цель обучения или карьеры',
    english_level TINYINT COMMENT 'Уровень английского (1-5)',
    preferred_content_type VARCHAR(20) COMMENT 'Предпочтительный тип контента',
    daily_commitment_minutes INT COMMENT 'Готовность уделять времени в день',
    learning_style VARCHAR(20) COMMENT 'Стиль обучения',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания профиля',
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (learning_style) REFERENCES learning_styles(style_code),
    FOREIGN KEY (preferred_content_type) REFERENCES content_types(type_code)
) ENGINE=InnoDB COMMENT='Профиль студента для персонализации обучения';

CREATE TABLE content_unit (
    unit_id SMALLINT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID юнита',
    title VARCHAR(100) NOT NULL COMMENT 'Заголовок юнита',
    skill_id SMALLINT NOT NULL COMMENT 'Навык, к которому относится юнит',
    duration_minutes SMALLINT DEFAULT 5 COMMENT 'Длительность (мин)',
    difficulty_level TINYINT DEFAULT 3 COMMENT 'Сложность от 1 до 5',
    content TEXT COMMENT 'Учебный материал',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата создания',
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
) ENGINE=InnoDB COMMENT='Атомарные юниты учебного контента';

CREATE TABLE unit_dependencies (
    unit_id SMALLINT NOT NULL COMMENT 'Юнит, который зависит от другого',
    depends_on_unit_id SMALLINT NOT NULL COMMENT 'Предшествующий юнит',
    PRIMARY KEY (unit_id, depends_on_unit_id),
    FOREIGN KEY (unit_id) REFERENCES content_unit(unit_id),
    FOREIGN KEY (depends_on_unit_id) REFERENCES content_unit(unit_id)
) ENGINE=InnoDB COMMENT='Зависимости между юнитами контента';

CREATE TABLE translation_dictionary (
    term_key VARCHAR(100) PRIMARY KEY COMMENT 'Ключ термина',
    domain VARCHAR(50) COMMENT 'Предметная область',
    base_language VARCHAR(5) COMMENT 'Исходный язык',
    target_language VARCHAR(5) COMMENT 'Язык перевода',
    base_text TEXT NOT NULL COMMENT 'Исходный текст',
    translated_text TEXT NOT NULL COMMENT 'Переведённый текст',
    usage_notes TEXT COMMENT 'Примечания по использованию',
    tone VARCHAR(30) DEFAULT 'neutral' COMMENT 'Стиль: formal, casual, academic',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата обновления'
) ENGINE=InnoDB COMMENT='Словарь переводов по ключевым терминам';

CREATE TABLE translation_synsets (
    synset_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID синонимической группы',
    domain VARCHAR(50) COMMENT 'Предметная область',
    description TEXT COMMENT 'Описание группы'
) ENGINE=InnoDB COMMENT='Синонимические группы для перевода';

CREATE TABLE translation_synset_terms (
    synset_id INT COMMENT 'ID синоним-группы',
    term_key VARCHAR(100) COMMENT 'Ключ термина',
    role VARCHAR(50) COMMENT 'Роль термина: base, variant, technical',
    PRIMARY KEY (synset_id, term_key),
    FOREIGN KEY (synset_id) REFERENCES translation_synsets(synset_id),
    FOREIGN KEY (term_key) REFERENCES translation_dictionary(term_key)
) ENGINE=InnoDB COMMENT='Привязка терминов к синонимическим группам';

CREATE TABLE student_translation_context (
    student_id SMALLINT PRIMARY KEY COMMENT 'ID студента',
    domain_preference VARCHAR(50) COMMENT 'Предпочтительная область знаний',
    reading_level TINYINT COMMENT 'Уровень восприятия (1-5)',
    preferred_language VARCHAR(5) COMMENT 'Желаемый язык перевода',
    preferred_tone VARCHAR(30) COMMENT 'Стиль перевода',
    FOREIGN KEY (student_id) REFERENCES users(user_id)
) ENGINE=InnoDB COMMENT='Языковой и понятийный контекст перевода для студента';

CREATE TABLE student_activity_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID действия',
    student_id SMALLINT NOT NULL COMMENT 'ID студента',
    action_type VARCHAR(50) NOT NULL COMMENT 'Тип действия',
    object_type VARCHAR(50) NOT NULL COMMENT 'Тип объекта (quiz, material...)',
    object_id SMALLINT COMMENT 'ID объекта',
    occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Время действия',
    FOREIGN KEY (student_id) REFERENCES users(user_id)
) ENGINE=InnoDB COMMENT='Журнал активности студента';

CREATE TABLE student_activity_metadata (
    log_id BIGINT NOT NULL COMMENT 'ID действия',
    meta_key VARCHAR(50) NOT NULL COMMENT 'Ключ параметра',
    meta_value TEXT COMMENT 'Значение параметра',
    PRIMARY KEY (log_id, meta_key),
    FOREIGN KEY (log_id) REFERENCES student_activity_log(id)
) ENGINE=InnoDB COMMENT='Детализация действия студента по параметрам';

CREATE TABLE grades_audit (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID аудита',
    student_id SMALLINT NOT NULL COMMENT 'Студент',
    task_id SMALLINT NOT NULL COMMENT 'Задание',
    grade_old TINYINT COMMENT 'Старый балл',
    grade_new TINYINT COMMENT 'Новый балл',
    changed_by SMALLINT NOT NULL COMMENT 'Кто изменил',
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Когда',
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (task_id) REFERENCES tasks(task_id),
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
) ENGINE=InnoDB COMMENT='История изменений оценок';

CREATE TABLE student_feature_facts (
    student_id SMALLINT NOT NULL COMMENT 'Студент',
    feature_name VARCHAR(64) NOT NULL COMMENT 'Имя признака',
    feature_value VARCHAR(255) COMMENT 'Значение признака',
    captured_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Момент фиксации',
    PRIMARY KEY (student_id, feature_name, captured_at),
    FOREIGN KEY (student_id) REFERENCES users(user_id)
) ENGINE=ColumnStore COMMENT='Хранилище признаков студента для аналитики';

CREATE TABLE feature_definitions (
    feature_name VARCHAR(64) PRIMARY KEY COMMENT 'Имя признака',
    description TEXT COMMENT 'Описание',
    sql_expression TEXT COMMENT 'Формула расчёта',
    owner VARCHAR(64) COMMENT 'Создатель',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Создан'
) ENGINE=InnoDB COMMENT='Метаданные признаков аналитики';

CREATE TABLE student_learning_plan (
    student_id SMALLINT NOT NULL COMMENT 'Студент',
    unit_id SMALLINT NOT NULL COMMENT 'Контент-юнит',
    skill_id SMALLINT NOT NULL COMMENT 'Навык',
    plan_weight TINYINT DEFAULT 1 COMMENT 'Приоритет выполнения',
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата включения в план',
    PRIMARY KEY (student_id, unit_id),
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (unit_id) REFERENCES content_unit(unit_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
) ENGINE=InnoDB COMMENT='План обучения студента с приоритетами';

CREATE TABLE badge_achievements (
    achievement_id SMALLINT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID достижения',
    student_id SMALLINT NOT NULL COMMENT 'Получивший студент',
    badge_code VARCHAR(50) NOT NULL COMMENT 'Код значка',
    awarded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата вручения',
    FOREIGN KEY (student_id) REFERENCES users(user_id)
) ENGINE=InnoDB COMMENT='Система наград и достижений';