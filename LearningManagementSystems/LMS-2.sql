CREATE TABLE Departments (
    department_id TINYINT UNSIGNED PRIMARY KEY NOT NULL COMMENT 'Идентификатор кафедры. Здесь есть логическая проблема в самом документе "Учебный план", так как в нём есть код кафедр, который нужен для формирования документов',
    `name` VARCHAR(100) NOT NULL COMMENT 'Название кафедры',
    acronym VARCHAR(10) NULL COMMENT 'Аббревиатура названия кафедры',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата добавления записи',

    INDEX (`name`),
    INDEX (acronym),
    CONSTRAINT department_id_chk CHECK ( department_id > 0 AND department_id < 38 )
) ENGINE=InnoDB COMMENT='Справочник кафедр';

CREATE TABLE AccessLevels(
    level_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'Идентификатор уровня доступа',
    `name` VARCHAR(50) NOT NULL COMMENT 'Название уровня',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление уровня доступа',

    INDEX (`name`)
)ENGINE=InnoDB COMMENT='Уровни доступа в системе для роли';

CREATE TABLE UserRoles (
    role_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'Идентификатор роли пользователя в системе',
    `name` VARCHAR(15) NOT NULL,
    access_level TINYINT UNSIGNED NOT NULL,
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление роли',

    FOREIGN KEY (access_level) REFERENCES AccessLevels(level_id) ON DELETE CASCADE,
    INDEX(`name`)
)ENGINE=InnoDB COMMENT='Роль пользователя в системе';

CREATE TABLE Users (
    user_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'Идентификатор пользователя',
    nick_name VARCHAR(30) NOT NULL UNIQUE COMMENT 'Уникальный идентификатор для системы авторизации',
    first_name VARCHAR(30) NOT NULL COMMENT 'Имя пользователя',
    last_name VARCHAR(40) NOT NULL COMMENT 'Фамилия пользователя',
    middle_name VARCHAR(40) NOT NULL COMMENT 'Отчество пользователя',
    role_id TINYINT UNSIGNED NOT NULL COMMENT 'Идентификатор роли',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата добавления записи',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата обновления записи',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление пользователя',

    FOREIGN KEY (role_id) REFERENCES UserRoles(role_id) ON DELETE CASCADE,
    INDEX (nick_name),
    INDEX(first_name),
    INDEX(last_name),
    INDEX(middle_name)
);

CREATE TABLE StudyLevels (
    level_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'Идентификатор уровня образования',
    `name` VARCHAR(50) NOT NULL UNIQUE COMMENT 'Уровень образования по ГОСТ',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление уровня образования',

    INDEX (`name`)
)ENGINE=InnoDB COMMENT='Уровень образования';

CREATE TABLE StudySpecializations (
    specialization_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL  COMMENT 'Идентификатор специальности',
    specialization_name VARCHAR(100) NOT NULL COMMENT 'Специальность по ГОСТ',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление специальности',

    INDEX(specialization_name)
)ENGINE=InnoDB COMMENT='Специализация образования';

CREATE TABLE StudyProfiles (
    profile_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'Идентификатор профиля образования',
    profile_name VARCHAR(100) NOT NULL COMMENT 'Профиль образования по ГОСТ',
    specialization_id SMALLINT UNSIGNED NOT NULL COMMENT 'Идентификатор специальности',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление профиля образования',

    FOREIGN KEY (specialization_id) REFERENCES StudySpecializations(specialization_id) ON DELETE CASCADE,
    INDEX(profile_name)
)ENGINE=InnoDB COMMENT='Профиль образования';

CREATE TABLE `Groups` (
    group_id SMALLINT UNSIGNED PRIMARY KEY NOT NULL COMMENT 'Идентификатор группы',
    `year` YEAR NOT NULL COMMENT 'Год набора',
    acronym VARCHAR(8) NOT NULL COMMENT 'Аббревиатура названия таблицы',
    level_id TINYINT UNSIGNED NOT NULL COMMENT 'Идентификатор уровня образования',
    profile_id SMALLINT UNSIGNED NOT NULL COMMENT 'Идентификатор профиля образования',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление группы',

    FOREIGN KEY (level_id) REFERENCES StudyLevels(level_id) ON DELETE CASCADE,
    FOREIGN KEY (profile_id) REFERENCES StudyProfiles(profile_id) ON DELETE CASCADE,
    INDEX(acronym),
    INDEX(`year`)
)ENGINE=InnoDB COMMENT='Справочник групп';

CREATE TABLE Disciplines (
    discipline_id SMALLINT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'Идентификатор дисциплины',
    department_id TINYINT UNSIGNED NOT NULL COMMENT 'Идентификатор кафедры',
    `name` VARCHAR(200) NOT NULL COMMENT 'Название дисциплины',
    acronym VARCHAR(10) NULL COMMENT 'Аббревиатура названия дисциплины',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата добавления записи',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление дисциплины',

    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE,
    INDEX(`name`),
    INDEX(acronym),
    INDEX(department_id)
) ENGINE=InnoDB COMMENT='Дисциплина';

CREATE TABLE TeachingLoadTypes (
    type_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL COMMENT 'Идентификатор типа нагрузки',
    `name` VARCHAR(100) NOT NULL COMMENT 'Название типа нагрузки',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление типа нагрузки',

    INDEX (`name`)
)ENGINE=InnoDB COMMENT='Типы учебных нагрузок';

CREATE TABLE Semesters (
    semester_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
    total_hours INT UNSIGNED NOT NULL COMMENT 'Общее количество часов',
    start_date DATETIME NOT NULL COMMENT 'Дата начала семестра',
    end_date DATETIME NOT NULL COMMENT 'Дата окончания семестра',

    INDEX(start_date, end_date),
    CONSTRAINT period_chk CHECK (start_date < end_date)
)ENGINE=InnoDB COMMENT='Справочник семестров';

CREATE TABLE TeachingAssignments (
    assignment_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Идентификатор назначения преподавателя',
    teacher_id INT UNSIGNED NOT NULL COMMENT 'Преподаватель',
    group_id SMALLINT UNSIGNED NOT NULL COMMENT 'Группа',
    discipline_id SMALLINT UNSIGNED NOT NULL COMMENT 'Дисциплина',
    semester_id TINYINT UNSIGNED NOT NULL COMMENT 'Семестр',
    is_deleted BOOL NOT NULL DEFAULT FALSE,

    FOREIGN KEY (teacher_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES `Groups`(group_id) ON DELETE CASCADE,
    FOREIGN KEY (discipline_id) REFERENCES Disciplines(discipline_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id) ON DELETE CASCADE,

    UNIQUE(teacher_id, group_id, discipline_id, semester_id),
    INDEX(teacher_id),
    INDEX(group_id),
    INDEX(discipline_id),
    INDEX(semester_id)
) ENGINE=InnoDB COMMENT='Назначение преподавателя на дисциплину';

CREATE TABLE TeachingAssignmentLoads (
    load_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT UNSIGNED NOT NULL,
    load_type_id TINYINT UNSIGNED NOT NULL COMMENT 'Лекция, лаба, консультация и т.п.',
    deadline DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    hours_planned DECIMAL(5,2) NOT NULL DEFAULT 0.0,
    hours_actual DECIMAL(5,2) DEFAULT NULL,
    is_deleted BOOL NOT NULL DEFAULT FALSE,

    FOREIGN KEY (assignment_id) REFERENCES TeachingAssignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (load_type_id) REFERENCES TeachingLoadTypes(type_id) ON DELETE CASCADE,

    INDEX(assignment_id),
    INDEX(load_type_id)
) ENGINE=InnoDB COMMENT='Типы нагрузки, назначенные преподавателю';

CREATE TABLE ScheduleDays (
    day_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Идентификатор дня недели',
    name VARCHAR(10) NOT NULL UNIQUE COMMENT 'Название дня (Понедельник и т.п.)',
    sort_order TINYINT UNSIGNED NOT NULL COMMENT 'Порядок в неделе (1 = Пн ... 7 = Вс)'
) ENGINE=InnoDB COMMENT='Справочник дней недели';

CREATE TABLE ScheduleTypes (
    type_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Идентификатор типа занятия',
    name VARCHAR(50) NOT NULL UNIQUE COMMENT 'Название типа занятия',
    short_name VARCHAR(10) NOT NULL COMMENT 'Сокращение (напр. лек, пр, лаб)',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление типа'
) ENGINE=InnoDB COMMENT='Типы учебных занятий';

CREATE TABLE WeekTypes (
    week_type_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE COMMENT 'Тип недели (все/верх/низ)',
    short_code VARCHAR(5) NOT NULL COMMENT 'Код типа (0 - все, 1 - верх, 2 - низ)'
) ENGINE=InnoDB COMMENT='Типы недель расписания';

CREATE TABLE ScheduleSlots (
    slot_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    slot_number TINYINT UNSIGNED NOT NULL UNIQUE COMMENT 'Номер пары (1, 2, 3...)',
    start_time TIME NOT NULL COMMENT 'Время начала пары',
    end_time TIME NOT NULL COMMENT 'Время окончания пары'
) ENGINE=InnoDB COMMENT='Справочник пар (слотов)';

CREATE TABLE Schedules (
    schedule_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT COMMENT 'Идентификатор записи в расписании',
    group_id SMALLINT UNSIGNED NOT NULL COMMENT 'Группа, к которой относится занятие',
    discipline_id SMALLINT UNSIGNED NOT NULL COMMENT 'Дисциплина занятия',
    teacher_id INT UNSIGNED NOT NULL COMMENT 'Преподаватель занятия',
    semester_id TINYINT UNSIGNED NOT NULL COMMENT 'Семестр, к которому относится занятие',
    day_id TINYINT UNSIGNED NOT NULL COMMENT 'День недели',
    slot_id TINYINT UNSIGNED NOT NULL COMMENT 'Пара',
    week_type_id TINYINT UNSIGNED NOT NULL COMMENT 'Тип недели (верх/низ)',
    schedule_type_id TINYINT UNSIGNED NOT NULL COMMENT 'Тип занятия (лекция и т.п.)',
    room VARCHAR(10) NULL COMMENT 'Номер аудитории',
    is_deleted BOOL NOT NULL DEFAULT FALSE COMMENT 'Мягкое удаление строки расписания',

    FOREIGN KEY (group_id) REFERENCES `Groups`(group_id) ON DELETE CASCADE,
    FOREIGN KEY (discipline_id) REFERENCES Disciplines(discipline_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id) ON DELETE CASCADE,
    FOREIGN KEY (day_id) REFERENCES ScheduleDays(day_id),
    FOREIGN KEY (slot_id) REFERENCES ScheduleSlots(slot_id),
    FOREIGN KEY (week_type_id) REFERENCES WeekTypes(week_type_id),
    FOREIGN KEY (schedule_type_id) REFERENCES ScheduleTypes(type_id),

    INDEX(group_id),
    INDEX(teacher_id),
    INDEX(semester_id),
    INDEX(discipline_id),
    INDEX(day_id),
    INDEX(slot_id),
    INDEX(week_type_id)
) ENGINE=InnoDB COMMENT='Расписание занятий';

CREATE TABLE ScheduleTopics (
    topic_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    schedule_id INT UNSIGNED NOT NULL COMMENT 'Запись в расписании',
    topic_date DATE NOT NULL COMMENT 'Дата конкретного занятия',
    topic_text VARCHAR(255) NOT NULL COMMENT 'Тема занятия',

    FOREIGN KEY (schedule_id) REFERENCES Schedules(schedule_id) ON DELETE CASCADE,
    INDEX(topic_date)
) ENGINE=InnoDB COMMENT='Темы занятий по расписанию';

CREATE TABLE Students (
    user_id INT UNSIGNED PRIMARY KEY COMMENT 'Пользователь, исполняющий роль студента',
    group_id SMALLINT UNSIGNED NOT NULL COMMENT 'Группа студента',
    student_code VARCHAR(15) UNIQUE NOT NULL COMMENT 'Номер зачетки или личное дело',
    admission_date DATE NOT NULL COMMENT 'Дата поступления',
    expulsion_date DATE NULL COMMENT 'Дата отчисления (если применимо)',
    is_expelled BOOL NOT NULL DEFAULT FALSE COMMENT 'Признак отчисления',

    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES `Groups`(group_id) ON DELETE RESTRICT,

    INDEX(student_code),
    INDEX(group_id)
) ENGINE=InnoDB COMMENT='Дополнительная информация о студентах';

CREATE TABLE ControlForms (
    form_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT 'Название формы контроля (экзамен, зачёт, ...)',
    abbreviation VARCHAR(10) NOT NULL COMMENT 'Сокращение',
    is_deleted BOOL NOT NULL DEFAULT FALSE
) ENGINE=InnoDB COMMENT='Формы контроля успеваемости';

CREATE TABLE MarkTypes (
    mark_type_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT 'Тип шкалы оценивания',
    description TEXT NULL,
    is_deleted BOOL NOT NULL DEFAULT FALSE
) ENGINE=InnoDB COMMENT='Системы оценивания';

CREATE TABLE MarkValues (
    mark_value_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    mark_type_id TINYINT UNSIGNED NOT NULL,
    value VARCHAR(20) NOT NULL COMMENT 'Текстовое значение оценки',
    numeric_value TINYINT UNSIGNED NULL COMMENT 'Числовой эквивалент (если применимо)',
    is_pass BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'Признак "зачтено"',

    FOREIGN KEY (mark_type_id) REFERENCES MarkTypes(mark_type_id) ON DELETE CASCADE,
    UNIQUE(mark_type_id, value)
) ENGINE=InnoDB COMMENT='Значения оценок';

CREATE TABLE GradeSheets (
    sheet_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    group_id SMALLINT UNSIGNED NOT NULL,
    discipline_id SMALLINT UNSIGNED NOT NULL,
    semester_id TINYINT UNSIGNED NOT NULL,
    form_id TINYINT UNSIGNED NOT NULL,
    mark_type_id TINYINT UNSIGNED NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOL NOT NULL DEFAULT FALSE,

    FOREIGN KEY (group_id) REFERENCES `Groups`(group_id),
    FOREIGN KEY (discipline_id) REFERENCES Disciplines(discipline_id),
    FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id),
    FOREIGN KEY (form_id) REFERENCES ControlForms(form_id),
    FOREIGN KEY (mark_type_id) REFERENCES MarkTypes(mark_type_id),

    INDEX(group_id),
    INDEX(discipline_id),
    INDEX(semester_id)
) ENGINE=InnoDB COMMENT='Ведомости успеваемости';


CREATE TABLE GradeAttempts (
    attempt_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    sheet_id INT UNSIGNED NOT NULL,
    student_id INT UNSIGNED NOT NULL COMMENT 'user_id студента',
    attempt_number TINYINT UNSIGNED NOT NULL DEFAULT 1,
    attempt_date DATE NOT NULL DEFAULT CURRENT_DATE,
    is_retake BOOL NOT NULL DEFAULT FALSE,
    is_final BOOL NOT NULL DEFAULT TRUE COMMENT 'Последняя актуальная оценка',

    FOREIGN KEY (sheet_id) REFERENCES GradeSheets(sheet_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Students(user_id) ON DELETE CASCADE,

    UNIQUE(sheet_id, student_id, attempt_number),
    INDEX(student_id),
    INDEX(sheet_id)
) ENGINE=InnoDB COMMENT='Попытки сдачи по ведомости';

CREATE TABLE GradeResults (
    result_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    attempt_id INT UNSIGNED NOT NULL,
    mark_value_id TINYINT UNSIGNED NOT NULL,

    FOREIGN KEY (attempt_id) REFERENCES GradeAttempts(attempt_id) ON DELETE CASCADE,
    FOREIGN KEY (mark_value_id) REFERENCES MarkValues(mark_value_id) ON DELETE RESTRICT,

    INDEX(mark_value_id)
) ENGINE=InnoDB COMMENT='Оценки за попытку сдачи';

CREATE TABLE FinalWorkTypes (
    type_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT 'Тип работы: Курсовая, ВКР, Практика',
    abbreviation VARCHAR(10),
    is_deleted BOOL NOT NULL DEFAULT FALSE
) ENGINE=InnoDB COMMENT='Типы итоговых/курсовых/выпускных работ';

CREATE TABLE FinalWorks (
    work_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    student_id INT UNSIGNED NOT NULL COMMENT 'user_id студента',
    discipline_id SMALLINT UNSIGNED NOT NULL,
    type_id TINYINT UNSIGNED NOT NULL COMMENT 'Тип работы',
    semester_id TINYINT UNSIGNED NOT NULL,
    topic TEXT NOT NULL COMMENT 'Тема работы',
    is_approved BOOL NOT NULL DEFAULT FALSE COMMENT 'Допущен к защите',
    approved_date DATE NULL COMMENT 'Дата допуска',
    submitted_date DATE NULL COMMENT 'Дата сдачи',
    is_deleted BOOL NOT NULL DEFAULT FALSE,

    FOREIGN KEY (student_id) REFERENCES Students(user_id) ON DELETE CASCADE,
    FOREIGN KEY (discipline_id) REFERENCES Disciplines(discipline_id) ON DELETE CASCADE,
    FOREIGN KEY (type_id) REFERENCES FinalWorkTypes(type_id) ON DELETE RESTRICT,
    FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id) ON DELETE CASCADE,

    INDEX(student_id),
    INDEX(discipline_id),
    INDEX(type_id)
) ENGINE=InnoDB COMMENT='Итоговая работа студента';

CREATE TABLE FinalWorkParticipants (
    participant_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    work_id INT UNSIGNED NOT NULL,
    teacher_id INT UNSIGNED NOT NULL COMMENT 'Преподаватель (user_id)',
    role ENUM('Руководитель','Консультант','Рецензент','Член комиссии') NOT NULL,

    FOREIGN KEY (work_id) REFERENCES FinalWorks(work_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES Users(user_id) ON DELETE CASCADE,

    INDEX(teacher_id),
    INDEX(role)
) ENGINE=InnoDB COMMENT='Участники итоговой работы';

CREATE TABLE FinalWorkEvents (
    event_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    work_id INT UNSIGNED NOT NULL,
    event_date DATE NOT NULL,
    description TEXT NOT NULL COMMENT 'Описание этапа: выдача задания, консультация, предзащита и т.д.',

    FOREIGN KEY (work_id) REFERENCES FinalWorks(work_id) ON DELETE CASCADE,
    INDEX(event_date)
) ENGINE=InnoDB COMMENT='Хронология работы';

CREATE TABLE FinalWorkEvaluations (
    evaluation_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    work_id INT UNSIGNED NOT NULL,
    mark_value_id TINYINT UNSIGNED NOT NULL,
    defense_date DATE NOT NULL,
    comments TEXT NULL COMMENT 'Замечания, итоги защиты',

    FOREIGN KEY (work_id) REFERENCES FinalWorks(work_id) ON DELETE CASCADE,
    FOREIGN KEY (mark_value_id) REFERENCES MarkValues(mark_value_id),

    INDEX(defense_date),
    INDEX(mark_value_id)
) ENGINE=InnoDB COMMENT='Оценка итоговой работы';

CREATE TABLE Curriculum (
    curriculum_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    group_id SMALLINT UNSIGNED NOT NULL,
    discipline_id SMALLINT UNSIGNED NOT NULL,
    semester_id TINYINT UNSIGNED NOT NULL,
    total_hours INT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Общее количество часов по дисциплине',
    is_deleted BOOL NOT NULL DEFAULT FALSE,

    FOREIGN KEY (group_id) REFERENCES `Groups`(group_id) ON DELETE CASCADE,
    FOREIGN KEY (discipline_id) REFERENCES Disciplines(discipline_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id) ON DELETE CASCADE,

    UNIQUE(group_id, discipline_id, semester_id),
    INDEX(group_id),
    INDEX(discipline_id),
    INDEX(semester_id)
) ENGINE=InnoDB COMMENT='Учебный план: дисциплина для группы в семестре';

CREATE TABLE CurriculumHours (
    hours_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    curriculum_id INT UNSIGNED NOT NULL,
    schedule_type_id TINYINT UNSIGNED NOT NULL COMMENT 'Тип занятия (лекция, лаб., практика)',
    hours DECIMAL(5,2) NOT NULL DEFAULT 0.0,

    FOREIGN KEY (curriculum_id) REFERENCES Curriculum(curriculum_id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_type_id) REFERENCES ScheduleTypes(type_id) ON DELETE RESTRICT,

    UNIQUE(curriculum_id, schedule_type_id),
    INDEX(schedule_type_id),

    CONSTRAINT chk_hours_positive CHECK (hours >= 0)
) ENGINE=InnoDB COMMENT='Распределение часов по видам занятий';

CREATE TABLE CurriculumControls (
    control_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    curriculum_id INT UNSIGNED NOT NULL,
    form_id TINYINT UNSIGNED NOT NULL COMMENT 'Форма контроля (экзамен, зачёт, кр и т.п.)',
    is_mandatory BOOL NOT NULL DEFAULT TRUE,
    control_week TINYINT UNSIGNED NULL COMMENT 'Неделя проведения контроля',

    FOREIGN KEY (curriculum_id) REFERENCES Curriculum(curriculum_id) ON DELETE CASCADE,
    FOREIGN KEY (form_id) REFERENCES ControlForms(form_id) ON DELETE RESTRICT,

    UNIQUE(curriculum_id, form_id),
    INDEX(form_id)
) ENGINE=InnoDB COMMENT='Формы контроля по учебному плану';

CREATE TABLE CurriculumAssignmentMap (
    map_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    curriculum_id INT UNSIGNED NOT NULL,
    assignment_id INT UNSIGNED NOT NULL,
    schedule_type_id TINYINT UNSIGNED NOT NULL COMMENT 'Лекция, практика и т.п.',

    FOREIGN KEY (curriculum_id) REFERENCES Curriculum(curriculum_id) ON DELETE CASCADE,
    FOREIGN KEY (assignment_id) REFERENCES TeachingAssignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_type_id) REFERENCES ScheduleTypes(type_id),

    UNIQUE(curriculum_id, assignment_id, schedule_type_id),
    INDEX(schedule_type_id)
) ENGINE=InnoDB COMMENT='Связь учебного плана с назначениями преподавателей';

CREATE TABLE JournalMarkTypes (
    mark_type_id TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE COMMENT 'Тип отметки: присутствие, оценка и т.п.',
    is_required BOOL NOT NULL DEFAULT TRUE COMMENT 'Обязательна ли к выставлению',
    value_type ENUM('numeric', 'text', 'bool', 'mark_value') NOT NULL DEFAULT 'bool' COMMENT 'Тип значения',
    is_deleted BOOL NOT NULL DEFAULT FALSE
) ENGINE=InnoDB COMMENT='Типы отметок в журнале (посещение, оценка и т.п.)';

CREATE TABLE JournalSessions (
    session_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT UNSIGNED NOT NULL COMMENT 'Привязка к преподавателю и дисциплине',
    session_date DATE NOT NULL COMMENT 'Дата занятия',
    slot_id TINYINT UNSIGNED NOT NULL COMMENT 'Номер пары',
    topic TEXT NULL COMMENT 'Тема занятия',
    session_type_id TINYINT UNSIGNED NULL COMMENT 'Тип занятия: лекция, практика и т.п.',
    schedule_id INT UNSIGNED NULL COMMENT 'Расписание, по которому сгенерировано занятие',
    is_auto_generated BOOL NOT NULL DEFAULT FALSE COMMENT 'Автоматически сгенерировано из расписания',
    is_cancelled BOOL NOT NULL DEFAULT FALSE COMMENT 'Была ли пара отменена',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (assignment_id) REFERENCES TeachingAssignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (slot_id) REFERENCES ScheduleSlots(slot_id),
    FOREIGN KEY (session_type_id) REFERENCES ScheduleTypes(type_id),
    FOREIGN KEY (schedule_id) REFERENCES Schedules(schedule_id) ON DELETE SET NULL,

    UNIQUE(assignment_id, session_date, slot_id),
    INDEX(session_date),
    INDEX(schedule_id)
) ENGINE=InnoDB COMMENT='Пара/занятие в журнале';

CREATE TABLE JournalMarks (
    mark_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    session_id INT UNSIGNED NOT NULL,
    student_id INT UNSIGNED NOT NULL COMMENT 'user_id из Students',
    mark_type_id TINYINT UNSIGNED NOT NULL COMMENT 'Тип отметки',
    numeric_value DECIMAL(4,2) NULL,
    text_value VARCHAR(255) NULL,
    bool_value BOOL NULL,
    mark_value_id TINYINT UNSIGNED NULL COMMENT 'Оценка из MarkValues',

    FOREIGN KEY (session_id) REFERENCES JournalSessions(session_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Students(user_id) ON DELETE CASCADE,
    FOREIGN KEY (mark_type_id) REFERENCES JournalMarkTypes(mark_type_id),
    FOREIGN KEY (mark_value_id) REFERENCES MarkValues(mark_value_id),

    UNIQUE(session_id, student_id, mark_type_id),
    INDEX(student_id),
    INDEX(mark_type_id)
) ENGINE=InnoDB COMMENT='Отметка студента за занятие';

CREATE TABLE JournalTemplates (
    template_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT UNSIGNED NOT NULL COMMENT 'Для кого применяется шаблон',
    mark_type_id TINYINT UNSIGNED NOT NULL COMMENT 'Какие отметки в журнале использовать',

    FOREIGN KEY (assignment_id) REFERENCES TeachingAssignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (mark_type_id) REFERENCES JournalMarkTypes(mark_type_id),

    UNIQUE(assignment_id, mark_type_id)
) ENGINE=InnoDB COMMENT='Шаблон отметок по назначению преподавателя';

DELIMITER $$

CREATE TRIGGER trg_validate_teaching_load
BEFORE INSERT ON TeachingAssignmentLoads
FOR EACH ROW
BEGIN
    DECLARE total_plan DECIMAL(5,2);

    SELECT SUM(h.hours)
    INTO total_plan
    FROM Curriculum c
    JOIN CurriculumHours h ON c.curriculum_id = h.curriculum_id
    JOIN CurriculumAssignmentMap map ON map.curriculum_id = c.curriculum_id
    WHERE map.assignment_id = NEW.assignment_id
      AND map.schedule_type_id = NEW.load_type_id;

    IF total_plan IS NOT NULL AND NEW.hours_planned > total_plan THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Назначенная нагрузка превышает плановую';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_students_expelled
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    IF NEW.expulsion_date IS NOT NULL THEN
        SET NEW.is_expelled = TRUE;
    END IF;
END$$

CREATE TRIGGER trg_students_expelled_update
BEFORE UPDATE ON Students
FOR EACH ROW
BEGIN
    IF NEW.expulsion_date IS NOT NULL THEN
        SET NEW.is_expelled = TRUE;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_update_grade_attempts
BEFORE INSERT ON GradeAttempts
FOR EACH ROW
BEGIN
    -- Сбросить предыдущую финальную попытку
    UPDATE GradeAttempts
    SET is_final = FALSE
    WHERE student_id = NEW.student_id
      AND sheet_id = NEW.sheet_id;

    -- Установить текущую как финальную
    SET NEW.is_final = TRUE;
END$$

DELIMITER ;
