-- ================================================================
-- Импорт данных из Excel файлов
-- Дата генерации: 2026-04-16
-- Компаний: 445
-- Контактов ЛПР: 213
-- Записей активности: 448
-- КП: 5
-- ================================================================

-- ВРЕМЕННО отключаем RLS для импорта
ALTER TABLE companies DISABLE ROW LEVEL SECURITY;
ALTER TABLE company_contacts DISABLE ROW LEVEL SECURITY;
ALTER TABLE activities DISABLE ROW LEVEL SECURITY;
ALTER TABLE proposals DISABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_items DISABLE ROW LEVEL SECURITY;

-- ═══ COMPANIES ═══
INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ГТтехнолоджис',
  NULL,
  NULL,
  NULL,
  NULL,
  'www.gtenergo.ru',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ALIK_ID,
  NULL,
  'Входяшка.Отправил КП',
  '2025-04-14',
  '2025-04-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ТрансЭнергоХолдинг''',
  NULL,
  NULL,
  NULL,
  NULL,
  'www.tehold.ru',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ALIK_ID,
  NULL,
  'Входяшка, звонил анар попутка по нашей теме отправилКП',
  '2025-04-14',
  '2025-04-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "СПЕЦЭКОНОМЭНЕРГО"',
  '3528257419',
  NULL,
  NULL,
  NULL,
  'http://spenergo.com/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'На связи с ним',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ГлавЭлектроСнаб',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'На связи с ним',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПЭП"',
  '7801454062',
  NULL,
  '+78124958999',
  '4958999@pep-spb.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказал директор отправить на щакупшика на валентина с ним еще пообщаться надо',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АртЭнерго строй',
  NULL,
  NULL,
  NULL,
  'info@aenergo.su',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'недозвон кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Инженерный центр Энергетики',
  NULL,
  NULL,
  NULL,
  'info@ecenergy.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Пообшались сказали закупают кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЭТС Энерго',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://etsenergy.ru/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'недозвон кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Олниса',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Систем Электрик',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://systeme.ru/partners',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'ОТправил кп сложно пробиться',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Стройэнергоком',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказал закупили уже много чего в первом квартале, звонить в конце августа',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ТрансЭлектромонтаж',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://tem.ru/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ALIK_ID,
  NULL,
  'Отправил КП, поговорил сказал перенабрать поговорить точечно а так закупают',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Тверь Энергоактив',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил недозвон пока что с кем то разговаривал',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''Элмонт Энерго''',
  NULL,
  NULL,
  NULL,
  'snab@elmont.su',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Попросил кп на почту снабженец',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Сетьстрой',
  NULL,
  NULL,
  NULL,
  'info@setistroi.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил , сказал пока что вопрос по поставкам неакутальный, но будем пробивать его',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'МагистральЭнерго',
  NULL,
  NULL,
  NULL,
  'sklad-mag-energo@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил Занято',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЭнергоПромСТрой',
  NULL,
  NULL,
  NULL,
  'eps.llc@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил Занято',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Норэнс Групп',
  NULL,
  NULL,
  NULL,
  'info@norens.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил Занято',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'МосСитиСервис',
  NULL,
  NULL,
  NULL,
  'info@mss-24.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил сложно пробиться буду пробовать еще раз',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЭнергоСистемы',
  NULL,
  NULL,
  NULL,
  'Zayavka@e-systems.su',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Телефон не работает',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Магистр',
  NULL,
  NULL,
  NULL,
  'info@magistr3m.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Блять не понимаю че у них у всех с телефонами',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Строймонтаж',
  NULL,
  NULL,
  NULL,
  'snab@stroymontag.su',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказала отправляйте кп рассмотрим начальник отдела снабжения',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''СК ЭНЕРГЕТИК''',
  NULL,
  NULL,
  NULL,
  'sk.msk@inbox.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Ответила женщина сказала проекты есть направляйте кп для снаюжения еще раз перезвоним ей потом',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'СПМенерго',
  NULL,
  NULL,
  NULL,
  'Spmenergo@gmail.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'пока что сказала ничего нет в работе',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ВМЗ',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Мой клиент по основной работе, у них конкурсы черещ плошадку их собственную там надо регать компанию чтобы учавствовать',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''НПОТЭЛ''',
  NULL,
  NULL,
  NULL,
  'kazakov.i@ural.tavrida.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Договорились тут на встречу классны типо закупают',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''УРАЛМАШ НГО ХОЛДИНГ''',
  NULL,
  NULL,
  NULL,
  'info.urbo@uralmash-ngo.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Не дозвонился попробовать еще раз в снабжение/ не дозвон пока что',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''КАПРАЛ БРИДЖ''',
  NULL,
  NULL,
  NULL,
  'info@cupralbridge.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказала закупают, направлю письмо сказщала посмотрит',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭСК''',
  NULL,
  NULL,
  NULL,
  'energysc@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Не дозвонился пока что до него, скинул, позже набрать/ на обеде сказал чуть позже набрать',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''СТРОЙТЕХУРАЛ''',
  NULL,
  NULL,
  NULL,
  'amg_off@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Заинтересовался, попросил предложение на почту',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''АГРЕГАТЭЛЕКТРО''',
  NULL,
  NULL,
  NULL,
  'agregatel@bk.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  '2025-06-11',
  'Номер щакупок выцепил пока что не отвечают, отправляю кп   89204505168 Роман Сергеевич agregatel1@bk.ru(11.06)',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''РЕГИОНИНЖИНИРИНГ''',
  NULL,
  NULL,
  NULL,
  'info@pgregion.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказал зщакупают все ок запросы пришлет',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭНЕРГОТЕХСЕРВИС''',
  NULL,
  NULL,
  NULL,
  'info@tmenergo.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Вадим Логист, сказал перешлет письмо с инженерам с ним на коннекте',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''ТД ''ЭЛЕКТРОТЕХМОНТАЖ''',
  NULL,
  NULL,
  NULL,
  'etm@etm.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Не дозвонился но кп отправил, пробовать снова',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ОМСКЭЛЕКТРОМОНТАЖ''',
  NULL,
  NULL,
  NULL,
  'info@omskem.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'В вотсап написал 10 июля',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭЛЕКТРОЩИТ''',
  NULL,
  NULL,
  NULL,
  'info@elshkaf.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Пока что нет ее на месте кп отправил перезвонить. ОТправил ей кп, сказала закупают рассмотрит/ короче ктп сами делают говорит в основном заказчик сам приорбретает трансформатор но если что то будет направит',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ПРОМСОРТ-ТУЛА''',
  NULL,
  NULL,
  NULL,
  'tulasteel@tulachermet.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Нвправио кп в отдел снабжения',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО НПК ''ЭЛПРОМ''',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Короче они заказывают по ошибке реально они зщаказывали трансу другой компании короче надо внедриться к ним, не отвечает 11.06/ не отвечает пока что Юлия/stv@/Юлия не отвечает пока что 10/07',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ПРОМКОМПЛЕКТАЦИЯ''',
  NULL,
  NULL,
  NULL,
  'oleg.kadochkin@start-el.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказал закупают кп направляю',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''ВНИИР ГИДРОЭЛЕКТРОАВТОМАТИКА''',
  NULL,
  NULL,
  NULL,
  'vniir@vniir.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказал скиньте инфу посмотрим',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "УВАДРЕВ-ХОЛДИНГ"',
  '1831090774',
  NULL,
  NULL,
  'office-st@hk-vostok.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Не отвечает пока что перезвонить кп направил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭЛЕКТРОЩИТ-УФА''0278151411',
  NULL,
  NULL,
  NULL,
  'info@electroshield.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'не отвечает перезвонить/не отвечает не могу дозвонится пока что на обеде',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "РСК"',
  '3848001367',
  NULL,
  NULL,
  'irk@rsktrade.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'не смог дозвониться, видимо все на обеде, чуть позже набрать но через добавочные на них можно выйти /недозвон',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ГК АЛЬЯНС''7017409323',
  NULL,
  NULL,
  NULL,
  '3822220075@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказал набрать в рабочее время перезвонить/Сказал направить на почту',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ПТК "ЭКРА-УРАЛ"',
  '6685079144',
  NULL,
  NULL,
  'info@ekra-ural.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Все слиняли уже на рпаздники набрать после  / пока что не отвечают почему то по добавочному',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ТЕКСИС ГРУП''7710620481',
  NULL,
  NULL,
  NULL,
  'sales@texcisgroup.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил на Дмитрия/ передам инфу дмитрию и на этом все закончилось мерзкий секретарь 10/07',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО  ''УРАЛЭНЕРГОЦЕНТР''',
  NULL,
  NULL,
  NULL,
  'trans74@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказал заявки есть и проекты тоже есть',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''РС''7704844420',
  NULL,
  NULL,
  NULL,
  'feedback@russvet.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Попробуем в русский свет пробиться',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''ЭНЕРГОТЕХПРОЕКТ''6319171724',
  NULL,
  NULL,
  NULL,
  'azarova@etpsamara.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Юлия Азарова 2 ярда оборот',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ТЭС НН''5258109139',
  NULL,
  NULL,
  NULL,
  'info@tes.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Нет ответа мб уже на праздниках,кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ПО ''РОСЭНЕРГОРЕСУРС''5404223516',
  NULL,
  NULL,
  NULL,
  '410.2@rernsk.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'сказал вышли кп посмотрю',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ТЭМ"',
  '6672271281',
  NULL,
  NULL,
  'info@te-montage.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказала у них только с атестацией в Россетях но кп сказала направьте',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭЛЕКТРОНМАШ ПРОМ"',
  '7802447318',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Перенабрать еще раз не соединилось с отделом закупок',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5834121869 ООО ''ЭВЕТРА ИНЖИНИРИНГ''',
  NULL,
  NULL,
  NULL,
  'dsa@evetraeng.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказал закупаем переодически направляю кп',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭНЕРГОТЕХСТРОЙ''5902126385',
  NULL,
  NULL,
  NULL,
  'office@etsperm.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Тут надо выйти на отдел снабжения они этим занимаются, кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''ПО ЭЛТЕХНИКА''7825369360',
  NULL,
  NULL,
  NULL,
  'info@elteh.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Тут надо выйти на снабжение не отвечали, попробовать дозвониться',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5190016541ООО ''ТРАНСЭНЕРГО-СЕРВИС''',
  NULL,
  NULL,
  NULL,
  'info@newtes.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  '89210409085 Михаил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7448200380ООО ''КВАНТУМ ЭНЕРГО''',
  NULL,
  NULL,
  NULL,
  'omts1@k-en.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Сказала присылайте посмотрим интерес есть',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5260342654ООО ТД ''СПП''',
  NULL,
  NULL,
  NULL,
  'buh@td-cpp.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Направил кп, недозвон',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '9102000126 ООО ''СПЕЦЩИТКОМПЛЕКТ''',
  NULL,
  NULL,
  NULL,
  'info@russkomplekt.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Задача пообшаться С катей? обшался с Сергеем, сказал закупают трансформаторы',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7728679260 ООО ''ПЕТРОИНЖИНИРИНГ''',
  NULL,
  NULL,
  NULL,
  'info@petroin.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Каталог отправил кп тоде дозвниться тут не смог',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '6311115968 ООО ''ТСК ВОЛГАЭНЕРГОПРОМ''',
  NULL,
  NULL,
  NULL,
  'energy-sale@gcvep.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Будет на след неделе а так у них запросы есть, кп отправил в догонку',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '6672180274 ООО ''МОДУЛЬ''',
  NULL,
  NULL,
  NULL,
  'zakupki@bktp.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отпрапвил сотрудник на совещании перезвонить',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '3664123615 ООО ''ВЭЗ''',
  NULL,
  NULL,
  NULL,
  'info@vorez.org',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'До снабжения не дозвонился на обеде, ставлю перезвон, кп в догонку',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '2126001172 ООО НПП ''ЭКРА''',
  NULL,
  NULL,
  NULL,
  'ekra@ekra.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Обед, перезвонить, кп в догонку/ набрать в 3 по екб обед у них',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7733634963 ЗАО ''СТРОЙЭНЕРГОКОМПЛЕКТ''',
  NULL,
  NULL,
  NULL,
  'sen-komplekt@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Перенабрать предложить сотрудничесво секретарь не втухает/перенабрал кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7813192076 ООО ''АТЭКС-ЭЛЕКТРО''',
  NULL,
  NULL,
  NULL,
  'l11@atelex.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Татьяна закупщик сказала проекты бывают перешлет проектому отделу',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7710957615 ООО ''ПРОМСТРОЙ''',
  NULL,
  NULL,
  NULL,
  'info@promstroy-ooo.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Направил кп не дозвонился',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5404464448ООО ''НТК''',
  NULL,
  NULL,
  NULL,
  '2080808@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Не отвечабт скорее всего на обеде отправляю кп на отдел закупок',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7702080289 АО ''СИЛОВЫЕ МАШИНЫ''',
  NULL,
  NULL,
  NULL,
  'thermal@power-m.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Для Марии направил письмо',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5914007456 ООО ''ПРОМЫШЛЕННАЯ ГРУППА ПРОГРЕССИЯ''',
  NULL,
  NULL,
  NULL,
  'info@pgp-perm.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Закупают кп отправил для них, но нужно узнат имя человека который акупает трансы',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '4205152361 ООО ''ЗЭМ''',
  NULL,
  NULL,
  NULL,
  'info@z-em.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Не отвечабт мб на обеде перезвонить с утра',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '6731035472 ООО ''ТД ''АВТОМАТИКА''',
  NULL,
  NULL,
  NULL,
  'info@td-automatika.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп направил ему сказал рассмотрит',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '6670316434 ООО ''ЭЗОИС-УРАЛ''',
  NULL,
  NULL,
  NULL,
  'info@ezois-ural.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'не дозвонился до него нало перещзвонить видимо не на месте/ дозвонился кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '6150045308 ООО ''АВИААГРЕГАТ-Н''',
  NULL,
  NULL,
  NULL,
  'Ogk@avem.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Закупабт тут технари а не отдел снабжения заявку сказал сейчас пришел',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5190044620 АО ''ТЕХНОГРУПП''',
  NULL,
  NULL,
  NULL,
  'info@technogroupp.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'тут не пробился пробовать еще',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7814461557 ООО ''НТТ-ИК''',
  NULL,
  NULL,
  NULL,
  'info@ferroma.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Закупают трансформаторы сами производят сухие, кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '0571014706 ООО ''СПЕЦСТРОЙМОНТАЖ''',
  NULL,
  NULL,
  NULL,
  'specmount05@gmail.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Интересно ему ждем от него сообщение в вотсапе',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5029227275 ООО ''ЭТК''',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Списались в вотсапе',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '2130100264ООО ''НИП''',
  NULL,
  NULL,
  NULL,
  'info@nipdoc.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7701389420 ООО ''АТЕРГО''',
  NULL,
  NULL,
  NULL,
  'info@atergo.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Перезвонить Юлии, уточнить акупают ли они трансы представиться как ХЭНГ она закупщица/ Ответил тип какой то выйти на Юоию надо',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7736606442 ООО ''ТЕХСТРОЙМОНТАЖ''',
  NULL,
  NULL,
  NULL,
  'Snab@thsmont.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Закупают кп на почту отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '6674353123 ООО ''АЛЬЯНС РИТЭЙЛ''',
  NULL,
  NULL,
  NULL,
  'op@unicumg.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Не отвечали направляю кп',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '3810051697 ООО ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ ''РАДИАН''',
  NULL,
  NULL,
  NULL,
  'op@unicumg.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Иркутск кп отправил с утра набрать',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '6671406440 ООО ИК ''ЭНЕРГОСОФТ''',
  NULL,
  NULL,
  NULL,
  'info@s-s-pro.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил на него ждем запросы',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7820307592 ООО ''ЭНЕРГОСТАР''',
  NULL,
  NULL,
  NULL,
  'info@starenergo.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Направил кп секретарь сложный',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5404396621 ООО НПП ''МИКРОПРОЦЕССОРНЫЕ ТЕХНОЛОГИИ''',
  NULL,
  NULL,
  NULL,
  'omts@i-mt.net',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5903148303 ООО ''БЛЮМХЕН''',
  NULL,
  NULL,
  NULL,
  'corp.blumchen@gmail.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'кп отправил по номерам не дозвониться',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '1657048240 ООО ''УК ''КЭР-ХОЛДИНГ''',
  NULL,
  NULL,
  NULL,
  'office@ker-holding.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Кп отправил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '0277071467 ООО ''БАШКИРЭНЕРГО''',
  NULL,
  NULL,
  NULL,
  'secr@bashkirenergo.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Пробуем пробиться в башкирэнерго',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '3446034468ООО ''ЭНЕРГИЯ ЮГА''',
  NULL,
  NULL,
  NULL,
  'kdv@energy-yug.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'кп отправил на линии занято',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7451227920ООО ''ЭЛЕКТРОСТРОЙ''',
  NULL,
  NULL,
  NULL,
  'elektrostroy2008@yandex.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'не отвечабт кп направил',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '0268027020ООО ''ЭНЕРГОПРОМСЕРВИС''',
  NULL,
  NULL,
  NULL,
  'info@epservice.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'кп направил не отвечают',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '6166107912 ООО ''РОСТЕХЭНЕРГО''',
  NULL,
  NULL,
  NULL,
  'snab@rte.su',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Отправил ему письмо жду заявку, перенабрать ему тоже надо',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '6686078707 ООО ''ПЭМ''',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Мы с ним на вотсапе попросил инфу',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '2116491707 ООО ''ИЗВА''',
  NULL,
  NULL,
  NULL,
  'oz3@izva.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ALIK_ID,
  NULL,
  'КП направил она не отвечает перезвонить ей',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '2502047535 ООО ''ВОСТОКЭНЕРГО''',
  NULL,
  NULL,
  NULL,
  'vostok-elten@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Отправил кп не дозвонился',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5260401638 ООО ''КРЭС''',
  NULL,
  NULL,
  '+78312022629',
  'info@kresnn.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'сказали обед перезвонить отдел снабжения',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7453260063 ООО ''СТРОЙЭНЕРГОРЕСУРС''',
  NULL,
  NULL,
  NULL,
  'electrotmp@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ALIK_ID,
  NULL,
  'Антон, главный инженер сказал направбте на мое имя, нужно еще в отдел закупок доб 1',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Ставропольэлектросеть',
  '2635244268',
  NULL,
  '88652748801',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Будут кидать нам запросы для выход на торги',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'p-seti.ru',
  NULL,
  NULL,
  '88005118984',
  'info@p-seti.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'отправил кп на почту',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7817302964 https://izhek.ru/',
  NULL,
  NULL,
  '+78123228659',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Связь с закупчиком хорошая',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ГОУП «Кировская горэлектросеть»',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Евросибэнерго',
  NULL,
  NULL,
  '83952792233',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил со стасом. Надо регаться на сайте https://td.enplus.ru/ru/zakupki-tovarov/ Можно работать. У нас общие китайцы. Второй звонок',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ХК ''СДС - ЭНЕРГО''',
  NULL,
  NULL,
  '83842574202',
  'v.nikolaev@sdsenergo.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Готовы брать из наличия. По торгам у них выступает другое юр лицо. Торговый дом sds treid. искать на госзакупках',
  '2025-04-16',
  '2025-04-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''ОБЪЕДИНЕННЫЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ''',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'начальник снажения. контакт хороший.жду обратную связь',
  '2025-04-16',
  '2025-04-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "САМЭСК"',
  '6319231042',
  NULL,
  '+78462766071',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'работают только через торги. смотреть гос.закупки',
  '2025-04-16',
  '2025-04-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''КРАСЭКО''',
  NULL,
  NULL,
  '73912286207',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с закупщиком КТП. Женщина. Говорит что закупают напрямую. Просит давать самое выгодное предложение сразу, время торговаться нету. газпром росселторг',
  '2025-04-17',
  '2025-04-17'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Энергонефть Томск http://energoneft-tomsk.ru/index.php?id=13',
  NULL,
  NULL,
  '83825966004',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Не могу дозвониться. надо пробовать.21.05.25. Дозвонился до отдела закупок. Торгуются на площадке газпрома.',
  '2025-04-21',
  '2025-04-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЗАО "ЭИСС"',
  '6320005633',
  NULL,
  '88482637900',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Берут БКТП и трансформаторы. Связаться после среды.',
  '2025-04-21',
  '2025-04-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''Варьегоэнергонефть'' https://oaoven.ru/kont.html',
  NULL,
  NULL,
  '83466840108',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Связался с начальником ПТО. Тендерная система. Закрытые закупки. Китайцы интересны. По техническим моментам (40140)/ 29.08.2025 заявок нет',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''Пензенская горэлектросеть',
  NULL,
  NULL,
  '88412290679',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Павел не решает. До александра не дозвонился. 5 августа 2025 - заявок нет// 25 августа 2025 года - заявок нет// 17 сентября - заявок нет//',
  '2025-04-21',
  '2025-04-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''ОРЭС-ПРИКАМЬЯ''',
  NULL,
  NULL,
  '83422181631',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  '26.03.2026. заявок нет',
  '2025-04-21',
  '2025-04-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'https://eskchel.ru/ ТМК Энерго',
  NULL,
  NULL,
  '+73512006239',
  'Gennadiy.Savinov@tmk-group.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Заинтересовал снабженца Китаем. Попросил скинуть ему на почту инфу о нас. Говорит, что будет закупка - будет и пища)',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПРОМЭНЕРГОСБЫТ"',
  '7107064602',
  NULL,
  NULL,
  'endin_ae@promenergosbyt.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не дохвонился, а надо',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ПКГУП ''КЭС''',
  NULL,
  NULL,
  '83426140910',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Выбил комер закупщика. Поговорил. Отправят запрос на КТП',
  '2025-04-29',
  '2025-04-29'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Акционерное общество «Витимэнерго»',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Набрал в общий отдел. Дали этот номер. Сегодня там   выходной. Набрать завтра. Спросить снабжение',
  '2025-04-29',
  '2025-04-29'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Черкессие городские сети',
  '0901048801',
  NULL,
  '88782282251',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Связался с секретарем. Дали комер отдела закупок. Не взяли. Пробовать еще раз.',
  '2025-04-29',
  '2025-04-29'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Щекинская ГОРОДСКАЯ ЭЛЕКТРОСЕТЬ',
  NULL,
  NULL,
  '84875152656',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с закупщиком. Женщина в возрасте. Работают под росстеями под торги. Торги проходят на площадке РАД. Будут торги на трансформаторы 250,400,630 после майских',
  '2025-04-29',
  '2025-04-29'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ИНТЕГРАЦИЯ"',
  '1658191691',
  NULL,
  '88432125300',
  'ustinov@integration-kzn.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Познакомился с закупщиком. Нашего профиля маловато, но будут скидывать запросы, потому что хорошо поговорили.',
  '2025-04-29',
  '2025-04-29'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "НЭСК"',
  '5256133344',
  NULL,
  '88312990507',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Не дозвонился до инженера. Пробовать еще. в этом году не будет закупок. звонок юыд 14 -7 2025',
  '2025-05-14',
  '2025-05-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Электросети"',
  '7024035693',
  NULL,
  '83823774986',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Кое-как нашел номер приемной но не дозвонился.11 сенября 2025 вытащил номер главного инженера. было занято/// 18.09.2025. поговорил с инженером. закупки проходят по 223 фз. прямых нет. попросил кп.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ВЭС-СНТ"',
  '3443139342',
  NULL,
  '88442561567',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Работают через торги. Наш профиль. Площадка: ЭТП ГПБ.',
  '2025-05-14',
  '2025-05-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭУ''',
  NULL,
  NULL,
  '83436541456',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Берут только измерительные трансы нтми.',
  '2025-05-14',
  '2025-05-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ХГЭС"',
  '2702032110',
  NULL,
  '84212479013',
  'zakupki@khges.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_MAGEL_ID,
  NULL,
  'Пообщался с закупщицей. Очень хорошо поговорили. Есть и прямые закупки до 1.5 млн. Берут и трансы и ктп. РТС тендер. скоро закупка. Отправил КП',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'МУП ''Электросервис''',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  '21.05.2025. Дозовнился до отдела закупок. торгуются на площадке ТЕГТОРГ. Прямых на подстанции и трансы не бывает.',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ДВ РСК"',
  '2531006580',
  NULL,
  '84233148584',
  'buxdvrsk@yandex.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Пообщался со старым) Нормальный перец. будут брать,думаю/ 29.08.2025 не берет',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "УСТЬ-СРЕДНЕКАНСКАЯ ГЭС ИМ. А.Ф. ДЬЯКОВА"',
  '4909095293',
  NULL,
  '84134346968',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с секретарем. Снабженцы сидят на Колымской ГЭС. Дала номер, но там пищат что-то. пробовать позже/29.08.2025. Не дозвон.',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "УССУРИЙСК-ЭЛЕКТРОСЕТЬ"',
  '2511121619',
  NULL,
  '84234322742',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Узнал номер снабжения безхитростным путем. Но там сука не берут. Пытаться еще/29.08.2025. Не дозвон.',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "СЭС"',
  '2510003066',
  NULL,
  '84235223514',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с закупщиком. Он сказал, что больших закупок пока не будет, но будут разовые. Китай интересен. 29.08.2025. Не дозвон.',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "КЭС"',
  '4101090167',
  NULL,
  '84152228000',
  'kam.el.sety@yandex.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с девочкой. Пока заказов нет, но просит отправить инфу. Контакт хороший',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ ''ТЕХЦЕНТР''',
  NULL,
  NULL,
  '89242352243',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Руслан хороший парень. Сразу скентовались с ним) Уже есть заказ',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ТД "ЭЛЕКТРОСИСТЕМЫ"',
  '2724182990',
  NULL,
  '84212417002',
  '252@dc-electro.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с закупщицей. Рассмотрят наше предложение//29.08.2025  Сказала не занимаются трансами. пиздит возможно',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "АСК"',
  '2901295280',
  NULL,
  '89210795185',
  '103@2488.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорили с Игорем. Интересно ему. Скинет заявку.Поговорил с игорем 14 07 25. не получил заявку',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Енисей сеть сервис',
  '2465302760',
  NULL,
  '88182248833',
  'e.e.servis@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'отправил кп на почту/ 29.08.2025 Секретарь ебет мозга',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Акционерное общество «Городские электрические сети» (АО «Горэлектросеть»)',
  '8603004190',
  NULL,
  '83466635907',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Позвонил в отдел снабжения. Поговорил с парнем. Торгуются на РТС. Прямых нет.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "СИНТЕЗ ГРУПП"',
  '7719609274',
  NULL,
  '84951145005',
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_MAGEL_ID,
  NULL,
  'Разговаривал с закупщиком. Строгий дядя) Но попросил КП.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ПКБ ''РЭМ''',
  NULL,
  NULL,
  '88124381622',
  'orlov@pkbrem.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговори с начальником снабжения. Скинул КП',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЦЭК"',
  '7714426397',
  NULL,
  '+74957926433',
  'office@celscom.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Отправил снабженцу кп',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПРИЗМА"',
  '2124019520',
  NULL,
  '84951343535',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'отправил кп на почту. звонил. 29.08.2025 сказал на пол года проекты расписаны. отравить кп. Набрать после майских 2026',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ГОРСЕТИ"',
  '7017081040',
  NULL,
  '83822999513',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'связался с закупками. работают через торги 223 фз. 29.08.2025 закупщица сказала, что не сказала бы что закупка проводится',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Томские электрические сети»',
  '7017380970',
  NULL,
  NULL,
  'tes012016@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил с секретарем. сказала пока не даст номер снабженца и имя не скажет. но ключевое слово пока))',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '«СибБурЭнерго»',
  '7017097931',
  NULL,
  NULL,
  'shkv@sibburenergo.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не прошел секретаря. отдать алику на доработку',
  '2025-05-22',
  '2025-05-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "КЭСР"',
  '1001012723',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не дозвон',
  '2025-05-22',
  '2025-05-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''ТЭТ-РС''',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'снабженца нет на месте пока. перезвоню',
  '2025-05-22',
  '2025-05-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЗАО ''ТЭСА''',
  NULL,
  NULL,
  '88123226799',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил со снбаженцем. Пока что мнется, но сказал набрать попозже. может, что появится. у секретаря сразу просить соеденить со снабжением.',
  '2025-05-22',
  '2025-05-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "КЭС"',
  '5018187729',
  NULL,
  '+79167255263',
  'info@korolevseti.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'отправил кп на почту.',
  '2025-05-22',
  '2025-05-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "НОРДГРОН"',
  '2466250680',
  NULL,
  '83912001232',
  'info@nordgron.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Заинтересовались. отправил кп',
  '2025-05-23',
  '2025-05-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭнергоИнжиниринг''  ОГРН 1162468059225 ИНН 2466169359',
  NULL,
  NULL,
  '+73912724245',
  'info@eepro.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'отправил кп.',
  '2025-05-23',
  '2025-05-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ТСК "ЭНЕРГОАЛЬЯНС"',
  '2411027355',
  NULL,
  '89029433265',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил со светланой. интерес по трансам. скинул цены на вотсапп. 8.04.2026 заявок нет',
  '2025-05-23',
  '2025-05-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Энергосибинжиниринг»',
  '2460107451',
  NULL,
  '89232876163',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил с натальей. хочет россети. скинул инфу на вотсапп. но разговор хороший. будет отправлять заявки.',
  '2025-05-23',
  '2025-05-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «ЭКРА-ВОСТОК»',
  '2721206795',
  NULL,
  NULL,
  'vostok@ekra.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Контакт хороший, но не могу отправить письмо. надо норм почту.',
  '2025-05-23',
  '2025-05-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"КЭС ОРЕНБУРЖЬЯ"',
  '5609088434',
  NULL,
  '89128497489',
  'kes_2021@bk.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил со снабженцем. получил заявку',
  '2025-05-28',
  '2025-05-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'МП "ВПЭС"',
  '4703005850',
  NULL,
  NULL,
  'ahd.dvg@vsevpes.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Рамочный договор на год. Поговорил с Дашей. Будут иметь нас ввиду.',
  '2025-05-28',
  '2025-05-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"БОГОРОДСКАЯ ЭЛЕКТРОСЕТЬ"',
  '5031095604',
  NULL,
  '84965101121',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Не поговорил со снабжением. Перезвонить',
  '2025-05-28',
  '2025-05-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "СИСТЕМА"',
  '9725034250',
  NULL,
  '+74952258718',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'отправил кп на почту. звонил.',
  '2025-05-28',
  '2025-05-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «ОЭС»',
  '7727691900',
  NULL,
  '84985683837',
  'info@oesystems.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Набрал. Спецы были заняты. отправил кп. связаться позже',
  '2025-05-28',
  '2025-05-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "МЭС"',
  '7415041790',
  NULL,
  NULL,
  'mes74@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил С ЛПР. Китай не инетересен.только подстанции',
  '2025-05-29',
  '2025-05-29'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ЗАПАДНАЯ ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ"',
  '3906970638',
  NULL,
  NULL,
  'wpc@inbox.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с закупщицей.Попросила скинуть инфу. Будут в понедельник.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ОАО "СКЭК".',
  '4205153492',
  NULL,
  '83842680851',
  'abzalov@skek.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_MAGEL_ID,
  NULL,
  'Не дозвон. Отправил КП.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ФАБИ"',
  '5005005770',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'выбил номер снабжения. перезвонить через час',
  '2025-05-03',
  '2025-05-03'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ИНТЕР РАО - ИНЖИНИРИНГ"',
  '5036101347',
  NULL,
  NULL,
  'lukyanov_av@interrao.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_MAGEL_ID,
  NULL,
  'НАРЫЛ НОМЕР ЗАКУПЩИКА. У НИХ ЕСТЬ ГКПЗ. СКАЗАЛ УЧАВСТОВАТЬ В ЗАКУПКАХ НА ОБЩИХ ОСНОВАНИЯХ. ПОКА ВЯЛО. НО НАДО ПРОБИВАТЬ. ОН БЫЛ ОЧЕНЬ УСТАВШИМ. ТОРГУЮТСЯ НА СОБСТВЕННОЙ ПЛОЩАДКЕ: https://interrao-zakupki.ru/purchases/',
  '2025-06-03',
  '2025-06-03'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «БГК»',
  '0277077282',
  NULL,
  '83472228625',
  'office@bgkrb.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Отправил письмо на ген дира.',
  '2025-06-03',
  '2025-06-03'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "МЕРИДИАН ЭНЕРГО"',
  '7743795832',
  NULL,
  '74959881774',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'секретарь сука. не могу пробить.',
  '2025-06-03',
  '2025-06-03'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ГОРЭЛЕКТРОСЕТЬ"',
  '7456038645',
  NULL,
  '83519293083',
  'ges@gesmgn.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'торгуются на ртс тендере.',
  '2025-06-04',
  '2025-06-04'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ЭЛЕКТРОУРАЛМОНТАЖ"',
  '6660003489',
  NULL,
  '83433857000',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'перезвонить завтра. Дозвонился до закупок 5 июня. просят аттестацию россетей. берут 110 трансы и 220 чаще.',
  '2025-06-04',
  '2025-06-04'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"СПЕЦЭНЕРГОГРУПП"',
  '7743211928',
  NULL,
  '84999433597',
  'info@segrup.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Перезвонить завтра. Битва с закупщиком',
  '2025-06-04',
  '2025-06-04'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ДРСК"',
  '2801108200',
  NULL,
  '84162397367',
  'doc@drsk.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не дозвонился до закупок. Российский акционный дом торговая площадка. Интересны китайцы. Прямых нет',
  '2025-06-05',
  '2025-06-05'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ПО КХ Г.О. ТОЛЬЯТТИ"',
  '6324014124',
  NULL,
  '88482772594',
  'info@ao-pokh.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не дозвонился',
  '2025-06-05',
  '2025-06-05'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ТРАНСНЕФТЬЭЛЕКТРОСЕТЬСЕРВИС"',
  '6311049306',
  NULL,
  '84952529180',
  'ES-INFO@transneft.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не дозвонится',
  '2025-06-05',
  '2025-06-05'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "РСК"',
  '6670018981',
  NULL,
  '83433794377',
  'rsk@sv-rsk.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Юрий Григорьевич сказал выходить на торги. Заказ РФ.',
  '2025-06-05',
  '2025-06-05'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭЛВЕСТ"',
  '6670162424',
  NULL,
  '83433834618',
  'tender@elvest-ek.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'дозвониться завтра',
  '2025-06-05',
  '2025-06-05'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '''ЭНЕРГОУПРАВЛЕНИЕ''6603023425',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''НТЭАЗ Электрик''6615010205 https://www.vsoyuz.com/ru/kontakty/sluzhba-zakupok.htm',
  NULL,
  NULL,
  '83432532180',
  'bekseleev@nteaz.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'снабженка в отпуске. набрать через неделю',
  '2025-06-06',
  '2025-06-06'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"АРТЭНЕРГОСТРОЙ"',
  '5835133183',
  NULL,
  NULL,
  'info@aenergo.su',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'заинтересовались. с китаем работали. нужно представительсво. оно есть. ждем запрос. набрать после уточнения наших цен',
  '2025-06-09',
  '2025-06-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «КУЗНЕЦК ЭЛЕКТРО»',
  NULL,
  NULL,
  NULL,
  '993220@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил с человеком. вроде интерес есть',
  '2025-06-09',
  '2025-06-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '''РЕГИОНЭНЕРГОСЕТЬ''5948063201',
  NULL,
  NULL,
  '+73422068807',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'снабжения нет на месте',
  '2025-06-09',
  '2025-06-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АКЦИОНЕРНОЕ ОБЩЕСТВО "ГИДРОЭЛЕКТРОМОНТАЖ"',
  '2801085955',
  NULL,
  '84162399821',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не дозвонился',
  '2025-06-16',
  '2025-06-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "УЭСК"',
  '5903047697',
  NULL,
  '83433856771',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'перезвонить позже',
  '2025-06-16',
  '2025-06-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО “АвтоматикаСтройСервис”',
  NULL,
  NULL,
  '+73433825233',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Все предложения через руководителя. попросили направить кп на его имя. Попробовать связаться позже',
  '2025-06-16',
  '2025-06-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"СК "ЭВЕРЕСТ"',
  '1215214540',
  NULL,
  '89371119441',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'было занято. перезвонить',
  '2025-06-16',
  '2025-06-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ПКП "ФИНСТРОЙИНВЕСТ"',
  '7448114740',
  NULL,
  '83512254729',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не прошел секретаря. пробовать позже',
  '2025-06-16',
  '2025-06-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ОЗЭМИ"',
  '5614001069',
  NULL,
  '83537376112',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'перезвонить. на отгрузке.',
  '2025-06-16',
  '2025-06-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Общество с ограниченной ответственностью «ЭнергоПрогресс»',
  NULL,
  NULL,
  '+79226335000',
  'kravchenko@e-pro74.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с директором. Пока проектов нет. но будут иметь нас в ввиду. отправил кп',
  '2025-06-16',
  '2025-06-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГО-ИМПУЛЬС +"',
  '2724091687',
  NULL,
  NULL,
  'smakova@energoimpulse.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с Еленой. есть хороший контакт.',
  '2025-06-17',
  '2025-06-17'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПК ЭЛЕКТРУМ"',
  '6315597656',
  NULL,
  '88462020037',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил с ларисой. замотал ее. будет отправлять заявки',
  '2025-06-18',
  '2025-06-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ " НИИЭФА - ЭНЕРГО "',
  '7817035596',
  NULL,
  '+78127790121',
  'info@nfenergo.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил со снабженкой. была не в настроении. попросила кп. перезвонить завтра.',
  '2025-06-18',
  '2025-06-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АКЦИОНЕРНОЕ ОБЩЕСТВО "ПОДОЛЬСКИЙ ЗАВОД ЭЛЕКТРОМОНТАЖНЫХ ИЗДЕЛИЙ"',
  '5036003332',
  NULL,
  '84957980046',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил. девушка в отпуске до 1 июля',
  '2025-06-19',
  '2025-06-19'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '5249058696 АО ''НИПОМ''',
  NULL,
  NULL,
  '88001004344',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Не дозвонился до начальника. пробовать завтра',
  '2025-06-19',
  '2025-06-19'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭЛЕКТРООПТИМА"',
  '1659161058',
  NULL,
  '88432101515',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с начальником снабжения. контакт хороший. скину кп на почту',
  '2025-06-19',
  '2025-06-19'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'михайловск ставрополь',
  NULL,
  NULL,
  '88652315646',
  'stemk@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  '',
  '2025-06-19',
  '2025-06-19'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ИЗВА"',
  '2116491707',
  NULL,
  '88354025474',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с закупщицей. Пока заявок нет. Отправил кп',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '''ЗАВОД ''СИБЭНЕРГОСИЛА''',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не берут',
  '2025-06-20',
  '2025-06-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ЭЛЕКТРОФФ-ИНЖИНИРИНГ"',
  '7726590962',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'сказать в отдел закупок. в понедельник',
  '2025-06-20',
  '2025-06-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '3702015155 ''СПЕЦЭНЕРГО''',
  NULL,
  NULL,
  '+78122450760',
  'info@specenergo.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'сказать в отдел закупок. поговорил. рассматривают предложение',
  '2025-07-01',
  '2025-07-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЗИТ"',
  '2115905070',
  NULL,
  '88003332358',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'звонил 3.07. выбил номер снабжения. пока не получил обратную связь',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОЭРА"',
  '7817331267',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'перевели и сбросили. перезвонить',
  '2025-07-01',
  '2025-07-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "НПП ЭЛТЕХНИКА"',
  '7811687676',
  NULL,
  '88123299797',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Никита Евгеньевич. Отправил кп. созвониться на след неделе',
  '2025-07-01',
  '2025-07-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ПРОГРЕСС"',
  '5037004040',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ЭТЗ "ЭНЕРГОРЕГИОН"',
  '1832104733',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  '',
  '2025-07-02',
  '2025-07-02'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ЭЛЕКТРОНМАШ"',
  '7814104690',
  NULL,
  '88127021262',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с закупщицей очень хорошо. Скинет заявку',
  '2025-07-02',
  '2025-07-02'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПП ШЭЛА"',
  '7128014313',
  NULL,
  '+79207691229',
  'omtc@shela71.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'все поставщики расписаны на год. была не в настроении. перезвонить через пару недель.',
  '2025-07-02',
  '2025-07-02'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '7722286859 ООО СК ''БЕТТА''',
  NULL,
  NULL,
  '84955974115',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'снабженка не могла говорить. перезвонить днем.',
  '2025-07-09',
  '2025-07-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЗАВОД ЭЛПРО"',
  '3663146899',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не было на месте спеца',
  '2025-07-10',
  '2025-07-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ПКФ "ЭЛЕКТРОЩИТ"',
  '3663048933',
  NULL,
  '84732394600',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'ольга скинула трубку перезвонить. Поговорил со снабжением 15.07.2025. Скинул кп. Рассматривают предложение.',
  '2025-07-10',
  '2025-07-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ИНИЦИАТИВА"',
  '7716050936',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил со снабженцем. отправил кп',
  '2025-08-21',
  '2025-08-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ФИРМА "ПРОМСВЕТ"',
  '5262046636',
  NULL,
  '+78314669514',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с коммерческим директором. интересно но говорит про нац режим.',
  '2025-09-03',
  '2025-09-03'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "КЭР-ИНЖИНИРИНГ"',
  '1658099230',
  NULL,
  '88432678777',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с коллегой Айрата.Он сказал что посмотрит кп. перезвонить завтра',
  '2025-09-03',
  '2025-09-03'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭЛЕКТРОПРОФИ"',
  '5407222077',
  NULL,
  '83833630263',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'скинул кп на потчу',
  '2025-09-08',
  '2025-09-08'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭЛЕКТРОСТРОЙ"',
  '3257028275',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'отправил кп. пока не звонил',
  '2025-09-09',
  '2025-09-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО КОМПАНИЯ "ИНТЕГРАТОР"',
  '7604175817',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'отправил кп на почту',
  '2025-09-09',
  '2025-09-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ЭЛЕККОМ ЛОГИСТИК"',
  '2130133291',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'отправил кп. закуп не ответили.',
  '2025-09-09',
  '2025-09-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «РИМ-РУС».',
  '6234126190',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'у них сидит менеджер, который отмсматривает заявки и связывается с поставщиками. будут иметь нас ввиду.',
  '2025-09-10',
  '2025-09-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОТРАНЗИТ"',
  '5404079654',
  NULL,
  '83843925050',
  'voronina@nken.org',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил с ольгой. закупают только энергоэффективные трансформаторы. Площадка сбербанк АСТ. участие бесплатное. Условия договорные.',
  '2025-09-11',
  '2025-09-11'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '8911033894 АКЦИОНЕРНОЕ ОБЩЕСТВО ''ПУРОВСКИЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ''',
  NULL,
  NULL,
  '83499765212',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Валера в отпуске до моего др. набрать позже',
  '2025-09-11',
  '2025-09-11'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНСИ"',
  '2309132239',
  NULL,
  '88612506768',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'пока не дозвон. человека не было на месте.',
  '2025-09-11',
  '2025-09-11'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АКЦИОНЕРНОЕ ОБЩЕСТВО "ТЕПЛОКОММУНЭНЕРГО"',
  '6165199445',
  NULL,
  NULL,
  '742899@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'звонил в коммерческий отдел. сказали будут скидывать заявки',
  '2025-09-11',
  '2025-09-11'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭЛЕКТРОКОНТАКТ"',
  '6311174120',
  NULL,
  '+79277886652',
  'info_elkont@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'поговорил со старым. хорошо пообщались. Потенциал',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭЗОИС-УРАЛ"',
  '6670316434',
  NULL,
  '83433630593',
  'info@ezois-ural.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Поговорил с денисом второй раз. Попросил актуальный прайс. скинул кп Рамы. Жду обратку',
  '2025-09-16',
  '2025-09-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭТП"',
  '6671408085',
  NULL,
  '+73433834362',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Не дозвонился до Игоря. скорее всего, добавочный 135 но не факт. пробовать еще. 18.09.2025. Поговорил с Игорем. Работают с Россетями. пробить не вышло.',
  '2025-09-16',
  '2025-09-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЗАО "РЕКОНЭНЕРГО"',
  '3666089896',
  NULL,
  '+74995506043',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не дозвонился',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОКАПИТАЛ"',
  '5402462822',
  NULL,
  '+73832003000',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  '16.09.2025 не дозвон. 17.09.2025 Познакомился с Татьяной. рассматривают кп',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ЭНЕРГОТЕХПРОЕКТ"',
  '6319171724',
  NULL,
  '78469753666',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'интересная компания, но не дозвонился до отдела закупок.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Импульс»',
  '6658394193',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'не дозвон',
  '2025-09-17',
  '2025-09-17'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Самара ВЭМ',
  NULL,
  NULL,
  '88462601947',
  'sev@samaravem.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_MAGEL_ID,
  NULL,
  'Работал с мужиком. он теперь там не работает. Отвечает Елена',
  '2026-03-23',
  '2026-03-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Электростроймонтаж»',
  '4632061580',
  NULL,
  NULL,
  'esm-pol@energo.sovtest.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-28',
  'Не дозвон, КП отправил на почту. / 29.04.25 - через секретаря связь с артемом, попросил информационное, обещал завтра скинуть заявку / не доходят сообщения! / 14.05.25 секретарь дал 2 почты закупщика Артема, при звонке не был на месте / все равно письма не доходят! / 20.05.25 - дозванился до Артема, актуализировал его почту, заявок нет говорит /',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '«Липецкэлектро»',
  NULL,
  NULL,
  '+74742227722',
  'domornikov_e@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-03-20',
  'Вышел на закупщика Юрий, попросил инф письмо./ 23.04.25- магел звонил, повторное коммерческое/ 29.04.25 - Алик - запросы есть внес в базу поставщиков / 14.05.25 - Юрий говорит мало заказов, освежил КП /',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "КАСКАД-ЭНЕРГО"',
  '4028033363',
  NULL,
  NULL,
  'secretar@kenergo.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил КП Герасимову / 28.04.25 - звонок Герасимову, не ответ, КП на почту / 14.05.25 -  нет на месте, ответила марина, наш товар интересен, попросила КП, сказала будут отправлять заказы / 15.05..25 - письмо не доставлено герасимову, надо с ним созваниться / 20.05.25 - Герасимов не ответ, все ссылаються нанего /',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ИНТЭКО"',
  '7104018870',
  NULL,
  NULL,
  'energia@inteko-tula.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-15',
  '15.04Отправил КП / 28.03.25-не дозвон / 21.05.25 - актуализировал номер, надо прозвонить /',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ФЕНИКС-ЭНЕРГИЯ"',
  '7736273017',
  NULL,
  '+79252008042',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-03-20',
  '/20.03звонокРаботают с атестованными в россетях/ 28.04.25 - не дозвон. Серт нужен - Алик \',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '«ЭМПИН»  7743910877 Москва',
  NULL,
  NULL,
  '+74998423923',
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-03-20',
  '/Тяжело идет на контакт, отправил кп /23.04.25 магел звнок- тяжело идет но пробиваем/Короче Артем его зовут но он ни разу не закупщик надо зайти с иторией чтобы перевели на закупщика!!!! - завтра на брать- Алик 29.04 c Артемом бесполезно говорить он вафля! / 21.05.25 - артем запросил КП /',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''ЭМС''   7810241335 Санкт-Петербур',
  NULL,
  NULL,
  '88123884055',
  'info@electromontazh.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил КП / 23.04.25-не ответ /28.04.25 - ответил вредный секритарь, попросил информационное письмо / 29.04 не дозвон - алик',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЗАО ''КАПЭ''  6911004716 Тверь',
  NULL,
  NULL,
  '+79607042111',
  'info@konenergo.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил КП / 28.04.25 - не ответ, повторное КП / не дозвон - алик 29.04',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''АСМ''   3250519725 Брянсск',
  NULL,
  NULL,
  NULL,
  'office@acm32.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил кп / 28.04.25 - не ответ, повторное КП на почту / номер не досутпен 29.04 алик',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ИК СИТИЭНЕРГО"',
  '7720748931',
  NULL,
  '84957802200',
  'info@cityengin.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил кп / 28.04.25 - секретарь попросил инф письмо на снабжение / сказали отдел снабжения свяжется, если нет придумать историю с курьером',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "КАТЭН"',
  '7720674630',
  NULL,
  '+74953692211',
  'office@caten-company.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил кп / 28.04.25 - не ответ, повторное КП / 14.05.25 - не ответ /',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПЕТЕРБУРГ-ЭЛЕКТРО"',
  '7804339445',
  NULL,
  '+78127750617',
  'info@peterburg-electro.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил КП / 28.04.25 - не ответ, КП повторно на почту / 14.05.25 - не ответ / 15.04.25 - не ответ / 20.05.25 - не ответ /Секретярь соединяет но номер не ответил',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПЭС"',
  '7814677411',
  NULL,
  '+78123863333',
  '3863333spb@mail.ru',
  'http://p-el-s.ru',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил КП / 29.04.25 - не интересно работают на довальчиском сырье ( Алик это пиздабольский отмаз?)  / 20.05.25 - Секретарь попросила КП /',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "РУСЭЛ"',
  '5256149506',
  NULL,
  NULL,
  'info@rus-el.org',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-03-18',
  'Не дозвон/ не дозвон-20.03.25 / 14.05.25 - не дозвон /15.05.25 - не отвечают / 20.05.25 - не ответ /',
  '2025-03-18',
  '2025-03-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЦЕНТРЭЛЕКТРОМОНТАЖ"',
  '3663049140',
  NULL,
  '84732006546',
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил кп / 14.05.25 - попросили КП на почту / 15.05.25. - закупщицу зовут Дарья, сказала подстанции производят сами, трансформаторы интересны / 20.05.25 - секретарь соеденял с дарьей, ответила Татьяна, заявок нет, попросила КП на почту / ИСПОЛЬЗУЮТ РЕДКО ТРАНСЫ',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Эйч Энерджи Трейд"',
  '2128010302',
  NULL,
  '88005001616',
  'info@energy-h.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-15',
  'Отправил КП/ тут секретарь сложный надо какие то данные предоставить лиретора пробить по инн, вытаскивать номер закупщика / 20.05.25- секретарь запросил письмо КП, перезвонить 23.05.25 / 11,08,25-секретарь говорит отправь кп если интересно то свяжуться',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭЛЕКТРОГАРАНТ"',
  '7708783560',
  NULL,
  '+79000146645',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-03-04',
  'Рам есть контакт. Максим +7-963-154-62-84 (надо доработать )  / 14.05.25 - не ответ / 15.05.25- -Он сказал только атестованные в россетях поставляем /',
  '2025-03-04',
  '2025-03-04'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭНЕРГО-ДОН''',
  NULL,
  NULL,
  '+78632017884',
  'energo-don@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-03-20',
  'Профильная компания/ 01.04 звонок, отправилКП / 29.04.25 - секретарь пытался соединь с отделом закупок, никто не ответил, попросила перезвонить после празников / 14.05.25 - наш товар редкий, Ольга закупщик запросила КП /',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОМИКС"',
  '3906264262',
  NULL,
  NULL,
  'info@energomiks39.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-10',
  'Отправил КП / 15.05.25 - ответил секретарь, говорит не интересно, но еомпания профильная, возможно не правильно поняла /Короче тут сказали свяжутся серкетярь, попробую выйти на закупки - алик 22 мая',
  '2025-04-10',
  '2025-04-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Энергоспецснаб"',
  '7701112033',
  NULL,
  '84957866964',
  'mail@energossnab.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-15',
  'Отправил КП / 29.04.25 - не ответ / 15.05.25 - не ответ /',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «РСТ-ЭНЕРГО»',
  NULL,
  NULL,
  '88005511656',
  'sale@rst-energo.com',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-03-20',
  'Вредный секретарь, отправил КП / 14.05.25 - не ответ, повторное КП /нет ответа алик 22 мая',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ПРП "Татэнергоремонт"',
  '1661009491',
  NULL,
  '+78432918669',
  'office@tatenergo.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-15',
  'Отправил КП / 15.05.25 - ответил секритарь, закупают через площадку на сайте tatenergo.ru, нужно найти выход на закупщика /',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО РЕНОВАЦИЯ',
  NULL,
  NULL,
  '+78124540224',
  'office@renovationspb.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-03-10',
  'Отправил КП / 15.05.25 - говорит не пользуеться спросом наша продукция, пиздит на сайте другая инфа /',
  '2025-03-10',
  '2025-03-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Энергосервис',
  '6215016322',
  NULL,
  NULL,
  'info@energo62.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-15',
  '/ 15.05.25 - Связался с Николаем на сотовый, попросил КП на почту / 20.05.25 - николай был не в настроение, разговор не пошел, не помнит о нас /',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Техносервис»',
  NULL,
  NULL,
  '88126121201',
  'info@technoservis.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-18',
  'Отправил КП / 15.05.25 - Секретарь попросил КП / 20.05.25 - позвонить 21.05.25  Юлии Юрьевне 8(812)612-12-02 /',
  '2025-04-18',
  '2025-04-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Завод БКТП»',
  '4710028086',
  NULL,
  '88123202036',
  'office@zpuerus.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  NULL,
  'не актуальный номер',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Минимакс',
  '7810216924',
  NULL,
  '+78122446636',
  'minimaks@minimaks.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-28',
  'Профильная компания, запросили КП. / 15.04.25 -  нужно искать закупщика / 22.05.2025 - не ответ, это интернет магазин /',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Энерком-строй»',
  '2901089400',
  NULL,
  NULL,
  'info@enercom29.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-28',
  'Занимаються строительством ЛЭП. отпрвил КП / 15.05.25 - секретарь говорит снабженцы отсутствуют на месте, поросила КП на почту / пробил секретаря, постоянно пиздит нет снабженце, снабженец ответил сказал не интерестно и бросил трубку /',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО Элстар',
  '3255054223',
  NULL,
  NULL,
  'elstar06@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-04-28',
  'В основном низковольтное, высоковольтное редко, отправил КП.',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО Строй-Энерго',
  '5751200700',
  NULL,
  NULL,
  'st-energo57@yandex.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-04-28',
  'Наши изделия используют редко, запросили информационное письмо.',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Резерв-Электро 21 век"',
  '7703663861',
  NULL,
  '+74952313367',
  'rezel@rezel.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-04-28',
  'Профильная компания запросили информационное письмо. / 15.05.25 - секретарь связал с закупщиком, просят реестр минпромторга, изделия интересны, надо общаться / 22.05.2025 - Григорий говорит нет заказов, залечил его, просит звоонить переодически /',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО СТКОМ',
  '2634076606',
  NULL,
  NULL,
  'ctkom@mail.ru',
  'https://tsm26.ru',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-04-28',
  'Грубят, наш клиент, попросили информационное письмо.  / 15.05.25 - не ответ /',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО НПЦ «Электропроект М»',
  '1326183263',
  NULL,
  NULL,
  'elektropro@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-04-28',
  'Берут наш товар мало, попросили информационное письмо.',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ЭЛЕКТРО',
  '7610080930',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-04-28',
  'Запросили информационно письмо. / 15.05.25 - владимир не на месте/ 22.05.2025 - ответил Александр, у них торговая организация, говорят что внесли нас в список поставщиков, при звонке узнают Рамиля, заявок пока нет, долбить его не часто /',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «ТехМир» 1841084642 Ижевск',
  NULL,
  NULL,
  '89992812290',
  'zakaz@tm-ktp.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-14',
  '/Не дозвон, КПотправил на почту. / 02.06.2025 - Поросили КП на Сергея/',
  '2025-05-14',
  '2025-05-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭнергоТехСервис'' 1840031750 Ижевск',
  NULL,
  NULL,
  NULL,
  'zakup@18ets.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-14',
  'Не дозвон, КПотправил на почту. / 02.06.25- не дозвон, /',
  '2025-05-14',
  '2025-05-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «БЭСК Инжиниринг»  0275038560 Уфа',
  NULL,
  NULL,
  '83472693024',
  'office@besk-ec.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-05-14',
  '/Приняли письмо, секретарь оправила начальнику, просила связаться 16.06.25 /',
  '2025-05-14',
  '2025-05-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО «НПП ЭНЕРГИЯ».',
  '7720613010',
  NULL,
  '+74997851007',
  'sales@npp-energy.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-15',
  'не ответ, КП на почту /',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"Объединенная Энергия"',
  '7720097038',
  NULL,
  '+74955444647',
  'jp@jpc.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-15',
  'Секретарь пытался соеденить с отделом закупок не вышло, отправил КП на почту / 22.05.2025 - серетарь не смогла соеденить с отделом закупок не ответ /',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''СИСТЕМОТЕХНИКА'' «Дженерал Пауэр» 7714826109',
  NULL,
  NULL,
  '74959891816',
  'dgu@sstmk.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-15',
  'Ответил секретарь, попросила КП для ознакомления. / 15.05.25 - секритарь прислал на почту что мы молодая компания и они нас боятьс, вопрос на контроле у Магела / 22.05.2025 - анна секретарь напиздела что не берут наш продукт /',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО «ЭНЕРГОСЕРВИС»',
  '5902131473',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-19',
  '/ не дозвон,КП на почту/',
  '2025-05-19',
  '2025-05-19'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЭнергоТренд',
  '6658491415',
  NULL,
  '+73433821913',
  'info@entrend.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ Профильная компания, секретарь запросил КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ПРОГРЕССЭНЕРГО'' 2130065323 Чебоксары',
  NULL,
  NULL,
  NULL,
  '104@progenerg.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ Профильная компания, секретарь запросил КП на почту / 22.05.2025 - ответил павел закуп, готовы расмотреть нашу продукцию под выйгранные торги, запросил КП /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГО ЦЕНТР"',
  '3328492856',
  NULL,
  '+79209334447',
  '33energo@mail.ru',
  'https://cenergo.ru/contacts.html',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ Профильная компания, секретарь запросил КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'л',
  NULL,
  NULL,
  '+74953749699',
  'info@unenergo.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ в основном низвольтное оборудование, наше редко берут, отправил КП /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Энерго Пром Сервис"',
  '5053025953',
  NULL,
  '+74965742848',
  'infoeps@eps-group.ru',
  'https://el-eps.ru/ru/contacts',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ секретарь запросил КП /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ЭНЕРГОСЕРВИСНАЯ КОМПАНИЯ ЛЕНЭНЕРГО"',
  '7810846884',
  NULL,
  '+78124490236',
  'office@lenserv.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ не ответ, КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОКОМПЛЕКТ"',
  '7734362487',
  NULL,
  '+74957999013',
  'enk7250415@yandex.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ не ответ, КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ПКФ "МЕТЭК-ЭНЕРГО"',
  '5260158510',
  NULL,
  '88312152512',
  'cable@metek-energo.ru',
  'http://metek-energo.com/contacts/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ профильная компания, запросили КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Энергопоставка"',
  '5003037311',
  NULL,
  NULL,
  'info@energopostavka.com',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ не ответ, КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Энергосистемы»',
  '5044089069',
  NULL,
  '84951780118',
  'zayavka@e-systems.su',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ секретарь поросил КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "МНПО "ЭНЕРГОСПЕЦТЕХНИКА"',
  '5024014330',
  NULL,
  '+74959212229',
  'zakaz@spectech.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ производители дизель станций, попросили КП /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭнергоСоюз"',
  '1840004147',
  NULL,
  NULL,
  'info@smu-energo.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ не ответ, КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ПИК "ЭНЕРГОТРАСТ"',
  '7709153722',
  NULL,
  '+74956020960',
  'energotrust@energotrust.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ не ответ, КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «ЭНЕРГО СТРОЙ»',
  '7813479840',
  NULL,
  '+78126102112',
  '6102112@bk.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ секретарь связала с Александрой, она попросила КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОКОМ"',
  '3257025820',
  NULL,
  NULL,
  'energokom32@mail.ru',
  'https://ek32.ru/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ не ответ на основной КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ТД "ЭнергоПромМаш"',
  '7706596941',
  NULL,
  '+74956798233',
  'Info@td-epm.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ не ответ на основной КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Энергостройуниверсал"',
  '2635095256',
  NULL,
  NULL,
  'info@energosu.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-20',
  '/ Альберт нач отдела снаб, попросил КП на почту /',
  '2025-05-20',
  '2025-05-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Энергоиндустрия»',
  '7702810351',
  NULL,
  '+74957212910',
  'sales@energo-ind.su',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/  Попросили КП на почту /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Сельхозэнерго"',
  '2104000577',
  NULL,
  '+79003333020',
  'vur_she@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ не ответ, отправил КП на почту /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "БЭЛС-Энергосервис"',
  '5012026637',
  NULL,
  '84985207963',
  'bes04@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ не ответ КП на почту /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «МОНТАЖЭНЕРГОПРОФ»',
  '7810762585',
  NULL,
  '+78123368767',
  'mep-prof@mail.ru',
  'http://www.montazhenergoprof.ru/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ Ксения секретарь - говорит нет заказов. Протолкнул ей КП на почту /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОАЛЬЯНС"',
  '7839427766',
  NULL,
  '+78123850845',
  'info@eaenergo.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ ответил Павел, попросил КП на расмотрение / 02.06.25 - не ответ/',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Стандартэнерго"',
  '7717735629',
  NULL,
  '+74956162028',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ Нужны бетонные КТП и атестация в россети /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Альянс-Энерджи»',
  '7709843116',
  NULL,
  '+74996491269',
  'info@al-ng.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ производят генераторы, запросили кп на тех отдел /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО "ЭНЕРГОПРОЕКТ-ИНЖИНИРИНГ"',
  '7725592815',
  NULL,
  '+78469753666',
  'info@etpsamara.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ Клиент Анара, держать на контроле /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОКОМПЛЕКТ КРЫМ"',
  '9102011960',
  NULL,
  NULL,
  'telecom.help@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ Яна секретарь запросила КП /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОГРУПП"',
  '9705088145',
  NULL,
  '+74959091650',
  'info@en-gr.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ профильная компания, запросили КП на почту /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ТК ''ЭНЕРГОКОМПЛЕКС'' 7810397798 Питер',
  NULL,
  NULL,
  '88125000809',
  'info@nrg2b.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ кузнецов Андрей закупщик, отправил КП, его не было на месте /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПСК "Тепло Центр Строй"',
  '7727155923',
  NULL,
  '+74957875027',
  'tcs@tcs-group.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ секретарь запросил КП организация профильная /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОТРЕСТ"',
  '7725346376',
  NULL,
  '74957481720',
  'info@energo-trest.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ не ответ, КП на почту /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Гарантэнерго"',
  '7702350129',
  NULL,
  '+74956020282',
  'info@garantenergo.su',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ не ответ, КП на почту /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО Связь Энергострой 2801246747  Благовещенск',
  NULL,
  NULL,
  '+79244999444',
  'doc@ses-dv.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-22',
  '/ ответил Георгий, попросил КП на ватсап/',
  '2025-05-22',
  '2025-05-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО “ССМНУ-58”',
  '5045019586',
  NULL,
  '84966474808',
  'SSMNU-58@ssmnu-58.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-22',
  '/ не ответ, КП на почту /',
  '2025-05-22',
  '2025-05-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "НОРДГРИД"',
  '7842489681',
  NULL,
  '+78124548746',
  'mail@nordgrid.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-22',
  '/ответил секретарь, проф организация, запросила КП на Вадима /',
  '2025-05-22',
  '2025-05-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «КНГ - ЭНЕРГО 3662287110 воронеж',
  NULL,
  NULL,
  '+74732106969',
  'office@kngenergo.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-22',
  '/ не ответ, КП на почту / 14.07.25 - закупщик грубит не заебывать часто /',
  '2025-05-22',
  '2025-05-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Центр Инжениринг»',
  '2373002283',
  'Краснодар',
  '+78619910097',
  'info@centringen.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-06-10',
  '/Через секретаря связался с менеджером Антоном, в ходе разговора он понял значемость и передаст КП директору, сказал директор свяжеться с нами/ 10.06.25 -  попросил позвонить 16.06.25 -14:00 / 16.06.25 - попросил набрать 23.06.25 / 25.06.25 - Антон попросил КП на ватсапп и пошол к диру на разговор / Просят атестацию в россети /',
  '2025-06-10',
  '2025-06-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '''ГРУППА КОМПАНИЙ ПРОФИТРЕЙД''',
  NULL,
  'Москва',
  '+74994505399',
  'info@profitreid.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-06-10',
  '/ отправил КП не прошол секретаря / 22.07.25-секретарь говорит наше предложение не актуально /',
  '2025-06-10',
  '2025-06-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭМКОМ''  7802335484',
  NULL,
  'Питер',
  '+78123894114',
  'sale@emkom.spb.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-06-17',
  '/ пока не требуеться / 22.07.25 - пока не требуеться / 11.08.25 - пока нет заказов, набрать 11.09.25 /',
  '2025-06-17',
  '2025-06-17'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Завод „Энергетик“',
  NULL,
  'Уфа',
  '+73479526650',
  'enzavod@mail.ru',
  'http://enzavod.ru',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-06-21',
  '/ секретарь попросила КП, и перезвонить 04.07.25 позвать виталия игоривича / 04.07.25.- Виталий говорит берут масло до 630ква, интерестно что когда будет у нас на складе, взял мой номер / 11.08.25 - Виталий не ответил / 08.09.25- запросили цены, набрать 15.09.25 / Виталий говорит интерестно на складе, ждать долго, разговор не о чем, набрать в конце сентября /',
  '2025-06-21',
  '2025-06-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО «МЕРИНГ ИНЖИНИРИНГ',
  NULL,
  'С-Петербург',
  '88126004535',
  'info@meringe-pro.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-06-23',
  '/ Вышел на нач закуп Лев, заинтересовал, взял личный номер, отправил инфу в ватсапп / 30.06.25 - Лев помнит про нас, сейчас нет заказов, ждет новые проекты / 10.07.25 - Лев помнит про нас, ждет заказы / 09.09.25 - написал ему в ватс ап сросил актуальные заказы / 16.04.26 - пока нет действующих проектов /',
  '2025-06-23',
  '2025-06-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '«Озёрский завод энергоустановок»',
  NULL,
  'Челябинск',
  '+73513073363',
  'sales@ozeu.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-06-25',
  '/ попросили КП на отдел снабжения для Екатерины / 03.07.25 - екатерина не получила наш КП, попросила повторно,  перезвонить 25.07.25  / 11.08.25 - заявок нет, перезвонить в начале сентября / ПИЗДИТ ЧТО НЕ ИСПОЛЬЗУЮТ /',
  '2025-06-25',
  '2025-06-25'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ТД ''ПРОМЫШЛЕННОЕ ОБОРУДОВАНИЕ''',
  NULL,
  'Москва',
  '84952696970',
  'info@td-po.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-06-28',
  '/Секретарь передаст письмо генеральному директору/ 16.06.25 - не пробиваемый секретарь, просит КП / 25.06.25 - не дозвон / 30.06.25 - секретарь не помнит про нас, прислал на почту секретаря КП (дохлый номер) / 22.07.25 - не заинтересовало /',
  '2025-06-28',
  '2025-06-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «АС-ЭНЕРГО»',
  NULL,
  'Краснодар',
  '+78612313131',
  'info@as-energo.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-01',
  '/ не пробил, КП отправил / 02.07.25 - секретарь пыталась направить в отдел снабжения не ответ / 03.07.25 - Попал на николая, ему интерестно, дал свой сотовый. отправил инфу на ватсапп / 14.07.25 - цена дорогая на масло, про нас помнит, не задрачивать его /',
  '2025-07-01',
  '2025-07-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО НПП «220 Вольт»',
  NULL,
  'УФА',
  NULL,
  'pto@220ufa.com',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-03',
  '/ отправил КП на ватсапп / 25.08..25 - Елена не ответ /  ответила Эльмира, Елена в отпуске до 15.09.25 /',
  '2025-07-03',
  '2025-07-03'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЗАО ''ЭЛСИЭЛ''',
  NULL,
  'г.Москва',
  '+74957211151',
  'info@elsiel.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-06',
  '/ попросили инф письмо и перезвонить / 10.07.25 - отдел закупок запросил повторно КП, по необходимости свяжуться сами / 25.08.25 - не нужно /',
  '2025-07-06',
  '2025-07-06'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Энергии Технологии»',
  NULL,
  'Москва',
  '+74995503337',
  'info@ener-t.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ Секретарь попросила инф письмо на гл инженера / 25.06.25 - Шитов расмотрел КП все понравилось попросилконтактные данные, говорит пока нет заказов, по необходимости свяжеться / 11.08.25 - Павел в отпуске до 25.08.25 / Павел говорит нет заказов, набрать в след году (мажеться урод) /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''СНАБЭНЕРГОРЕСУРС''',
  NULL,
  'Краснодар',
  '+78612403785',
  'info@snabenergo23.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ Переодически его задрочил/ добавил мой номер в ЧС /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «ЭНЕРГОГРУПП»',
  NULL,
  'Тверь',
  '84822785474',
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/Антон, закуп, отмахивался россетями, залечил его и отправил КП / 14.07.25 - не ответ / 05.08.25 - не ответ /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО “Энергопроф”',
  NULL,
  'Москва',
  '+74952873383',
  'info@enprof.net',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/Секретарь попросил КП и презвонить в 16:00 по мск Владимиру Анатольевичу / 25.06.25 - Состоялся диалог с Владимиром, заинтересован, будет присылать заказы / 14.07.25 - Владимир не на месте / 25.08.25 - не дозвон /  Владимир говорит пока нет заявок на трансы и ктп, основное это щитовое оборудование набрать 19.09.25  /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ПКФ''ЭЛЕКТРОКОМПЛЕКС''',
  NULL,
  'Екатеринбург',
  '+73433790041',
  'zakaz@uralenergoteh.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ не представился но есть интерес, попросил КП с ценами/ 16.05.25 - о нас помнит, ждет заказы, напоминать о себе переодически / 14.07.25 - Андрей просит набрать 16.07 / 11.08.25 - скоро будет запрос / набрать 17.09.25 я затупил не правельно шашел /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '''РЕСУРССПЕЦМОНАЖ''',
  NULL,
  'Петербург',
  '+78129509909',
  'resurs.cm@gmail.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/монтажная организация, попросил кп на личный номер ватсапп, перезвонить 27.06.25 / 30.06.25 - Игорь говорит не пока заказов, просил набрать 07.07.25 / 10.07.25 - игорь попросил перезвонить 11.07.25 в 17:00 / 14.07 - пока нет заказов, Игорю интерестно представительство в СПБ, думает в тчечении недели и должен набрать до 18.07.25 / 22.07.25 - не ответ / 11.08.25 - нет заинтересованости, не знает кому предложить /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Завод производитель трансформаторных подстанций «МИН»',
  NULL,
  'Петербург',
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ не ответ, КП на почту / 02.07.25 - попросили КП на почту и перезвонить 04.07.25 / 04.07.25 - не ответ / 14.07.25 - КП не получили отправил повторно (набрать 23.07) / 24.07.25- сказали не актуально /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '«Мосэлектрощит»',
  NULL,
  'Москва',
  '+74957874359',
  'info@moselectroshield.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ отдел закупок не отвечает / 02.07.25 - не овет / 14.07 - не ответ / 09.09.25 - не ответ /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''МЭК''',
  NULL,
  'Ставрополь',
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ отправил КП, не очень интерестно / 09.09.25 - не ответ /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Электрощит»-ЭТС',
  NULL,
  'Самара',
  '+78462763955',
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ закуп евгений, норм диалог, попросил КП / 14.07.25 - не дозвон / 22.07.25 - рынок стоит. пока не актуально. перезвонить 20.08.25 / 25.08.25 - заявок нет пока набрать в начале сентября / 09.09.25 - не ответ /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''Ринэко''',
  NULL,
  'новосиб',
  '83833630263',
  'sales@rineco.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ не ответ, КП на почту / 11.08.25 - запрос КП / 25.08.25 - секретарь не смог соединить с закупом, никто не ответил, попросила инф письмо на почту / 08.09.25 попросили инф письмо на закупки /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''КИМ''',
  NULL,
  'Мурманск',
  NULL,
  'info@kim51.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ интересны КТП, пока нет заказов / 08.09.25 - тока пришла с отпуска не заявок набрать после 20.09.25 /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''Комплексные энергетические решения''',
  NULL,
  'Москва',
  '84959266314',
  'info@energy-solution.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ секретарь получил КП / 14.07.25 - компания монтажники, работы нет, просит прозванивать раз в месяц /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭЛЭНЕРГО''',
  NULL,
  'Москва',
  '+74994002938',
  'info@el-energo.com',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-08',
  '/ Запросил КП / 14.07.25 - Иван не получил КП, дал свой номер и КП на ватсапп / 11.08.25 - Иван не ответ / 08.09.25 - работают с россети, попросил инф письмо на почту, звонить на городской позвать нач закупок, набрать 11.09.25 /',
  '2025-07-08',
  '2025-07-08'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЧЭТА''',
  NULL,
  'Чувашия',
  NULL,
  'cheta@cheta.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ секретарь приняла КП, дала номер отдела закупок / 11.08.25 - Кравченко Игорь Александрович закуп, запросил КП на почту / 08.09.25 - нашли сами китайцев, пока думают, набрать после 20.09.25.',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Электрощит',
  NULL,
  'екатеринбург',
  '+74951222202',
  'info@specenprom.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-10',
  '/ не ответ, отправил КП на почту / 10.07.25 - Секретарь получила КП, перезвонить 15.07.25 / 24.07.25 - решение еще не принято, набрать 30.07.25 / 11.08.25 - не дозвон /',
  '2025-07-10',
  '2025-07-10'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''АС-ЭНЕРГО''',
  NULL,
  'Краснодар',
  '+78612313131',
  'info@as-energo.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-11',
  '/ вышел на закуп Полина, попросила перезвонить 14.07.25 / 14.07.25 - Полина не успела посмотреть КП, попросила позвонить 18.07.25 в первой половине дня / 24.07.25 - не дозвон / 11.08.25 - пока нет заказов, набрать 25.08.25 / 08.09.25 - попросили цены, набрать 16.09.25 /',
  '2025-07-11',
  '2025-07-11'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '«СТРОЙЭНЕРГОСИСТЕМЫ»',
  NULL,
  'Москва',
  '+74995509699',
  'info@sesistems.ru',
  'https://sesistems.ru/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-14',
  '/ Кирил, получил КП  / 11.08.25 -  не актуально /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ПО «Радиан»',
  NULL,
  'Иркутск',
  '83952444522',
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-14',
  '/ Евгений Генадьевичь нач снаб, заинтересован, отправил КП / 14.07.25 - не дозвон ИРКУТСК! / Работает Анар / 16.09.25 -  набрать в конце сентября /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭЛЕКТРОМАКС''',
  NULL,
  'Новосиб',
  '+79130026001',
  'zakaz@electromax-tk.com',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-14',
  '/ Ответил Павел он получил КП и просил перезвонить 15.07.25 / 15.07.25 - говорит рынок стоит, набрать 29.07.25 / 11.08.25 - пока нет заказов, звонить в сентябре / 01.09.25 - перезвонить 04.09.25 /  09.09.25 - пока нет заказов, набрать в конце сентября /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''МАКСИМУМ''',
  NULL,
  'Краснодар',
  '+79673006560',
  'torg_maximum@list.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-14',
  '/ профильная компания, заказы с торгов будут присылать/ 14.07.25 - заинтересовал ивана нашими трансами, он в размышлениях, покажет руководству всю инфу  / 24.07.25 - говорит нет заказов набрать к концу августа / 11.08.25 - не ответ / 08.09.25 - Говорит помнит про нас лучше не названивать /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ТСН''',
  NULL,
  'Питер',
  '+78127183585',
  'tsn@tsn-group.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-14',
  'Рам 04.03 - Профельная компания не получиось обойти секретаря. отправил КП надо прожимать / 14.05.25 - забыли про нас, попросили инф письмо / 20.05.25 -  Секретарь сново попросил КП / 24.07.25 - директор по снабжению в отпуске / 11.08.25 - секретарь не помнит о нас запросила КП, набрать 25.08.25 / 09.09.25 попросила инф письмо, не пробиваемы секритарь, звонить в конце сентября  /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ЕТекс',
  NULL,
  'Башкирия',
  '+73472626755',
  'info@eteh-energo.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-14',
  '/ Эмиль заинтересовался, нужно добивать, набрать 28.07.25 / 11.08.25 - пока рынок стоит, о нас помнит, набрать 25.08.25 / 29.08.25 - Эмиль спросил цену 400ква тмг, сколький тип /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''БТ Энерго'' 7811573630',
  NULL,
  'Питер',
  '89006337786',
  'sale@btenergospb.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-14',
  'Отправил, КП. Берут под торги, нужно прожимать / 09.09.25 - нет заказов /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '(ООО «Челябинский завод «Подстанция») 7451263799',
  NULL,
  NULL,
  '+73517785072',
  'ch-z-p@yandex.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-14',
  '/ Отправил на ватсапп инфу, заказов нет / 09.09.25 - не ответ александр /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО НПК «ТехноПром»',
  NULL,
  '7718289053',
  '+74956460935',
  'infoinfo@texnoprom.com',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-14',
  'Василий попросил КП, и перезвонить 28.07.25 / 09.09.25 - не ответ /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''Управляющая компания ''Уралэнерго',
  NULL,
  'Ижевск',
  '83412700074',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-21',
  '/ Азат запросил инф письмо и перезвонить 24.07.25 / 24.07.25 - пока не интересно, набрать к коцу августа / 29.08.25 - спорили с азатом по цене, запросил прайс, след созвон 10-15 сентября / 09.09.25 - не ответ /',
  '2025-07-21',
  '2025-07-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Инженерный центр «Энергосервис»',
  NULL,
  'Москва',
  NULL,
  'info@ens.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-21',
  '/ Секретарь получила инф письмо / 09.09.25- не ответ /',
  '2025-07-21',
  '2025-07-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ИЦ ЭНЕРГЕТИКИ''',
  NULL,
  'Москва',
  '88007009371',
  'info@ecenergy.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-21',
  '/ инф письмо на почту, проверить рассмотрение / 24.07.25 - если не связались значит нет надобности, набрать в середине августа / 29.08.25 - повторно инф письмо попросили и набрать 5 сентября / 09.09 25 - не помнят про нас, попросили повторное инф письмо /',
  '2025-07-21',
  '2025-07-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ТПК ''ЭНЕРГЕТИЧЕСКАЯ СИСТЕМА''',
  NULL,
  'Москва',
  '84994997572',
  'info@energ-sys.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-21',
  '/ не ответ инф письмо на почту / 24.07.25 - попросили повторное КП, если интерестно свяжуться  /',
  '2025-07-21',
  '2025-07-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ''ОВЛ-ЭНЕРГО''',
  NULL,
  'Москва',
  '+74951349200',
  'ovl@ovl-energo.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-21',
  '/ трудные, инф на почту /',
  '2025-07-21',
  '2025-07-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''Группа Электроэнергетика''',
  NULL,
  'Москва',
  '84959260946',
  NULL,
  'https://elengroup.ru',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-21',
  '/ Работают с россетями, поговорит с начальством набрать  24.07.25 / 24.07.25 - александр дал свой номер отправил ему инфу и видео на ватсапп, сказал обсудит с начальством и перезвонит / 24.07.25 - не заинтересованы, работают с россети /',
  '2025-07-21',
  '2025-07-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ПО ''РосЭнергоРесурс''',
  NULL,
  'Новосиб',
  '+73833181266',
  'rer@rernsk.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-29',
  '/ закуп Михаил запросилинф письмона почту / 20.08.25 - связался с евгением, попросил инфу на ппочту / 01.09.25 - пока нет заказов, набрать 15.09.25 /',
  '2025-07-29',
  '2025-07-29'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО '' ЛЕРОН ''   7803010217',
  NULL,
  'Питер',
  '88126770527',
  'leron.spb@mail.ru',
  'https://leron-electro.ru/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-08-05',
  'Ответил гореев рассул  инфу принял, интерестно, набрать 01.09.25 / 09.09.25 - Сергей занят, набрать 11.09.25 /',
  '2025-08-05',
  '2025-08-05'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭНЕРГО ЦЕНТР''    3328492856',
  NULL,
  'Владимир',
  '+79209334447',
  '33energo@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-08-11',
  '/ запросили КП и набрать 15.08.25 / 08.09.25 - нет заказов /',
  '2025-08-11',
  '2025-08-11'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО РЭСЭНЕРГОСИСТЕМЫ',
  '7804382585',
  'Питер',
  '+78123313714',
  'info@etm-res.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-08-11',
  '/ мария запросила КП на общую почту / 09.09.25 - закуп не ответ /',
  '2025-08-11',
  '2025-08-11'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ВП «НТБЭ',
  NULL,
  'Екатеринбург',
  '+73433857676',
  'info@ntbe.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-08-29',
  '/ ответил Александр, запросил инф письмо / 09.09.25 - пока нет потребности, 22.09.25 /',
  '2025-08-29',
  '2025-08-29'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭНЕРГОСТРОЙМОНТАЖ'' 7203311501',
  NULL,
  'Тюмень',
  '+73452670677',
  'esm@esm-t.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-09-09',
  '/ Владиславу интерестно из наличия, заявки есть постоянно у них, запросил инф письмо, нужно доробатывать,   набрать 15.09.25 /',
  '2025-09-09',
  '2025-09-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭНЕРГОИНВЕСТ''',
  NULL,
  'Ямал',
  '+73499221163',
  'info@89energo.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-09-09',
  '/ Секретарь запросила инф письмо, работают на довальческом, уточнить расмотрение 15.09.25 /',
  '2025-09-09',
  '2025-09-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'РегионСтройКомплект',
  NULL,
  'Иркутск',
  NULL,
  'rsnab@rsktrade.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-06-02',
  '/ не ответ /09.09.25 перезвонила Олеся, интересен Китай, попросила условия и инф письмо /',
  '2025-06-02',
  '2025-06-02'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '''ЭНЕРГ-ОН''',
  NULL,
  'Санкт-Петербур',
  '+78005509738',
  'info@energ-on.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-09-16',
  '/ 16.09.25 - наш товар редкий, основное это щитовое, запрос инф на почту /',
  '2025-09-16',
  '2025-09-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ЭНЕРГО АЛЬЯНС''',
  NULL,
  'Санкт-Петербур',
  '+78124072026',
  'info@ealspb.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-09-16',
  '/ 16.09.25- не ответ, инф на почту / 30.09.25 - не ответ /',
  '2025-09-16',
  '2025-09-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''НПО ''ЛЕНЭНЕРГОМАШ''  7802753273',
  NULL,
  NULL,
  '88126009188',
  'info@npolem.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-09-30',
  '/30.09.25 инф письмо на почту /',
  '2025-09-30',
  '2025-09-30'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ЭТЗ «ИВАРУС»',
  NULL,
  'Челябинск',
  '84994061024',
  'zakaz@iv74.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-06-09',
  '/Алексей закупщик, заинтересован, попросил КП с ценами/ 16.06.25 - Александр Сухоруков, попросил КП, Алексей в опуске / 19.06.25 - прислапли на почту заявку на тсл 3150 / 26.06.25 - Яков мажеться, говорит некогда,прислал на почту запрос от СБ  / 01.07.25 - отправленные пояснения и бизнес карта / 09.07.25 - нет на месте / 14.07.25 - Яков просит позвонит 16.07.25 / 18.07.25 - Яков скинул заявку на сухие трансы, кп отправленно 21.07.25 / 22.07.25 - яков попросил цены на масло от 630 до 2500 ква в ознакомительных целях, задал эмми вопрос по доставке и диллерству / 11.08.25 - не дозвон / 30.09.25 - Яков просит набрать 08.10.25 обсудить конкретику /',
  '2025-06-09',
  '2025-06-09'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЗАО ''Энергомашкомплект''',
  NULL,
  'Пермь',
  '+78612403785',
  'info@snabenergo23.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-06-11',
  '/Вышел на закуп, отправил КП/ Пришла заявка на транс тока, запрос отправил ерболу/ 04.07.25 - не ответ / 11.08.25 - пока нет заказов /',
  '2025-06-11',
  '2025-06-11'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО''Хабаровская горэлектросеть''',
  NULL,
  'Хабаровск',
  NULL,
  'pr@khges.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-05-15',
  '/Входящий запрос тсл 1000 на почту /',
  '2025-05-15',
  '2025-05-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «ЦРЗЭ»',
  NULL,
  'Екатеринбург',
  '+73432789216',
  'CRZE@BK.RU',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ Хороший заход, запросили КП на почту / 14.07.25- Сергей не на месте, набрать 15.07.25 / 22.07.25 - пока нет заказов, но интерестно, скинет на почту пример для просчета / 24.07.25 - отправил каталог / 11.08.25 - прислали опросник на тсл 2000 ответ на почту / 28.08.25 - в ответ на кп прислал запрос на 1250 сухой медь / 30.09.25 - пока нет запросов про нас помнит, сильно не задрачивать /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Энергетический Стандарт»',
  NULL,
  'Москва',
  '+74992862233',
  'info@enstd.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-07-21',
  '/ не ответ инф на почту / 24.07.25 - Александру очень интерестно поставки из китая, дал свой номер и запросил инфу на ватсапп / 09.09.25 - занят на пергаворах / 16.09.25 - интересны от 110 кв, о нас ппомнит сильно не задрачивать, звонок начало октября /',
  '2025-07-21',
  '2025-07-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''РиМтехэнерго''',
  NULL,
  'Новосиб',
  '+73833670542',
  'feedback@rimteh.com',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-05-21',
  '/ Берут наш товар, Евгений попросил КП на почту / 02.06.25 - нет заявок, попросил набрать в конце месяца/  05.08.25.- евгений попросил инфу на ватс апп и обещал заявку / 30.09.25 - попросил почту, есть заказ на ктп /',
  '2025-05-21',
  '2025-05-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Завод инновационных технологий»',
  NULL,
  'Чувашская Республика',
  '88003332358',
  'info@zit21.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-08',
  '/ Попросил КП и перезвонить 08.07.25 / 08.07.25 - в ответ на КП прислал запрос на однофазные трансформаторы / 14.07.25 - не ответ / 20.08.25 - не дозвон /',
  '2025-07-08',
  '2025-07-08'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '«ЭНЕРГОПРОМ-АЛЬЯНС»',
  NULL,
  'Москва',
  '88005004969',
  'office@epatrade.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-07',
  '/ закуп Сергей, плотно поговорили про китай и энергоэфективность .КП отправил/ 19.06 - он не получил инфу про нас, отправил повторно, долго тележили за китай, он пытался навялить что херня / 30.06.25 - Сергей запросил больше информации о трансформаторах, расширенный протокол испытаний (вопрос ерболу) / 10.07.25 - расширенные испытания отправленны, сергей не отвечает на телефон / 14.07.25 - Сергей в отпуске до 25.07.25 / 11.08.25 - мозгоеб про то что трансы не соответствуют ГОСТ, просит набрать 14.08.25 /',
  '2025-07-07',
  '2025-07-07'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «НПО АР-ТЕХНОЛОГИИ»',
  NULL,
  'Москва',
  '+74994508533',
  'info@npoar.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_RAM_ID,
  '2025-07-14',
  '/ Андрей нач снаб, заинтересован в трансах / 30.06.25 - КП на рассмотрении ТЕХ отдела, просил набрать 14.07.25 / 14.07.25 - Андрей говорит тех отдел пока не рассмотрел наше предложение, наберт сам, если долго не выйдет на связь прожать его / 11.08.25 - пока нет заказ, набрать 25.08.25 / 25.08.25 - Андрей запросил 1250 сухой /',
  '2025-07-14',
  '2025-07-14'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «ПКФ «ТСК»',
  NULL,
  'Москва',
  '+78469707135',
  'info@pkftsk.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_RAM_ID,
  '2025-09-16',
  '/ 16.09.25 - не дозвон инф на почту / 30.09.25 - Александр попросил инф на почту / 22.12.25 - прислал запрос на тмг 2500 и 630',
  '2025-09-16',
  '2025-09-16'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭЛСНАБ"',
  '7719612213',
  NULL,
  '+74951375115',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-03-25',
  'Жду опросный лист БКТП. Свяжеться сам Вышел на ЛПР .',
  '2025-03-18',
  '2025-03-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПАРТНЕР ТТ"',
  '5405498048',
  NULL,
  '+73832840244',
  'partnertt@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  '2025-03-20',
  'Отправил после звонка КП на почту. Не прошел секретаря',
  '2025-03-18',
  '2025-03-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "КУБАНЬГАЗЭНЕРГОСЕРВИС"',
  '2309073209',
  NULL,
  '+74812304053',
  'info@kgpes.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Отправил КП на почту . Не прошел секретаря',
  '2025-03-18',
  '2025-03-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "Коксохим-Электромонтаж"',
  '7705975665',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'НЕ ЗАКУПАЮТ',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Солар Системс»',
  NULL,
  NULL,
  '+74951202410',
  'mail@solarsystems.msk.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-03-20',
  'Отправил на имя генерального директора ком перд на почту. Не прошел секретаря',
  '2025-03-18',
  '2025-03-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Инжиниринговая Компания ТЭЛПРО',
  NULL,
  NULL,
  NULL,
  'ssa@telpro-ing.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Отрпавил информацию в whats app. Сказал вышлет пару опросных на подстанции.',
  '2025-03-18',
  '2025-03-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'SciTex Group',
  NULL,
  NULL,
  NULL,
  'project@scitex.group',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-03-20',
  'Продукция интересует. Отправил на почту коммерческое предложение.',
  '2025-03-18',
  '2025-03-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'МУП ЖМЛКОМСЕРВИС',
  NULL,
  NULL,
  NULL,
  'mup@sosnovoborsk.krskcit.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Потенциально могут закупать трансформаторы.',
  '2025-03-18',
  '2025-03-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''СибЭлектроМонтаж''',
  NULL,
  NULL,
  '+79504013681',
  'info@sibem24.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Знают про СВЕРДЛОВЭЛЕКТРОЩИТ. Потербности нет.',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Кайрос Инжиниринг»',
  NULL,
  NULL,
  '+73422999941',
  'perm@kairoseng.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Отправил информацию в отдел снабжения через секретаря. Возможно заинтересуются',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ГК ''НЗО''',
  NULL,
  NULL,
  '88006006621',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-03-20',
  'Перезвонить, потенциально могут закупать',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «СИРИУС-МК»',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://s-mk.spb.ru/kontakty/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Потенциальный клиент, вышел на личный контакт whatsapp, обратится при потребности',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО НПП «Элекор»',
  NULL,
  NULL,
  '89235165183',
  'nppelekor@yandex.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Есть интерес в закупке НОВЫХ трансформаторов. Покупают у энетры и в брянске. ОТПРАВИТЬ КП на почту.',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ооо пкф спектор',
  NULL,
  NULL,
  NULL,
  'pkfspectr@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Дозвонится',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ  ''ЭНЕРГОАСГАРД''  ИНН: 7802536127',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://energoasgard.ru/contacts',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-03-25',
  'Дальний восток, связаться , потеницально могут закупать. Не ответил',
  '2025-03-24',
  '2025-03-24'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Крия Инжиниринг',
  NULL,
  NULL,
  '16521206681',
  NULL,
  'https://kriyaing.pro/page/landing.html?utm_source=yandex&utm_medium=search&utm_campaign=114463800&utm_content=16521206681&utm_term=проектная%20организация&etext=2202.3RbmEO7DxFe6yVtDvonzXDaGI5ssJsAPKR1guzLlGEAsABPl4CxWa2VWeC1AXa5xcGlsbGl3dXVocWtrZ2dxeA.5267d44d3ce96cfcdae8b7af46d345049c244810&yclid=2800577697807073279',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Отправил информацию на почту, переодически есть потребность , можем сработать в будущем.',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Общество с ограниченной ответственностью ''Самур''',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://camyp.ru/contacts/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Не довзонился. Отправил предложение на почту в отдел закупок.',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Акционерное общество ''Дальневосточная электротехническая компания''',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://dv-electro.ru/kontakty',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Написал на почту. Позвонить. Дальний восток.',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО НСК',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://stibiumrus.ru/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Заполнил форму обратной связи. Выслал КП. Можно позвонить днем.',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО МНПП «АНТРАКС»',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://antraks.ru/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Отправил форму обратной связи . Можно позвонить',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО РУСТРЕЙДКОМ',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://rustradecom.ru/contact',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Непрофильно, но участвуют в торгах. Отправил КП. Можно позвонить',
  '2025-03-20',
  '2025-03-20'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Сибтэк»',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://www.sibtek.su/contacts/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-03-26',
  'Направил информацию на почту. Телефон не доступен.',
  '2025-03-24',
  '2025-03-24'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО Дюртюлинские ЭиТС',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  '2025-03-26',
  'ЗВОНИЛ, СКАЗАЛИ ВСЕ ТОЛЬКО ЧЕРЕЗ ТОРГИ. ОТПРАВИЛ КП НА ПОЧТУ',
  '2025-03-24',
  '2025-03-24'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Группа компаний «РИНАКО»',
  NULL,
  NULL,
  '84959873031',
  'bsk@bsk-rinako.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Отправил КП на почту. Не прошел секретаря.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Энергоремонт»',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Закупают только через тендерные площадки. Можно попробовать пробится к ЛПР.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''СТАРТ''',
  NULL,
  NULL,
  '+78312112779',
  'ruslanb4shirov@yandex.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Закупают трансформаторы. Хорошо разбирается в рынке, представился как диллер уральского силового',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ТЭХ''',
  NULL,
  NULL,
  '+74957807218',
  'ooo_teck@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Закупают трансформаторы. На лпр не вышел, но добавили в список поставщиков.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ТРИНИТАС''',
  NULL,
  NULL,
  '+79226327100',
  'ulanov2212@list.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'не закупают',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ИМПУЛЬС"',
  '6658394193',
  NULL,
  NULL,
  NULL,
  'https://ural-impuls.ru/?page_id=12',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Строительно-монтажные работы, потенциально сильный клиент. Не ответил.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПТМ"',
  '6623071272',
  NULL,
  '+79221398098',
  'mr.ptm@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Строительно-монтажные работы, потенциально сильный клиент. Не ответил.',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ПРОИЗВОДСТВЕННО-СТРОИТЕЛЬНАЯ КОМПАНИЯ "ТАГИЛЭНЕРГОКОМПЛЕКТ"',
  '6623051325',
  NULL,
  '+73435215543',
  'tek-nt@inbox.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Используют давальческий материал.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  '"ЭЛЕКТРИЧЕСКИЕ СЕТИ"',
  '0257009703',
  NULL,
  '+73478433041',
  'office@bashenergo.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Закупают через B2B',
  '2025-04-02',
  '2025-04-02'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'Энергопрайм',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://www.energoprime.ru/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Закупают трансы. Можно пробивать. Отправил КП УСТ на почту',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ ''Энерготранзит''',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://etranzitkazan.ru/elektroenergetika-zakupki/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Не дозвонился. Сетевая компания. Проводят торги. Скинул КП на почту от УралСилТранс',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО СКАТ ИНН 254 314 48 34',
  NULL,
  NULL,
  '79024820722',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-04-16',
  'Созвонился. Есть дейсвтующий партнер - завод. Новых не рассматривает. Возможно пробить в будущем',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО КЕДР',
  '2312271472',
  NULL,
  NULL,
  NULL,
  'https://kedr-energo.ru/kontakti/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ФАЗА"',
  '6449032030',
  NULL,
  '+78451162422',
  'audit9664@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Номера не доступны',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "КАВКАЗТРАНСМОНТАЖ"',
  '2631041620',
  NULL,
  '+79383509688',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Отправил информацию по уралсилтранс в ватсапп. Пока нет ответа',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОПРОМ-МОНТАЖ"',
  '2632107016',
  NULL,
  '+79631719333',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'не закупают',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЮГ-ТРАНСЭНЕРГО"',
  '2312278950',
  NULL,
  '+79628560820',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Набрать !',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "СТАНДАРТ"',
  '0274956285',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ПРОФЭНЕРГО',
  NULL,
  NULL,
  '84957776847',
  'info@prof.energy',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЛИТВЕС"',
  '2302053490',
  NULL,
  '+79183627837',
  'ivanasp@yandex.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  '2025-04-16',
  'Отправил КП на почту. Завтра набрать или в ватсапп написать',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ГЕОЗЕМКАДАСТР "',
  '7105034112',
  NULL,
  '+74872259000',
  'info@gzk71.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Выполняют кадастровые работы. Вряд ли связаны с оборудованием, но можно пробовать.',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "РСО-ЭНЕРГО"',
  '3661054875',
  NULL,
  '+74732110152',
  'rso-e@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Не пробил серетаря.',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОИНЖИНИРИНГ"',
  '3663143778',
  NULL,
  '+74732106637',
  'energoinginiring36@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Отправил КП на почту, набрать. Сотрудничают через почту',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ИВЭНЕРГОРЕМОНТ''',
  NULL,
  NULL,
  '+79106960688',
  'si_makeeva@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Отправил КП на почту. Занимаются ремонтом, могут купить теоритически. Написать в ватсапп, набрать',
  '2025-04-15',
  '2025-04-15'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''ТПК ДВ ЭНЕРГОСЕРВИС''',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://tpkdvens.ru/kontakty/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  '2025-04-21',
  'Направил КП на почту. Заполнил форму обратной связи. Можно прозвонить',
  '2025-04-18',
  '2025-04-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'БЕЛЭНЕРГОПРОМ',
  NULL,
  NULL,
  NULL,
  NULL,
  'https://belenergoprom.ru/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-04-21',
  'Направил кп на почту. можно набрать. собирают ктп',
  '2025-04-18',
  '2025-04-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ИНЭСК',
  NULL,
  NULL,
  NULL,
  'snab@inesk.ru',
  'https://inesk.ru/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  '2025-04-21',
  'Направил КП на почту. Собирают подстанции. Можно набрать',
  '2025-04-18',
  '2025-04-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ТК ЭНЕРГООБОРУДОВАНИЕ',
  NULL,
  NULL,
  '+73432887050',
  'tk@tkenergo.com',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-04-21',
  'Направил кп на почту. Торговая компания. Обязательно набрать.  Диллеры завода СЗТТ',
  '2025-04-18',
  '2025-04-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО АРКТИК ЭНЕРГОСТРОЙ',
  NULL,
  NULL,
  NULL,
  'ulyanova@realty.open.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  '2025-04-21',
  'Направил КП. Занимаются монтажом энергообъектов',
  '2025-04-18',
  '2025-04-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ИНЖЕНЕРНО-ТЕХНИЧЕСКИЙ ЦЕНТР НИИ ЭЛЕКТРОМАШИНОСТРОЕНИЯ',
  NULL,
  NULL,
  '+79147949853',
  NULL,
  'https://niielmash.ru/',
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  '2025-04-23',
  'Созвонился. Закупают. Целевой. Отправил КП  Совзонится в  среду.',
  '2025-04-18',
  '2025-04-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ХИМРЕМОНТ"',
  '0268052524',
  NULL,
  '+79874836909',
  'boytsov.dv@him-rem.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  '2025-04-21',
  'НАПРАВИЛ КП В ВАТСАПП И ПОЧТУ. ЖДУ ОБРАТКУ',
  '2025-04-18',
  '2025-04-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО РНК КЭПИТАЛ',
  '0326577315',
  NULL,
  NULL,
  'rnkcapital@yandex.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'НАПРАВИЛ НА ПОЧТУ. мЕЛКАЯ КОМПАНИЯ НО УЧАСТВУЕТ В ТОРГАХ.',
  '2025-04-18',
  '2025-04-18'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ЭНЕРГО СТРОЙ',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-04-30',
  'Пока заявок актуальных нет. Набрать на следующей недели',
  '2025-04-21',
  '2025-04-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ИП Тарасова Екатерина Анатольевна',
  '780513013333',
  NULL,
  NULL,
  't.ekaterina1980@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Направил на почту коммерческое предложение. Телефона нет.',
  '2025-04-21',
  '2025-04-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ''Инфинити Инвест Групп''',
  NULL,
  NULL,
  NULL,
  'info@steelequipment.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Очень редко берут трансформаторы. Можно периодически выходить на связь.',
  '2025-04-21',
  '2025-04-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО СТРОЙПРОЕКТ',
  '7704703740',
  NULL,
  NULL,
  '8181918@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Созвонился, закупают. Передаст КП менеджерам. Отправляю СЭЩ. Можно позже Уралсилтранс',
  '2025-04-21',
  '2025-04-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "КОНТРАКТ КОМПЛЕКТ 21"',
  '7717582411',
  NULL,
  NULL,
  'info@k-komplekt.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Набрал. Пока заявок, но закупают, можно сотрудничать. Отправил КП на почту. Переодически набирать. СЭЩ отправил, потом пробью СилТрансом',
  '2025-04-21',
  '2025-04-21'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭТС"',
  '6670292367',
  NULL,
  NULL,
  'olhen1276@gmail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить. Отправил от СИЛТРАНСА',
  '2025-04-22',
  '2025-04-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО "ЭНЕРГОАСГАРД"',
  '7802536127',
  NULL,
  '+78129652310',
  'energoasgard@mail.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Не дозвонился. Отправил КП на почту от СЭЩ',
  '2025-04-22',
  '2025-04-22'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ТД СЕВЕРНАЯ ЭНЕРГИЯ',
  '4345509318',
  NULL,
  '+79229957146',
  'KGA43@MAIL.RU',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Дозвонился. Закупают. Выслал инфу на почту с 2мя предложениями.',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ТРАНСКОМ',
  '7721482650',
  NULL,
  NULL,
  NULL,
  'https://transcom-ltd.ru/contacts/',
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-04-24',
  'Закупают у табриза и поставляют ему. Можно позже пробивать от силтранса и предлагать китай',
  '2025-04-23',
  '2025-04-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО КПМ',
  '7806381442',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО МОНТАЖНИКПЛЮС',
  '6950210582',
  NULL,
  '+79000147746',
  'montazhplus69@mail.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Не дозвонился. Отправить на почту.',
  '2025-04-23',
  '2025-04-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ЭЛЕКТРОКОМПЛЕКТ',
  '9728003860',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ВАВИЛОН',
  '6316275330',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ПКФ ЭЛЕКТРОКОМПЛЕКС',
  '6679125667',
  NULL,
  '+73433821210',
  'zakaz@el-komplex.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Не дозвонился. Отправить на почту. Диллеры завода',
  '2025-04-23',
  '2025-04-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО НПО ЭЛРУ 040000861',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ВОСТОКЭНЕРГО',
  '2508129512',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ДЭТК',
  '2723051681',
  NULL,
  NULL,
  'admin@dv-electro.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  '2025-04-24',
  'Набрать по их времене. Скорее всего закупают.',
  '2025-04-23',
  '2025-04-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО АЛГОРИТМ',
  '7751279140',
  NULL,
  NULL,
  '1218091@list.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Не закупают, но запросил КП , отправил ему на почту . Можно пробивать',
  '2025-04-23',
  '2025-04-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ИП ЗАЦЕПИН РОМАН НИКОЛАЕВИЧ',
  '680904311399',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО МИР-ЭНЕРГО',
  '5404177588',
  NULL,
  '+73832994190',
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Знает Табриза. Очень редко закупают. Можно бить от уралсилтранса',
  '2025-04-23',
  '2025-04-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО АЭКЛ',
  '7705813030',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ЗАО ТДМ ЦЕНТР',
  '7725569968',
  NULL,
  '+79299217652',
  'info@solef-electro.ru',
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Пока нет потребности, но в будущем может быть',
  '2025-04-23',
  '2025-04-23'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО ИНТЕР РАО ЭЛЕКТРОГЕНЕРАЦИЯ',
  '7704784450',
  NULL,
  NULL,
  'li_zm@interrao.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Не дозвонился. Отправить КП на почту. Дозвонится',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'АО СОЛАР СЕРВИС',
  '9727075358',
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  '',
  '2025-04-01',
  '2025-04-01'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО ЛИСЕТ',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  'холодный обзвон',
  'слабый интерес',
  MANAGER_ANAR_ID,
  NULL,
  'Есть в будущем заявка на 2000 ква',
  '2025-04-28',
  '2025-04-28'
);

INSERT INTO companies (id, name, inn, city, contact_phone, contact_email, website, source, status, manager_id, next_contact_date, notes, created_at, updated_at) VALUES (
  gen_random_uuid(),
  'ООО «Тексис Груп»',
  NULL,
  NULL,
  NULL,
  'sales@texcisgroup.ru',
  NULL,
  'холодный обзвон',
  'сделал запрос',
  MANAGER_ANAR_ID,
  NULL,
  'Поставляют оборудование. Скинул КП на рассмотерние',
  '2025-05-28',
  '2025-05-28'
);

-- ═══ COMPANY CONTACTS (ЛПР) ═══
INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ГончарРодионСергеевич', NULL, '+79507911416', 'E-mail: grs@tehold.ru', '+79507911416', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ТрансЭнергоХолдинг''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Богданнасвязи', NULL, '+79115486717', NULL, '+79115486717', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "СПЕЦЭКОНОМЭНЕРГО"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Никита', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ГлавЭлектроСнаб' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Валентин', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ПЭП"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Евгенияzolnisaruдоб', NULL, NULL, 'z35@olnisa.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'Олниса' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Илья', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО ''НПОТЭЛ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'доб', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''УРАЛМАШ НГО ХОЛДИНГ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Мария', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''КАПРАЛ БРИДЖ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Никита', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''СТРОЙТЕХУРАЛ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Евгенийзакупщик', NULL, '+78632697960', NULL, '+78632697960', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''РЕГИОНИНЖИНИРИНГ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Вадим', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ЭНЕРГОТЕХСЕРВИС''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Евгенийведущийинженернабонусе', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ОМСКЭЛЕКТРОМОНТАЖ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'МарияГенадьевназакупщик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ЭЛЕКТРОЩИТ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЮлияСнабженец', NULL, '+78612600996', NULL, '+78612600996', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО НПК ''ЭЛПРОМ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ОлегЗакупщик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ПРОМКОМПЛЕКТАЦИЯ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'МихаизакупщикРегинатодезакупщик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО ''ВНИИР ГИДРОЭЛЕКТРОАВТОМАТИКА''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'СергейПавлович', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "УВАДРЕВ-ХОЛДИНГ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Добуснабжения', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ПТК "ЭКРА-УРАЛ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Дмитрий', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ТЕКСИС ГРУП''7710620481' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Данилзакупщик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО  ''УРАЛЭНЕРГОЦЕНТР''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Евгениймилюшкинзанимаетсянашимсказалвышликппосмотрю', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ПО ''РОСЭНЕРГОРЕСУРС''5404223516' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Закупщицаанна', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ТЭМ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Сергейзакупщик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '5834121869 ООО ''ЭВЕТРА ИНЖИНИРИНГ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Михаилпокачтонедоступен', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '7448200380ООО ''КВАНТУМ ЭНЕРГО''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Антонзакупщикдоб', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '6672180274 ООО ''МОДУЛЬ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Татьяназакупщик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '7710957615 ООО ''ПРОМСТРОЙ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Светаланаснабженец', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '4205152361 ООО ''ЗЭМ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Андрейдиректор', NULL, '+79107874798', NULL, '+79107874798', NULL, true, now()
FROM companies comp WHERE comp.name = '6670316434 ООО ''ЭЗОИС-УРАЛ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'АндрейМикишевтехничдиректордоб', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '6150045308 ООО ''АВИААГРЕГАТ-Н''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Сергей', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '0571014706 ООО ''СПЕЦСТРОЙМОНТАЖ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Магомед', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '5029227275 ООО ''ЭТК''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Андрей', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '2130100264ООО ''НИП''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Еленазакупщица', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '6674353123 ООО ''АЛЬЯНС РИТЭЙЛ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВладимирИвановичруководиь', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '7820307592 ООО ''ЭНЕРГОСТАР''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Евгений', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '2116491707 ООО ''ИЗВА''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Татьяназанимаетсятрансформаторами', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '2502047535 ООО ''ВОСТОКЭНЕРГО''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Константинзакупщик', NULL, '+79111114339', NULL, '+79111114339', NULL, true, now()
FROM companies comp WHERE comp.name = 'ГОУП «Кировская горэлектросеть»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Вадимниколаев', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО ''ОБЪЕДИНЕННЫЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'гИвановоулНоваяд', NULL, NULL, '(4932) 936-695 oho2@oes37.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "САМЭСК"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЕкатеринаЮрьевна', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО ''Варьегоэнергонефть'' https://oaoven.ru/kont.html' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'АзатАскатовичначальникПТО', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО ''Пензенская горэлектросеть' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЕвгенийВасильевичНачальникснабжения', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'https://eskchel.ru/ ТМК Энерго' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Анастасияигоревназакупщик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'Акционерное общество «Витимэнерго»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Секретарь', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'Черкессие городские сети' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'АлександрУстинов', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "НЭСК"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ГорьковскаяЕвгенияАлександровнаначальникснбаж', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ЭУ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Мужиккакойто', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "ХГЭС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЗакупщицаТатьяна', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'МУП ''Электросервис''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'хзпока', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "ДВ РСК"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'БухматовВладимирАлександрович', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "УСТЬ-СРЕДНЕКАНСКАЯ ГЭС ИМ. А.Ф. ДЬЯКОВА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'хзпока', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "УССУРИЙСК-ЭЛЕКТРОСЕТЬ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'хзпока', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "СЭС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Имянеузнал', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "КЭС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'русланснабженец', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ТД "ЭЛЕКТРОСИСТЕМЫ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Неспросил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "АСК"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ИгорьНиколаевич', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'Енисей сеть сервис' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Секретарь', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'Акционерное общество «Городские электрические сети» (АО «Горэлектросеть»)' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'линияснабж', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "СИНТЕЗ ГРУПП"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'неспросил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ПКБ ''РЭМ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЕвгенийОрлов', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЦЭК"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'СергейСтаниславович', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ПРИЗМА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'СергейАлексеевич', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ГОРСЕТИ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'непробил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "КЭСР"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'непрошелсекретаря', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО ''ТЭТ-РС''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'барнаулснабжениетамвкабинете', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "КЭС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'неспросил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "НОРДГРОН"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'поканепробил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ЭнергоИнжиниринг''  ОГРН 1162468059225 ИНН 2466169359' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЕленаГрибова', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ТСК "ЭНЕРГОАЛЬЯНС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'хзпока', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «Энергосибинжиниринг»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'светланаснабж', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «ЭКРА-ВОСТОК»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Натальяначальникснабж', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"КЭС ОРЕНБУРЖЬЯ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВадимВалерьевичснабж', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'МП "ВПЭС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'РусланАмварович', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"БОГОРОДСКАЯ ЭЛЕКТРОСЕТЬ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ДарьяЖукова', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "СИСТЕМА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'непрошелсекретаря', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "МЭС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'снабженецзанят', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"ЗАПАДНАЯ ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'АндрейБорисовичПетров', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ОАО "СКЭК".' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'несказала', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"ФАБИ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'АбзаловКириллИльдарович', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"ИНТЕР РАО - ИНЖИНИРИНГ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Снабжение', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «БГК»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'непробил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "ГОРЭЛЕКТРОСЕТЬ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'непробил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "ЭЛЕКТРОУРАЛМОНТАЖ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'неузнал', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"СПЕЦЭНЕРГОГРУПП"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'неответили', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "ДРСК"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Неспросил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "ПО КХ Г.О. ТОЛЬЯТТИ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'недозвон', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"ТРАНСНЕФТЬЭЛЕКТРОСЕТЬСЕРВИС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'несвязался', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "РСК"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'недозвон', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭЛВЕСТ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЮрийГригорьевич', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '''ЭНЕРГОУПРАВЛЕНИЕ''6603023425' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'недозвон', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''НТЭАЗ Электрик''6615010205 https://www.vsoyuz.com/ru/kontakty/sluzhba-zakupok.htm' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'морошкинаекатеринаилиренатбекселеев', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «КУЗНЕЦК ЭЛЕКТРО»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'неузналнаефонелпр', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '''РЕГИОНЭНЕРГОСЕТЬ''5948063201' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'покатуго', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АКЦИОНЕРНОЕ ОБЩЕСТВО "ГИДРОЭЛЕКТРОМОНТАЖ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'нетнаместе', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "УЭСК"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'недозвон', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО “АвтоматикаСтройСервис”' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'невзяли', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"СК "ЭВЕРЕСТ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'алескандр', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ПКП "ФИНСТРОЙИНВЕСТ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'александр', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "ОЗЭМИ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Анатолийалександровичначальникснабжения', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'Общество с ограниченной ответственностью «ЭнергоПрогресс»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Александрснабжение', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭЛВЕСТ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'незнаю', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ПК ЭЛЕКТРУМ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Александркравченко', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ " НИИЭФА - ЭНЕРГО "' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЕленаШмакова', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АКЦИОНЕРНОЕ ОБЩЕСТВО "ПОДОЛЬСКИЙ ЗАВОД ЭЛЕКТРОМОНТАЖНЫХ ИЗДЕЛИЙ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Лариса', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '5249058696 АО ''НИПОМ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'неузналнаефонелпр', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭЛЕКТРООПТИМА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Маргарита', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'михайловск ставрополь' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ОлегНиколаевичДадоновруководиьотедлазакупок', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ИЗВА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВенераГусмановна', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '''ЗАВОД ''СИБЭНЕРГОСИЛА''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Татьяна', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '3702015155 ''СПЕЦЭНЕРГО''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'недозвон', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЗИТ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'русланчик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭНЕРГОЭРА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'неспросил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "НПП ЭЛТЕХНИКА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'недозвон', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "ПРОГРЕСС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'недозвон', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"ЭТЗ "ЭНЕРГОРЕГИОН"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'недозвон', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"ЭЛЕКТРОНМАШ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Светлананедозвон', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ПП ШЭЛА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'недозвонился', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '7722286859 ООО СК ''БЕТТА''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Аннаниколаевна', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЗАВОД ЭЛПРО"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Вячеслав', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭЛЕКТРОПРОФИ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ОЛьгаснабжБорискомерчдир', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭЛЕКТРОСТРОЙ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'АйратЗуфарович', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО КОМПАНИЯ "ИНТЕГРАТОР"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВалерийНиколаевичглавныйинженер', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭЛЕКТРОКОНТАКТ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ДенисИщук', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭНЕРГОКАПИТАЛ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Игорь', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО "ЭНЕРГОТЕХПРОЕКТ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Артем', 'закупщик', NULL, 'joev.ar@gmail.com', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '"ИНТЭКО"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ГерасимовПавелВикторович', 'Начальник отдела снабжения', '+74842715696', 'p.gerasimov@kenergo.ru', '+74842715696', NULL, true, now()
FROM companies comp WHERE comp.name = '«ЭМПИН»  7743910877 Москва' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Артем', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''АСМ''   3250519725 Брянсск' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'snabcityenginruснабжение', NULL, NULL, 'snab@cityengin.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ПЭС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Дарьязакупщик', NULL, NULL, 'omts@cem.pro', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ЭНЕРГО-ДОН''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Максим', NULL, '+79631546284', NULL, '+79631546284', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "Энергоспецснаб"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Ольгазакупщик', NULL, NULL, 'torgi2@energo-don.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «РСТ-ЭНЕРГО»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Григорийзакупщик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ЭЛЕКТРО' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Владимир', NULL, '84855280305', 'avan_76@mail.ru', '84855280305', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «БЭСК Инжиниринг»  0275038560 Уфа' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Паввел', 'Отдел закупок:', '88352756095,', '111@progenerg.ru', '88352756095,', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "Энерго Пром Сервис"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Александра', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "Энергостройуниверсал"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Альбертначснаб', NULL, '+78652282802', NULL, '+78652282802', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "БЭЛС-Энергосервис"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'добснабжение', NULL, NULL, NULL, NULL, NULL, false, now()
FROM companies comp WHERE comp.name = 'ООО "БЭЛС-Энергосервис"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЮрийВладимирович', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «МОНТАЖЭНЕРГОПРОФ»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'КузнецовАндрейзакупщик', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "Гарантэнерго"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВадимАскеровзакуп', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '''ГРУППА КОМПАНИЙ ПРОФИТРЕЙД''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Антон', NULL, '89959615925', NULL, '89959615925', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «Завод „Энергетик“' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВиноградоваОлесяАнатольевна', 'Отдел снабжения', '+79207691229', 'omtc@shela71.ru', '+79207691229', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ПП ШЭЛА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'доб', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ТД ''ПРОМЫШЛЕННОЕ ОБОРУДОВАНИЕ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВиталийИгоревич', NULL, '+79625389819', NULL, '+79625389819', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «АС-ЭНЕРГО»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Лев', NULL, '89293386546', NULL, '89293386546', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО НПП «220 Вольт»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'РускихНатальяВикторовнаначснаб', NULL, '83513043685', 'omts4@ozeu.ru', '83513043685', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «Энергии Технологии»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЕпифановРоманАлександровичдир', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''СНАБЭНЕРГОРЕСУРС''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Николай', NULL, '89615030009', NULL, '89615030009', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «ЭНЕРГОГРУПП»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Еленазакуп', NULL, '89047362224', '777@220ufa.com', '89047362224', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО “Энергопроф”' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ШитовПавелФедорович', 'Гл. инженер', NULL, 'shitov@ener-t.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '''РЕСУРССПЕЦМОНАЖ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Владимирснаб', NULL, '+79184621447', NULL, '+79184621447', NULL, true, now()
FROM companies comp WHERE comp.name = 'Завод производитель трансформаторных подстанций «МИН»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Венера', 'Отдел снабжения:', '+78432101515доб.350', 'Omts@eloptkzn.ru', '+78432101515доб.350', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭЛЕКТРООПТИМА"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Антонзакуп', NULL, NULL, 'klav@egroupp.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''МЭК''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВладимирАнатольевич', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «Электрощит»-ЭТС' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Андрей', NULL, NULL, 'tk2@l-complex.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''Ринэко''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'МашуковИгорь', NULL, '89219509909', NULL, '89219509909', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''КИМ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Яназакуп', NULL, NULL, 's1@pkf36.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ПКФ "ЭЛЕКТРОЩИТ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'добзакупки', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ЧЭТА''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Алексей', 'Отдел снабжения', '+78652315646', 'mec26@mail.ru', '+78652315646', NULL, true, now()
FROM companies comp WHERE comp.name = 'Электрощит' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЕвгенийНикитинзакуп', NULL, '88462733149', 'enikitin@elsh.ru', '88462733149', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''АС-ЭНЕРГО''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'доб', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "Энергостройуниверсал"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Екатерина', NULL, '89021388485', 'mto@kim51.ru', '89021388485', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ЭЛЕКТРОМАКС''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ДенисСуровый', NULL, NULL, 'suroviy.d@energy-solution.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''МАКСИМУМ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Иван', NULL, '+79680681333', NULL, '+79680681333', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ТСН''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'КравченкоИгорьАлександрович', 'отдел закуп', '88352281888', 'zakupki@cheta.ru', '88352281888', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ЕТекс' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ПолинаКостромина', NULL, NULL, 'polina_kostromina@mail.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '(ООО «Челябинский завод «Подстанция») 7451263799' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Кирил', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО НПК «ТехноПром»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'БоровневЕвгенийГенадьевич', NULL, NULL, '​​borovnev@radian-holding.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''Управляющая компания ''Уралэнерго' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ПавелДанилов', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «Инженерный центр «Энергосервис»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Иван', NULL, NULL, '05maximum@list.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ИЦ ЭНЕРГЕТИКИ''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Эмиль', NULL, '89373323339', NULL, '89373323339', NULL, true, now()
FROM companies comp WHERE comp.name = 'АО ''ОВЛ-ЭНЕРГО''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'КурышкинАлександрСергеевич', '(Начальник коммерческого отдела)', '89227408780', NULL, '89227408780', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ПО ''РосЭнергоРесурс''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВасилийГенадьевич', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО '' ЛЕРОН ''   7803010217' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Азатдоб', NULL, NULL, 'amavlin@u-energo.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ЭНЕРГО ЦЕНТР''    3328492856' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Александр', NULL, '89362451704', 'pto@elengroup.ru', '89362451704', NULL, true, now()
FROM companies comp WHERE comp.name = 'РегионСтройКомплект' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, '​​​rernskru​', NULL, NULL, '.2@rernsk.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '''ЭНЕРГ-ОН''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'доб', NULL, NULL, NULL, NULL, NULL, false, now()
FROM companies comp WHERE comp.name = '''ЭНЕРГ-ОН''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'СергейСтепанович', NULL, '89819858195', NULL, '89819858195', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''ЭНЕРГО АЛЬЯНС''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Мария', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ЭТЗ «ИВАРУС»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Александр', NULL, NULL, 'alex@ntbe.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ЗАО ''Энергомашкомплект''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'доб', NULL, NULL, 'LVV@esm-t.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «ЦРЗЭ»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'доб', NULL, '83952500767', NULL, '83952500767', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''РиМтехэнерго''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Инокентий', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭНЕРГОАЛЬЯНС"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Максим', NULL, '89631546284', NULL, '89631546284', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭЛЕКТРОГАРАНТ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Татьяна', NULL, '+79130686615', 'snab2@energo-capital.ru', '+79130686615', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭНЕРГОКАПИТАЛ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Алексей', NULL, NULL, '109@ktp74.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «Солар Системс»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'доб', NULL, NULL, 'snab@ktp74.ru', NULL, NULL, false, now()
FROM companies comp WHERE comp.name = 'ООО «Солар Системс»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ВасильковЯковСергеевич', 'отдела снабжения', NULL, NULL, NULL, NULL, false, now()
FROM companies comp WHERE comp.name = 'ООО «Солар Системс»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'НовикиоваТатьянаСергеевназакуп', NULL, NULL, 't.novikova@emk-perm.ru', NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'Инжиниринговая Компания ТЭЛПРО' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Максим', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = '(ООО «Челябинский завод «Подстанция») 7451263799' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'АлександрМишалкин', NULL, '+79371849364', 'pkf45@pkftsk.ru', '+79371849364', NULL, true, now()
FROM companies comp WHERE comp.name = 'Крия Инжиниринг' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Михаилдобавочно', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'Общество с ограниченной ответственностью ''Самур''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ЩупляковСергейАлексеевич', NULL, '89157478114', NULL, '89157478114', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «Сибтэк»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Невышешл', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'АО Дюртюлинские ЭиТС' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'НЕДОЗВОНИЛСЯ', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО «Энергоремонт»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ГришинЕвгенийАнатольевич', NULL, '83952444337,доб.370департаментаснабженияПО', NULL, '83952444337,доб.370департаментаснабженияПО', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ПО «Радиан»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Моб', NULL, NULL, 'E-mail: Grishin@radian-holding.ru', NULL, NULL, false, now()
FROM companies comp WHERE comp.name = 'ООО ПО «Радиан»' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Вадим', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ПТМ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ПавелВасильевич', NULL, '+79294089979', NULL, '+79294089979', NULL, true, now()
FROM companies comp WHERE comp.name = '"ЭЛЕКТРИЧЕСКИЕ СЕТИ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Илья', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'Энергопрайм' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ефон', NULL, '+73912807711', 'email: info@sibtek.su', '+73912807711', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЭНЕРГОПРОМ-МОНТАЖ"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Заместиьгенеральногодиректорапоэлектроснабжениюглавныйинженер—ИмаевРустамРифгатович', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ЮГ-ТРАНСЭНЕРГО"' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'httpswwwtehenergoholdingru', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО "ГЕОЗЕМКАДАСТР "' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'httpsdrivegooglecomfiledVRegtaxmrDLHfHTLPmSaOictzrWviewpli', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО СТРОЙПРОЕКТ' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Андрей', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО АЛГОРИТМ' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'лпр', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО АЭКЛ' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'ПавелВасильевич', NULL, '+79294089979', NULL, '+79294089979', NULL, true, now()
FROM companies comp WHERE comp.name = 'АО СОЛАР СЕРВИС' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Алексей', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ЛИСЕТ' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'emaildvsibemruтПетюновМихаил', NULL, '89502909002ШабуняАлександр', 'dv@sibem24.ru', '89502909002ШабуняАлександр', NULL, true, now()
FROM companies comp WHERE comp.name = 'ООО ''СибЭлектроМонтаж''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'emailirkutsksibemruтКоролевВладислав', NULL, NULL, 'e-mail:  novosib@sibem24.ru  info@sibem24.ru', NULL, NULL, false, now()
FROM companies comp WHERE comp.name = 'ООО ''СибЭлектроМонтаж''' LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'доюШтомпельВалерийВикторовичглавныйинжинер', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = NULL LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'Андрей', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = NULL LIMIT 1;

INSERT INTO company_contacts (id, company_id, name, position, phone, email, whatsapp, notes, is_primary, created_at)
SELECT gen_random_uuid(), comp.id, 'httpwwwtexcisgroupru', NULL, NULL, NULL, NULL, NULL, true, now()
FROM companies comp WHERE comp.name = NULL LIMIT 1;

-- ═══ ACTIVITIES ═══
INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Входяшка.Отправил КП', '2025-04-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ГТтехнолоджис' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Входяшка, звонил анар попутка по нашей теме отправилКП', '2025-04-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ТрансЭнергоХолдинг''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'На связи с ним', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "СПЕЦЭКОНОМЭНЕРГО"' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'На связи с ним', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ГлавЭлектроСнаб' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказал директор отправить на щакупшика на валентина с ним еще пообщаться надо', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПЭП"' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'недозвон кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АртЭнерго строй' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Пообшались сказали закупают кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Инженерный центр Энергетики' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'недозвон кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЭТС Энерго' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Олниса' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'ОТправил кп сложно пробиться', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Систем Электрик' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказал закупили уже много чего в первом квартале, звонить в конце августа', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Стройэнергоком' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП, поговорил сказал перенабрать поговорить точечно а так закупают', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ТрансЭлектромонтаж' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил недозвон пока что с кем то разговаривал', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Тверь Энергоактив' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Попросил кп на почту снабженец', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''Элмонт Энерго''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил , сказал пока что вопрос по поставкам неакутальный, но будем пробивать его', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Сетьстрой' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил Занято', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'МагистральЭнерго' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил Занято', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЭнергоПромСТрой' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил Занято', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Норэнс Групп' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил сложно пробиться буду пробовать еще раз', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'МосСитиСервис' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Телефон не работает', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЭнергоСистемы' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Блять не понимаю че у них у всех с телефонами', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Магистр' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказала отправляйте кп рассмотрим начальник отдела снабжения', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Строймонтаж' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Ответила женщина сказала проекты есть направляйте кп для снаюжения еще раз перезвоним ей потом', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''СК ЭНЕРГЕТИК''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'пока что сказала ничего нет в работе', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'СПМенерго' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Мой клиент по основной работе, у них конкурсы черещ плошадку их собственную там надо регать компанию чтобы учавствовать', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ВМЗ' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Договорились тут на встречу классны типо закупают', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''НПОТЭЛ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвонился попробовать еще раз в снабжение/ не дозвон пока что', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''УРАЛМАШ НГО ХОЛДИНГ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказала закупают, направлю письмо сказщала посмотрит', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''КАПРАЛ БРИДЖ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвонился пока что до него, скинул, позже набрать/ на обеде сказал чуть позже набрать', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭСК''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Заинтересовался, попросил предложение на почту', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''СТРОЙТЕХУРАЛ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Номер щакупок выцепил пока что не отвечают, отправляю кп   89204505168 Роман Сергеевич agregatel1@bk.ru(11.06)', '2025-06-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''АГРЕГАТЭЛЕКТРО''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказал зщакупают все ок запросы пришлет', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''РЕГИОНИНЖИНИРИНГ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Вадим Логист, сказал перешлет письмо с инженерам с ним на коннекте', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭНЕРГОТЕХСЕРВИС''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвонился но кп отправил, пробовать снова', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ТД ''ЭЛЕКТРОТЕХМОНТАЖ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'В вотсап написал 10 июля', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ОМСКЭЛЕКТРОМОНТАЖ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Пока что нет ее на месте кп отправил перезвонить. ОТправил ей кп, сказала закупают рассмотрит/ короче ктп сами делают говорит в основном заказчик сам приорбретает трансформатор но если что то будет направит', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭЛЕКТРОЩИТ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Нвправио кп в отдел снабжения', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ПРОМСОРТ-ТУЛА''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Короче они заказывают по ошибке реально они зщаказывали трансу другой компании короче надо внедриться к ним, не отвечает 11.06/ не отвечает пока что Юлия/stv@/Юлия не отвечает пока что 10/07', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО НПК ''ЭЛПРОМ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказал закупают кп направляю', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ПРОМКОМПЛЕКТАЦИЯ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказал скиньте инфу посмотрим', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ВНИИР ГИДРОЭЛЕКТРОАВТОМАТИКА''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не отвечает пока что перезвонить кп направил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "УВАДРЕВ-ХОЛДИНГ"' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не отвечает перезвонить/не отвечает не могу дозвонится пока что на обеде', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭЛЕКТРОЩИТ-УФА''0278151411' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не смог дозвониться, видимо все на обеде, чуть позже набрать но через добавочные на них можно выйти /недозвон', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "РСК"' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказал набрать в рабочее время перезвонить/Сказал направить на почту', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ГК АЛЬЯНС''7017409323' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Все слиняли уже на рпаздники набрать после  / пока что не отвечают почему то по добавочному', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПТК "ЭКРА-УРАЛ"' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил на Дмитрия/ передам инфу дмитрию и на этом все закончилось мерзкий секретарь 10/07', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ТЕКСИС ГРУП''7710620481' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказал заявки есть и проекты тоже есть', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО  ''УРАЛЭНЕРГОЦЕНТР''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Попробуем в русский свет пробиться', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''РС''7704844420' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Юлия Азарова 2 ярда оборот', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ЭНЕРГОТЕХПРОЕКТ''6319171724' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Нет ответа мб уже на праздниках,кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ТЭС НН''5258109139' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'сказал вышли кп посмотрю', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПО ''РОСЭНЕРГОРЕСУРС''5404223516' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказала у них только с атестацией в Россетях но кп сказала направьте', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ТЭМ"' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Перенабрать еще раз не соединилось с отделом закупок', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛЕКТРОНМАШ ПРОМ"' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказал закупаем переодически направляю кп', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5834121869 ООО ''ЭВЕТРА ИНЖИНИРИНГ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Тут надо выйти на отдел снабжения они этим занимаются, кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭНЕРГОТЕХСТРОЙ''5902126385' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Тут надо выйти на снабжение не отвечали, попробовать дозвониться', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ПО ЭЛТЕХНИКА''7825369360' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил грубая тетка', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ПО ЭЛТЕХНИКА''7825369360' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '89210409085 Михаил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7448200380ООО ''КВАНТУМ ЭНЕРГО''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Сказала присылайте посмотрим интерес есть', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5260342654ООО ТД ''СПП''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил кп, недозвон', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '9102000126 ООО ''СПЕЦЩИТКОМПЛЕКТ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Задача пообшаться С катей? обшался с Сергеем, сказал закупают трансформаторы', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7728679260 ООО ''ПЕТРОИНЖИНИРИНГ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Каталог отправил кп тоде дозвниться тут не смог', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '6311115968 ООО ''ТСК ВОЛГАЭНЕРГОПРОМ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Будет на след неделе а так у них запросы есть, кп отправил в догонку', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '6672180274 ООО ''МОДУЛЬ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отпрапвил сотрудник на совещании перезвонить', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '3664123615 ООО ''ВЭЗ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'До снабжения не дозвонился на обеде, ставлю перезвон, кп в догонку', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '2126001172 ООО НПП ''ЭКРА''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Обед, перезвонить, кп в догонку/ набрать в 3 по екб обед у них', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7733634963 ЗАО ''СТРОЙЭНЕРГОКОМПЛЕКТ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Перенабрать предложить сотрудничесво секретарь не втухает/перенабрал кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7813192076 ООО ''АТЭКС-ЭЛЕКТРО''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Татьяна закупщик сказала проекты бывают перешлет проектому отделу', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7710957615 ООО ''ПРОМСТРОЙ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил кп не дозвонился', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5404464448ООО ''НТК''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не отвечабт скорее всего на обеде отправляю кп на отдел закупок', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7702080289 АО ''СИЛОВЫЕ МАШИНЫ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Для Марии направил письмо', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5914007456 ООО ''ПРОМЫШЛЕННАЯ ГРУППА ПРОГРЕССИЯ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают кп отправил для них, но нужно узнат имя человека который акупает трансы', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '4205152361 ООО ''ЗЭМ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не отвечабт мб на обеде перезвонить с утра', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '6731035472 ООО ''ТД ''АВТОМАТИКА''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп направил ему сказал рассмотрит', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '6670316434 ООО ''ЭЗОИС-УРАЛ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дозвонился до него нало перещзвонить видимо не на месте/ дозвонился кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '6150045308 ООО ''АВИААГРЕГАТ-Н''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупабт тут технари а не отдел снабжения заявку сказал сейчас пришел', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5190044620 АО ''ТЕХНОГРУПП''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'тут не пробился пробовать еще', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7814461557 ООО ''НТТ-ИК''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают трансформаторы сами производят сухие, кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '0571014706 ООО ''СПЕЦСТРОЙМОНТАЖ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Интересно ему ждем от него сообщение в вотсапе', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5029227275 ООО ''ЭТК''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Списались в вотсапе', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '2130100264ООО ''НИП''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7701389420 ООО ''АТЕРГО''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Перезвонить Юлии, уточнить акупают ли они трансы представиться как ХЭНГ она закупщица/ Ответил тип какой то выйти на Юоию надо', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7736606442 ООО ''ТЕХСТРОЙМОНТАЖ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают кп на почту отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '6674353123 ООО ''АЛЬЯНС РИТЭЙЛ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не отвечали направляю кп', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '3810051697 ООО ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ ''РАДИАН''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Иркутск кп отправил с утра набрать', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '6671406440 ООО ИК ''ЭНЕРГОСОФТ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил на него ждем запросы', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7820307592 ООО ''ЭНЕРГОСТАР''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил кп секретарь сложный', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5404396621 ООО НПП ''МИКРОПРОЦЕССОРНЫЕ ТЕХНОЛОГИИ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5903148303 ООО ''БЛЮМХЕН''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'кп отправил по номерам не дозвониться', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '1657048240 ООО ''УК ''КЭР-ХОЛДИНГ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кп отправил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '0277071467 ООО ''БАШКИРЭНЕРГО''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Пробуем пробиться в башкирэнерго', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '3446034468ООО ''ЭНЕРГИЯ ЮГА''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'кп отправил на линии занято', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7451227920ООО ''ЭЛЕКТРОСТРОЙ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не отвечабт кп направил', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '0268027020ООО ''ЭНЕРГОПРОМСЕРВИС''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'кп направил не отвечают', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '6166107912 ООО ''РОСТЕХЭНЕРГО''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил ему письмо жду заявку, перенабрать ему тоже надо', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '6686078707 ООО ''ПЭМ''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Мы с ним на вотсапе попросил инфу', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '2116491707 ООО ''ИЗВА''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'КП направил она не отвечает перезвонить ей', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '2502047535 ООО ''ВОСТОКЭНЕРГО''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил кп не дозвонился', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5260401638 ООО ''КРЭС''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'сказали обед перезвонить отдел снабжения', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7453260063 ООО ''СТРОЙЭНЕРГОРЕСУРС''' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Антон, главный инженер сказал направбте на мое имя, нужно еще в отдел закупок доб 1', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Ставропольэлектросеть' AND usr.name ILIKE 'алик%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Будут кидать нам запросы для выход на торги', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'p-seti.ru' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'отправил кп на почту', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '7817302964 https://izhek.ru/' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Связь с закупчиком хорошая', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ГОУП «Кировская горэлектросеть»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил со стасом. Надо регаться на сайте https://td.enplus.ru/ru/zakupki-tovarov/ Можно работать. У нас общие китайцы. Второй звонок', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ХК ''СДС - ЭНЕРГО''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Готовы брать из наличия. По торгам у них выступает другое юр лицо. Торговый дом sds treid. искать на госзакупках', '2025-04-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ОБЪЕДИНЕННЫЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'начальник снажения. контакт хороший.жду обратную связь', '2025-04-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "САМЭСК"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'работают только через торги. смотреть гос.закупки', '2025-04-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''КРАСЭКО''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с закупщиком КТП. Женщина. Говорит что закупают напрямую. Просит давать самое выгодное предложение сразу, время торговаться нету. газпром росселторг', '2025-04-17'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Энергонефть Томск http://energoneft-tomsk.ru/index.php?id=13' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не могу дозвониться. надо пробовать.21.05.25. Дозвонился до отдела закупок. Торгуются на площадке газпрома.', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЗАО "ЭИСС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Берут БКТП и трансформаторы. Связаться после среды.', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''Варьегоэнергонефть'' https://oaoven.ru/kont.html' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Связался с начальником ПТО. Тендерная система. Закрытые закупки. Китайцы интересны. По техническим моментам (40140)/ 29.08.2025 заявок нет', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''Пензенская горэлектросеть' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Павел не решает. До александра не дозвонился. 5 августа 2025 - заявок нет// 25 августа 2025 года - заявок нет// 17 сентября - заявок нет//', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ОРЭС-ПРИКАМЬЯ''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '26.03.2026. заявок нет', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'https://eskchel.ru/ ТМК Энерго' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Заинтересовал снабженца Китаем. Попросил скинуть ему на почту инфу о нас. Говорит, что будет закупка - будет и пища)', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПРОМЭНЕРГОСБЫТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дохвонился, а надо', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ПКГУП ''КЭС''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Выбил комер закупщика. Поговорил. Отправят запрос на КТП', '2025-04-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Акционерное общество «Витимэнерго»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Набрал в общий отдел. Дали этот номер. Сегодня там   выходной. Набрать завтра. Спросить снабжение', '2025-04-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Черкессие городские сети' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Связался с секретарем. Дали комер отдела закупок. Не взяли. Пробовать еще раз.', '2025-04-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Щекинская ГОРОДСКАЯ ЭЛЕКТРОСЕТЬ' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с закупщиком. Женщина в возрасте. Работают под росстеями под торги. Торги проходят на площадке РАД. Будут торги на трансформаторы 250,400,630 после майских', '2025-04-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ИНТЕГРАЦИЯ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Познакомился с закупщиком. Нашего профиля маловато, но будут скидывать запросы, потому что хорошо поговорили.', '2025-04-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "НЭСК"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвонился до инженера. Пробовать еще. в этом году не будет закупок. звонок юыд 14 -7 2025', '2025-05-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Электросети"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Кое-как нашел номер приемной но не дозвонился.11 сенября 2025 вытащил номер главного инженера. было занято/// 18.09.2025. поговорил с инженером. закупки проходят по 223 фз. прямых нет. попросил кп.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ВЭС-СНТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Работают через торги. Наш профиль. Площадка: ЭТП ГПБ.', '2025-05-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭУ''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Берут только измерительные трансы нтми.', '2025-05-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ХГЭС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Пообщался с закупщицей. Очень хорошо поговорили. Есть и прямые закупки до 1.5 млн. Берут и трансы и ктп. РТС тендер. скоро закупка. Отправил КП', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'МУП ''Электросервис''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '21.05.2025. Дозовнился до отдела закупок. торгуются на площадке ТЕГТОРГ. Прямых на подстанции и трансы не бывает.', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ДВ РСК"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Пообщался со старым) Нормальный перец. будут брать,думаю/ 29.08.2025 не берет', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "УСТЬ-СРЕДНЕКАНСКАЯ ГЭС ИМ. А.Ф. ДЬЯКОВА"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с секретарем. Снабженцы сидят на Колымской ГЭС. Дала номер, но там пищат что-то. пробовать позже/29.08.2025. Не дозвон.', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "УССУРИЙСК-ЭЛЕКТРОСЕТЬ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Узнал номер снабжения безхитростным путем. Но там сука не берут. Пытаться еще/29.08.2025. Не дозвон.', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "СЭС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с закупщиком. Он сказал, что больших закупок пока не будет, но будут разовые. Китай интересен. 29.08.2025. Не дозвон.', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "КЭС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с девочкой. Пока заказов нет, но просит отправить инфу. Контакт хороший', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ ''ТЕХЦЕНТР''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Руслан хороший парень. Сразу скентовались с ним) Уже есть заказ', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ТД "ЭЛЕКТРОСИСТЕМЫ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с закупщицей. Рассмотрят наше предложение//29.08.2025  Сказала не занимаются трансами. пиздит возможно', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "АСК"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорили с Игорем. Интересно ему. Скинет заявку.Поговорил с игорем 14 07 25. не получил заявку', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Енисей сеть сервис' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'отправил кп на почту/ 29.08.2025 Секретарь ебет мозга', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Акционерное общество «Городские электрические сети» (АО «Горэлектросеть»)' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Позвонил в отдел снабжения. Поговорил с парнем. Торгуются на РТС. Прямых нет.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "СИНТЕЗ ГРУПП"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Разговаривал с закупщиком. Строгий дядя) Но попросил КП.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ПКБ ''РЭМ''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговори с начальником снабжения. Скинул КП', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЦЭК"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил снабженцу кп', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПРИЗМА"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'отправил кп на почту. звонил. 29.08.2025 сказал на пол года проекты расписаны. отравить кп. Набрать после майских 2026', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ГОРСЕТИ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'связался с закупками. работают через торги 223 фз. 29.08.2025 закупщица сказала, что не сказала бы что закупка проводится', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Томские электрические сети»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дозвонился. Обед.', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Электросети"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил с секретарем. сказала пока не даст номер снабженца и имя не скажет. но ключевое слово пока))', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "КЭСР"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не прошел секретаря. отдать алику на доработку', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ТЭТ-РС''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дозвон', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЗАО ''ТЭСА''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'снабженца нет на месте пока. перезвоню', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "КЭС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил со снбаженцем. Пока что мнется, но сказал набрать попозже. может, что появится. у секретаря сразу просить соеденить со снабжением.', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "НОРДГРОН"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'отправил кп на почту.', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭнергоИнжиниринг''  ОГРН 1162468059225 ИНН 2466169359' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Заинтересовались. отправил кп', '2025-05-23'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ТСК "ЭНЕРГОАЛЬЯНС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'отправил кп.', '2025-05-23'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Энергосибинжиниринг»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил со светланой. интерес по трансам. скинул цены на вотсапп. 8.04.2026 заявок нет', '2025-05-23'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «ЭКРА-ВОСТОК»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил с натальей. хочет россети. скинул инфу на вотсапп. но разговор хороший. будет отправлять заявки.', '2025-05-23'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"КЭС ОРЕНБУРЖЬЯ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Контакт хороший, но не могу отправить письмо. надо норм почту.', '2025-05-23'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'МП "ВПЭС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил со снабженцем. получил заявку', '2025-05-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"БОГОРОДСКАЯ ЭЛЕКТРОСЕТЬ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Рамочный договор на год. Поговорил с Дашей. Будут иметь нас ввиду.', '2025-05-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "СИСТЕМА"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не поговорил со снабжением. Перезвонить', '2025-05-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «ОЭС»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'отправил кп на почту. звонил.', '2025-05-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "МЭС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Набрал. Спецы были заняты. отправил кп. связаться позже', '2025-05-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ЗАПАДНАЯ ЭНЕРГЕТИЧЕСКАЯ КОМПАНИЯ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил С ЛПР. Китай не инетересен.только подстанции', '2025-05-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ОАО "СКЭК".' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с закупщицей.Попросила скинуть инфу. Будут в понедельник.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ФАБИ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвон. Отправил КП.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ИНТЕР РАО - ИНЖИНИРИНГ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'выбил номер снабжения. перезвонить через час', '2025-05-03'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «БГК»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'НАРЫЛ НОМЕР ЗАКУПЩИКА. У НИХ ЕСТЬ ГКПЗ. СКАЗАЛ УЧАВСТОВАТЬ В ЗАКУПКАХ НА ОБЩИХ ОСНОВАНИЯХ. ПОКА ВЯЛО. НО НАДО ПРОБИВАТЬ. ОН БЫЛ ОЧЕНЬ УСТАВШИМ. ТОРГУЮТСЯ НА СОБСТВЕННОЙ ПЛОЩАДКЕ: https://interrao-zakupki.ru/purchases/', '2025-06-03'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "МЕРИДИАН ЭНЕРГО"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил письмо на ген дира.', '2025-06-03'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ГОРЭЛЕКТРОСЕТЬ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'секретарь сука. не могу пробить.', '2025-06-03'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ЭЛЕКТРОУРАЛМОНТАЖ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'торгуются на ртс тендере.', '2025-06-04'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"СПЕЦЭНЕРГОГРУПП"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'перезвонить завтра. Дозвонился до закупок 5 июня. просят аттестацию россетей. берут 110 трансы и 220 чаще.', '2025-06-04'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ДРСК"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Перезвонить завтра. Битва с закупщиком', '2025-06-04'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ПО КХ Г.О. ТОЛЬЯТТИ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дозвонился до закупок. Российский акционный дом торговая площадка. Интересны китайцы. Прямых нет', '2025-06-05'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ТРАНСНЕФТЬЭЛЕКТРОСЕТЬСЕРВИС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дозвонился', '2025-06-05'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "РСК"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дозвонится', '2025-06-05'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛВЕСТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Юрий Григорьевич сказал выходить на торги. Заказ РФ.', '2025-06-05'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '''ЭНЕРГОУПРАВЛЕНИЕ''6603023425' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'дозвониться завтра', '2025-06-05'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''НТЭАЗ Электрик''6615010205 https://www.vsoyuz.com/ru/kontakty/sluzhba-zakupok.htm' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'снабженка в отпуске. набрать через неделю', '2025-06-06'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «КУЗНЕЦК ЭЛЕКТРО»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'заинтересовались. с китаем работали. нужно представительсво. оно есть. ждем запрос. набрать после уточнения наших цен', '2025-06-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '''РЕГИОНЭНЕРГОСЕТЬ''5948063201' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил с человеком. вроде интерес есть', '2025-06-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АКЦИОНЕРНОЕ ОБЩЕСТВО "ГИДРОЭЛЕКТРОМОНТАЖ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'снабжения нет на месте', '2025-06-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "УЭСК"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дозвонился', '2025-06-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО “АвтоматикаСтройСервис”' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'перезвонить позже', '2025-06-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"СК "ЭВЕРЕСТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Все предложения через руководителя. попросили направить кп на его имя. Попробовать связаться позже', '2025-06-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПКП "ФИНСТРОЙИНВЕСТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'было занято. перезвонить', '2025-06-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ОЗЭМИ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не прошел секретаря. пробовать позже', '2025-06-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Общество с ограниченной ответственностью «ЭнергоПрогресс»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил с александром. говорили про россети. но я его убедил. всякими уловками.', '2025-05-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛВЕСТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'перезвонить. на отгрузке.', '2025-06-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПК ЭЛЕКТРУМ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с директором. Пока проектов нет. но будут иметь нас в ввиду. отправил кп', '2025-06-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ " НИИЭФА - ЭНЕРГО "' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с Еленой. есть хороший контакт.', '2025-06-17'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АКЦИОНЕРНОЕ ОБЩЕСТВО "ПОДОЛЬСКИЙ ЗАВОД ЭЛЕКТРОМОНТАЖНЫХ ИЗДЕЛИЙ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил с ларисой. замотал ее. будет отправлять заявки', '2025-06-18'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '5249058696 АО ''НИПОМ''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил со снабженкой. была не в настроении. попросила кп. перезвонить завтра.', '2025-06-18'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛЕКТРООПТИМА"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил. девушка в отпуске до 1 июля', '2025-06-19'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'михайловск ставрополь' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвонился до начальника. пробовать завтра', '2025-06-19'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ИЗВА"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с начальником снабжения. контакт хороший. скину кп на почту', '2025-06-19'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '''ЗАВОД ''СИБЭНЕРГОСИЛА''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с закупщицей. Пока заявок нет. Отправил кп', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '3702015155 ''СПЕЦЭНЕРГО''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не берут', '2025-06-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЗИТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'сказать в отдел закупок. в понедельник', '2025-06-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОЭРА"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'сказать в отдел закупок. поговорил. рассматривают предложение', '2025-07-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "НПП ЭЛТЕХНИКА"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'звонил 3.07. выбил номер снабжения. пока не получил обратную связь', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ПРОГРЕСС"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'перевели и сбросили. перезвонить', '2025-07-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ЭТЗ "ЭНЕРГОРЕГИОН"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Никита Евгеньевич. Отправил кп. созвониться на след неделе', '2025-07-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ЭЛЕКТРОНМАШ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с закупщицей очень хорошо. Скинет заявку', '2025-07-02'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЗАВОД ЭЛПРО"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'все поставщики расписаны на год. была не в настроении. перезвонить через пару недель.', '2025-07-02'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПКФ "ЭЛЕКТРОЩИТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'снабженка не могла говорить. перезвонить днем.', '2025-07-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ИНИЦИАТИВА"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не было на месте спеца', '2025-07-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ФИРМА "ПРОМСВЕТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'ольга скинула трубку перезвонить. Поговорил со снабжением 15.07.2025. Скинул кп. Рассматривают предложение.', '2025-07-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "КЭР-ИНЖИНИРИНГ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил со снабженцем. отправил кп', '2025-08-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛЕКТРОПРОФИ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с коммерческим директором. интересно но говорит про нац режим.', '2025-09-03'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛЕКТРОСТРОЙ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с коллегой Айрата.Он сказал что посмотрит кп. перезвонить завтра', '2025-09-03'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО КОМПАНИЯ "ИНТЕГРАТОР"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'скинул кп на потчу', '2025-09-08'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ЭЛЕККОМ ЛОГИСТИК"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'отправил кп. пока не звонил', '2025-09-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «РИМ-РУС».' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'отправил кп на почту', '2025-09-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОТРАНЗИТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'отправил кп. закуп не ответили.', '2025-09-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '8911033894 АКЦИОНЕРНОЕ ОБЩЕСТВО ''ПУРОВСКИЕ ЭЛЕКТРИЧЕСКИЕ СЕТИ''' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'у них сидит менеджер, который отмсматривает заявки и связывается с поставщиками. будут иметь нас ввиду.', '2025-09-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНСИ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил с ольгой. закупают только энергоэффективные трансформаторы. Площадка сбербанк АСТ. участие бесплатное. Условия договорные.', '2025-09-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АКЦИОНЕРНОЕ ОБЩЕСТВО "ТЕПЛОКОММУНЭНЕРГО"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Валера в отпуске до моего др. набрать позже', '2025-09-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛЕКТРОКОНТАКТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'пока не дозвон. человека не было на месте.', '2025-09-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЗОИС-УРАЛ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'звонил в коммерческий отдел. сказали будут скидывать заявки', '2025-09-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭТП"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'поговорил со старым. хорошо пообщались. Потенциал', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЗАО "РЕКОНЭНЕРГО"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Поговорил с денисом второй раз. Попросил актуальный прайс. скинул кп Рамы. Жду обратку', '2025-09-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОКАПИТАЛ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвонился до Игоря. скорее всего, добавочный 135 но не факт. пробовать еще. 18.09.2025. Поговорил с Игорем. Работают с Россетями. пробить не вышло.', '2025-09-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ЭНЕРГОТЕХПРОЕКТ"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дозвонился', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Импульс»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '16.09.2025 не дозвон. 17.09.2025 Познакомился с Татьяной. рассматривают кп', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Самара ВЭМ' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'интересная компания, но не дозвонился до отдела закупок.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Электростроймонтаж»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не дозвон', '2025-09-17'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '«Липецкэлектро»' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Работал с мужиком. он теперь там не работает. Отвечает Елена', '2026-03-23'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "КАСКАД-ЭНЕРГО"' AND usr.name ILIKE 'магел%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвон, КП отправил на почту. / 29.04.25 - через секретаря связь с артемом, попросил информационное, обещал завтра скинуть заявку / не доходят сообщения! / 14.05.25 секретарь дал 2 почты закупщика Артема, при звонке не был на месте / все равно письма не доходят! / 20.05.25 - дозванился до Артема, актуализировал его почту, заявок нет говорит /', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ИНТЭКО"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Вышел на закупщика Юрий, попросил инф письмо./ 23.04.25- магел звонил, повторное коммерческое/ 29.04.25 - Алик - запросы есть внес в базу поставщиков / 14.05.25 - Юрий говорит мало заказов, освежил КП /', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ФЕНИКС-ЭНЕРГИЯ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП Герасимову / 28.04.25 - звонок Герасимову, не ответ, КП на почту / 14.05.25 -  нет на месте, ответила марина, наш товар интересен, попросила КП, сказала будут отправлять заказы / 15.05..25 - письмо не доставлено герасимову, надо с ним созваниться / 20.05.25 - Герасимов не ответ, все ссылаються нанего /', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '«ЭМПИН»  7743910877 Москва' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '15.04Отправил КП / 28.03.25-не дозвон / 21.05.25 - актуализировал номер, надо прозвонить /', '2025-04-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ЭМС''   7810241335 Санкт-Петербур' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/20.03звонокРаботают с атестованными в россетях/ 28.04.25 - не дозвон. Серт нужен - Алик \', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЗАО ''КАПЭ''  6911004716 Тверь' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Тяжело идет на контакт, отправил кп /23.04.25 магел звнок- тяжело идет но пробиваем/Короче Артем его зовут но он ни разу не закупщик надо зайти с иторией чтобы перевели на закупщика!!!! - завтра на брать- Алик 29.04 c Артемом бесполезно говорить он вафля! / 21.05.25 - артем запросил КП /', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''АСМ''   3250519725 Брянсск' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП / 23.04.25-не ответ /28.04.25 - ответил вредный секритарь, попросил информационное письмо / 29.04 не дозвон - алик', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ИК СИТИЭНЕРГО"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП / 28.04.25 - не ответ, повторное КП / не дозвон - алик 29.04', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "КАТЭН"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил кп / 28.04.25 - не ответ, повторное КП на почту / номер не досутпен 29.04 алик', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПЕТЕРБУРГ-ЭЛЕКТРО"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил кп / 28.04.25 - секретарь попросил инф письмо на снабжение / сказали отдел снабжения свяжется, если нет придумать историю с курьером', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПЭС"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил кп / 28.04.25 - не ответ, повторное КП / 14.05.25 - не ответ /', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "РУСЭЛ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП / 28.04.25 - не ответ, КП повторно на почту / 14.05.25 - не ответ / 15.04.25 - не ответ / 20.05.25 - не ответ /Секретярь соединяет но номер не ответил', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЦЕНТРЭЛЕКТРОМОНТАЖ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП / 29.04.25 - не интересно работают на довальчиском сырье ( Алик это пиздабольский отмаз?)  / 20.05.25 - Секретарь попросила КП /', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Эйч Энерджи Трейд"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвон/ не дозвон-20.03.25 / 14.05.25 - не дозвон /15.05.25 - не отвечают / 20.05.25 - не ответ /', '2025-03-18'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛЕКТРОГАРАНТ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил кп / 14.05.25 - попросили КП на почту / 15.05.25. - закупщицу зовут Дарья, сказала подстанции производят сами, трансформаторы интересны / 20.05.25 - секретарь соеденял с дарьей, ответила Татьяна, заявок нет, попросила КП на почту / ИСПОЛЬЗУЮТ РЕДКО ТРАНСЫ', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭНЕРГО-ДОН''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП/ тут секретарь сложный надо какие то данные предоставить лиретора пробить по инн, вытаскивать номер закупщика / 20.05.25- секретарь запросил письмо КП, перезвонить 23.05.25 / 11,08,25-секретарь говорит отправь кп если интересно то свяжуться', '2025-04-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОМИКС"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Рам есть контакт. Максим +7-963-154-62-84 (надо доработать )  / 14.05.25 - не ответ / 15.05.25- -Он сказал только атестованные в россетях поставляем /', '2025-03-04'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Энергоспецснаб"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Профильная компания/ 01.04 звонок, отправилКП / 29.04.25 - секретарь пытался соединь с отделом закупок, никто не ответил, попросила перезвонить после празников / 14.05.25 - наш товар редкий, Ольга закупщик запросила КП /', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «РСТ-ЭНЕРГО»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП / 15.05.25 - ответил секретарь, говорит не интересно, но еомпания профильная, возможно не правильно поняла /Короче тут сказали свяжутся серкетярь, попробую выйти на закупки - алик 22 мая', '2025-04-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПРП "Татэнергоремонт"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП / 29.04.25 - не ответ / 15.05.25 - не ответ /', '2025-04-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО РЕНОВАЦИЯ' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Вредный секретарь, отправил КП / 14.05.25 - не ответ, повторное КП /нет ответа алик 22 мая', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Энергосервис' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП / 15.05.25 - ответил секритарь, закупают через площадку на сайте tatenergo.ru, нужно найти выход на закупщика /', '2025-04-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Техносервис»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП / 15.05.25 - говорит не пользуеться спросом наша продукция, пиздит на сайте другая инфа /', '2025-03-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Завод БКТП»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ 15.05.25 - Связался с Николаем на сотовый, попросил КП на почту / 20.05.25 - николай был не в настроение, разговор не пошел, не помнит о нас /', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Минимакс' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП / 15.05.25 - Секретарь попросил КП / 20.05.25 - позвонить 21.05.25  Юлии Юрьевне 8(812)612-12-02 /', '2025-04-18'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Энерком-строй»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не актуальный номер', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО Элстар' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Профильная компания, запросили КП. / 15.04.25 -  нужно искать закупщика / 22.05.2025 - не ответ, это интернет магазин /', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО Строй-Энерго' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Занимаються строительством ЛЭП. отпрвил КП / 15.05.25 - секретарь говорит снабженцы отсутствуют на месте, поросила КП на почту / пробил секретаря, постоянно пиздит нет снабженце, снабженец ответил сказал не интерестно и бросил трубку /', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Резерв-Электро 21 век"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'В основном низковольтное, высоковольтное редко, отправил КП.', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО СТКОМ' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Наши изделия используют редко, запросили информационное письмо.', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО НПЦ «Электропроект М»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Профильная компания запросили информационное письмо. / 15.05.25 - секретарь связал с закупщиком, просят реестр минпромторга, изделия интересны, надо общаться / 22.05.2025 - Григорий говорит нет заказов, залечил его, просит звоонить переодически /', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ЭЛЕКТРО' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Грубят, наш клиент, попросили информационное письмо.  / 15.05.25 - не ответ /', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «ТехМир» 1841084642 Ижевск' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Берут наш товар мало, попросили информационное письмо.', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭнергоТехСервис'' 1840031750 Ижевск' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Запросили информационно письмо. / 15.05.25 - владимир не на месте/ 22.05.2025 - ответил Александр, у них торговая организация, говорят что внесли нас в список поставщиков, при звонке узнают Рамиля, заявок пока нет, долбить его не часто /', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «БЭСК Инжиниринг»  0275038560 Уфа' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Не дозвон, КПотправил на почту. / 02.06.2025 - Поросили КП на Сергея/', '2025-05-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО «НПП ЭНЕРГИЯ».' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвон, КПотправил на почту. / 02.06.25- не дозвон, /', '2025-05-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"Объединенная Энергия"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Приняли письмо, секретарь оправила начальнику, просила связаться 16.06.25 /', '2025-05-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''СИСТЕМОТЕХНИКА'' «Дженерал Пауэр» 7714826109' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не ответ, КП на почту /', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО «ЭНЕРГОСЕРВИС»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Секретарь пытался соеденить с отделом закупок не вышло, отправил КП на почту / 22.05.2025 - серетарь не смогла соеденить с отделом закупок не ответ /', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЭнергоТренд' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Ответил секретарь, попросила КП для ознакомления. / 15.05.25 - секритарь прислал на почту что мы молодая компания и они нас боятьс, вопрос на контроле у Магела / 22.05.2025 - анна секретарь напиздела что не берут наш продукт /', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ПРОГРЕССЭНЕРГО'' 2130065323 Чебоксары' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не дозвон,КП на почту/', '2025-05-19'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГО ЦЕНТР"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Профильная компания, секретарь запросил КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'л' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Профильная компания, секретарь запросил КП на почту / 22.05.2025 - ответил павел закуп, готовы расмотреть нашу продукцию под выйгранные торги, запросил КП /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Энерго Пром Сервис"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Профильная компания, секретарь запросил КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ЭНЕРГОСЕРВИСНАЯ КОМПАНИЯ ЛЕНЭНЕРГО"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ в основном низвольтное оборудование, наше редко берут, отправил КП /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОКОМПЛЕКТ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ секретарь запросил КП /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ПКФ "МЕТЭК-ЭНЕРГО"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Энергопоставка"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Энергосистемы»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ профильная компания, запросили КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "МНПО "ЭНЕРГОСПЕЦТЕХНИКА"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭнергоСоюз"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ секретарь поросил КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ПИК "ЭНЕРГОТРАСТ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ производители дизель станций, попросили КП /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «ЭНЕРГО СТРОЙ»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОКОМ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ТД "ЭнергоПромМаш"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ секретарь связала с Александрой, она попросила КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Энергостройуниверсал"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ на основной КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Энергоиндустрия»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ на основной КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Сельхозэнерго"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Альберт нач отдела снаб, попросил КП на почту /', '2025-05-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "БЭЛС-Энергосервис"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/  Попросили КП на почту /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «МОНТАЖЭНЕРГОПРОФ»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, отправил КП на почту /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОАЛЬЯНС"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ КП на почту /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Стандартэнерго"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Ксения секретарь - говорит нет заказов. Протолкнул ей КП на почту /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Альянс-Энерджи»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ ответил Павел, попросил КП на расмотрение / 02.06.25 - не ответ/', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО "ЭНЕРГОПРОЕКТ-ИНЖИНИРИНГ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Нужны бетонные КТП и атестация в россети /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОКОМПЛЕКТ КРЫМ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ производят генераторы, запросили кп на тех отдел /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОГРУПП"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Клиент Анара, держать на контроле /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ТК ''ЭНЕРГОКОМПЛЕКС'' 7810397798 Питер' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Яна секретарь запросила КП /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПСК "Тепло Центр Строй"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ профильная компания, запросили КП на почту /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОТРЕСТ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ кузнецов Андрей закупщик, отправил КП, его не было на месте /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Гарантэнерго"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ секретарь запросил КП организация профильная /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО Связь Энергострой 2801246747  Благовещенск' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО “ССМНУ-58”' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "НОРДГРИД"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ ответил Георгий, попросил КП на ватсап/', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «КНГ - ЭНЕРГО 3662287110 воронеж' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту /', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Центр Инжениринг»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ответил секретарь, проф организация, запросила КП на Вадима /', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '''ГРУППА КОМПАНИЙ ПРОФИТРЕЙД''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту / 14.07.25 - закупщик грубит не заебывать часто /', '2025-05-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭМКОМ''  7802335484' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Через секретаря связался с менеджером Антоном, в ходе разговора он понял значемость и передаст КП директору, сказал директор свяжеться с нами/ 10.06.25 -  попросил позвонить 16.06.25 -14:00 / 16.06.25 - попросил набрать 23.06.25 / 25.06.25 - Антон попросил КП на ватсапп и пошол к диру на разговор / Просят атестацию в россети /', '2025-06-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Завод „Энергетик“' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ попросили КП / 10.07.25 - потребности нету. рынок стоит / 11.08.25 - не расматривают поставщика из китая', '2025-06-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПП ШЭЛА"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ отправил КП не прошол секретаря / 22.07.25-секретарь говорит наше предложение не актуально /', '2025-06-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '«Озёрский завод энергоустановок»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ пока не требуеться / 22.07.25 - пока не требуеться / 11.08.25 - пока нет заказов, набрать 11.09.25 /', '2025-06-17'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ТД ''ПРОМЫШЛЕННОЕ ОБОРУДОВАНИЕ''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ секретарь попросила КП, и перезвонить 04.07.25 позвать виталия игоривича / 04.07.25.- Виталий говорит берут масло до 630ква, интерестно что когда будет у нас на складе, взял мой номер / 11.08.25 - Виталий не ответил / 08.09.25- запросили цены, набрать 15.09.25 / Виталий говорит интерестно на складе, ждать долго, разговор не о чем, набрать в конце сентября /', '2025-06-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «АС-ЭНЕРГО»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Вышел на нач закуп Лев, заинтересовал, взял личный номер, отправил инфу в ватсапп / 30.06.25 - Лев помнит про нас, сейчас нет заказов, ждет новые проекты / 10.07.25 - Лев помнит про нас, ждет заказы / 09.09.25 - написал ему в ватс ап сросил актуальные заказы / 16.04.26 - пока нет действующих проектов /', '2025-06-23'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО НПП «220 Вольт»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Запутал секреторя, дала почту дира, отправил КП / 16.05.2025 - письмо полученно попросили перезвонить 30.06.25 / 30.06.25 - попросили повторное КП, если со мной не связались, значит не интерестно / 14.07.25 - не ответ / 11.08.25 - не помнят про нас, запросили повторное КП / 25.08.25- не интерестно раз не перезвонили /', '2025-06-25'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭНЕРГОТЕХСЕРВИС''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ попросили КП на отдел снабжения для Екатерины / 03.07.25 - екатерина не получила наш КП, попросила повторно,  перезвонить 25.07.25  / 11.08.25 - заявок нет, перезвонить в начале сентября / ПИЗДИТ ЧТО НЕ ИСПОЛЬЗУЮТ /', '2025-06-25'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Энергии Технологии»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Секретарь передаст письмо генеральному директору/ 16.06.25 - не пробиваемый секретарь, просит КП / 25.06.25 - не дозвон / 30.06.25 - секретарь не помнит про нас, прислал на почту секретаря КП (дохлый номер) / 22.07.25 - не заинтересовало /', '2025-06-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''СНАБЭНЕРГОРЕСУРС''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не пробил, КП отправил / 02.07.25 - секретарь пыталась направить в отдел снабжения не ответ / 03.07.25 - Попал на николая, ему интерестно, дал свой сотовый. отправил инфу на ватсапп / 14.07.25 - цена дорогая на масло, про нас помнит, не задрачивать его /', '2025-07-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «ЭНЕРГОГРУПП»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ отправил КП на ватсапп / 25.08..25 - Елена не ответ /  ответила Эльмира, Елена в отпуске до 15.09.25 /', '2025-07-03'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО “Энергопроф”' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ попросили инф письмо и перезвонить / 10.07.25 - отдел закупок запросил повторно КП, по необходимости свяжуться сами / 25.08.25 - не нужно /', '2025-07-06'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ПКФ''ЭЛЕКТРОКОМПЛЕКС''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Секретарь попросила инф письмо на гл инженера / 25.06.25 - Шитов расмотрел КП все понравилось попросилконтактные данные, говорит пока нет заказов, по необходимости свяжеться / 11.08.25 - Павел в отпуске до 25.08.25 / Павел говорит нет заказов, набрать в след году (мажеться урод) /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '''РЕСУРССПЕЦМОНАЖ''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Переодически его задрочил/ добавил мой номер в ЧС /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Завод производитель трансформаторных подстанций «МИН»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ дерзкая, попросила КП / 25.06.25 - Венера говорит пока нет потребности / 14.07.25-не дзвон / Венера, говорит есть заказы непомнит про нас, попросила инф письмо,  по потребности свяжеться набрать 15.09.25 /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛЕКТРООПТИМА"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Антон, закуп, отмахивался россетями, залечил его и отправил КП / 14.07.25 - не ответ / 05.08.25 - не ответ /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''МЭК''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Секретарь попросил КП и презвонить в 16:00 по мск Владимиру Анатольевичу / 25.06.25 - Состоялся диалог с Владимиром, заинтересован, будет присылать заказы / 14.07.25 - Владимир не на месте / 25.08.25 - не дозвон /  Владимир говорит пока нет заявок на трансы и ктп, основное это щитовое оборудование набрать 19.09.25  /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Электрощит»-ЭТС' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не представился но есть интерес, попросил КП с ценами/ 16.05.25 - о нас помнит, ждет заказы, напоминать о себе переодически / 14.07.25 - Андрей просит набрать 16.07 / 11.08.25 - скоро будет запрос / набрать 17.09.25 я затупил не правельно шашел /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''Ринэко''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/монтажная организация, попросил кп на личный номер ватсапп, перезвонить 27.06.25 / 30.06.25 - Игорь говорит не пока заказов, просил набрать 07.07.25 / 10.07.25 - игорь попросил перезвонить 11.07.25 в 17:00 / 14.07 - пока нет заказов, Игорю интерестно представительство в СПБ, думает в тчечении недели и должен набрать до 18.07.25 / 22.07.25 - не ответ / 11.08.25 - нет заинтересованости, не знает кому предложить /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''КИМ''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ пока не требуеться, но запросили КП / Яна в отпуске набрать после 15.09.25 /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПКФ "ЭЛЕКТРОЩИТ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту / 02.07.25 - попросили КП на почту и перезвонить 04.07.25 / 04.07.25 - не ответ / 14.07.25 - КП не получили отправил повторно (набрать 23.07) / 24.07.25- сказали не актуально /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭЛЭНЕРГО''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ отдел закупок не отвечает / 02.07.25 - не овет / 14.07 - не ответ / 09.09.25 - не ответ /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЧЭТА''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ отправил КП, не очень интерестно / 09.09.25 - не ответ /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Электрощит' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ закуп евгений, норм диалог, попросил КП / 14.07.25 - не дозвон / 22.07.25 - рынок стоит. пока не актуально. перезвонить 20.08.25 / 25.08.25 - заявок нет пока набрать в начале сентября / 09.09.25 - не ответ /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''АС-ЭНЕРГО''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, КП на почту / 11.08.25 - запрос КП / 25.08.25 - секретарь не смог соединить с закупом, никто не ответил, попросила инф письмо на почту / 08.09.25 попросили инф письмо на закупки /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '«СТРОЙЭНЕРГОСИСТЕМЫ»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ работают с россетями, но изза экономии готовы расмотреть поставки, запросил КП / 14.07.25 - нет заказов, на этот год, набрать 01.09.25 /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "Энергостройуниверсал"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ интересны КТП, пока нет заказов / 08.09.25 - тока пришла с отпуска не заявок набрать после 20.09.25 /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭЛЕКТРОМАКС''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ секретарь получил КП / 14.07.25 - компания монтажники, работы нет, просит прозванивать раз в месяц /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''МАКСИМУМ''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Запросил КП / 14.07.25 - Иван не получил КП, дал свой номер и КП на ватсапп / 11.08.25 - Иван не ответ / 08.09.25 - работают с россети, попросил инф письмо на почту, звонить на городской позвать нач закупок, набрать 11.09.25 /', '2025-07-08'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ТСН''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ секретарь приняла КП, дала номер отдела закупок / 11.08.25 - Кравченко Игорь Александрович закуп, запросил КП на почту / 08.09.25 - нашли сами китайцев, пока думают, набрать после 20.09.25.', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ЕТекс' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ, отправил КП на почту / 10.07.25 - Секретарь получила КП, перезвонить 15.07.25 / 24.07.25 - решение еще не принято, набрать 30.07.25 / 11.08.25 - не дозвон /', '2025-07-10'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''БТ Энерго'' 7811573630' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ вышел на закуп Полина, попросила перезвонить 14.07.25 / 14.07.25 - Полина не успела посмотреть КП, попросила позвонить 18.07.25 в первой половине дня / 24.07.25 - не дозвон / 11.08.25 - пока нет заказов, набрать 25.08.25 / 08.09.25 - попросили цены, набрать 16.09.25 /', '2025-07-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '(ООО «Челябинский завод «Подстанция») 7451263799' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Кирил, получил КП  / 11.08.25 -  не актуально /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО НПК «ТехноПром»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Евгений Генадьевичь нач снаб, заинтересован, отправил КП / 14.07.25 - не дозвон ИРКУТСК! / Работает Анар / 16.09.25 -  набрать в конце сентября /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''Управляющая компания ''Уралэнерго' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Ответил Павел он получил КП и просил перезвонить 15.07.25 / 15.07.25 - говорит рынок стоит, набрать 29.07.25 / 11.08.25 - пока нет заказов, звонить в сентябре / 01.09.25 - перезвонить 04.09.25 /  09.09.25 - пока нет заказов, набрать в конце сентября /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Инженерный центр «Энергосервис»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ профильная компания, заказы с торгов будут присылать/ 14.07.25 - заинтересовал ивана нашими трансами, он в размышлениях, покажет руководству всю инфу  / 24.07.25 - говорит нет заказов набрать к концу августа / 11.08.25 - не ответ / 08.09.25 - Говорит помнит про нас лучше не названивать /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ИЦ ЭНЕРГЕТИКИ''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Рам 04.03 - Профельная компания не получиось обойти секретаря. отправил КП надо прожимать / 14.05.25 - забыли про нас, попросили инф письмо / 20.05.25 -  Секретарь сново попросил КП / 24.07.25 - директор по снабжению в отпуске / 11.08.25 - секретарь не помнит о нас запросила КП, набрать 25.08.25 / 09.09.25 попросила инф письмо, не пробиваемы секритарь, звонить в конце сентября  /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ТПК ''ЭНЕРГЕТИЧЕСКАЯ СИСТЕМА''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Эмиль заинтересовался, нужно добивать, набрать 28.07.25 / 11.08.25 - пока рынок стоит, о нас помнит, набрать 25.08.25 / 29.08.25 - Эмиль спросил цену 400ква тмг, сколький тип /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ''ОВЛ-ЭНЕРГО''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил, КП. Берут под торги, нужно прожимать / 09.09.25 - нет заказов /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''Группа Электроэнергетика''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Отправил на ватсапп инфу, заказов нет / 09.09.25 - не ответ александр /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПО ''РосЭнергоРесурс''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Василий попросил КП, и перезвонить 28.07.25 / 09.09.25 - не ответ /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО '' ЛЕРОН ''   7803010217' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Азат запросил инф письмо и перезвонить 24.07.25 / 24.07.25 - пока не интересно, набрать к коцу августа / 29.08.25 - спорили с азатом по цене, запросил прайс, след созвон 10-15 сентября / 09.09.25 - не ответ /', '2025-07-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭНЕРГО ЦЕНТР''    3328492856' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Секретарь получила инф письмо / 09.09.25- не ответ /', '2025-07-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО РЭСЭНЕРГОСИСТЕМЫ' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ инф письмо на почту, проверить рассмотрение / 24.07.25 - если не связались значит нет надобности, набрать в середине августа / 29.08.25 - повторно инф письмо попросили и набрать 5 сентября / 09.09 25 - не помнят про нас, попросили повторное инф письмо /', '2025-07-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ВП «НТБЭ' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ инф письмо на почту / 24.07.25 - попросили повторное КП, если интерестно свяжуться  /', '2025-07-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭНЕРГОСТРОЙМОНТАЖ'' 7203311501' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ трудные, инф на почту /', '2025-07-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭНЕРГОИНВЕСТ''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Работают с россетями, поговорит с начальством набрать  24.07.25 / 24.07.25 - александр дал свой номер отправил ему инфу и видео на ватсапп, сказал обсудит с начальством и перезвонит / 24.07.25 - не заинтересованы, работают с россети /', '2025-07-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'РегионСтройКомплект' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ закуп Михаил запросилинф письмона почту / 20.08.25 - связался с евгением, попросил инфу на ппочту / 01.09.25 - пока нет заказов, набрать 15.09.25 /', '2025-07-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '''ЭНЕРГ-ОН''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Ответил гореев рассул  инфу принял, интерестно, набрать 01.09.25 / 09.09.25 - Сергей занят, набрать 11.09.25 /', '2025-08-05'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ЭНЕРГО АЛЬЯНС''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ запросили КП и набрать 15.08.25 / 08.09.25 - нет заказов /', '2025-08-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''НПО ''ЛЕНЭНЕРГОМАШ''  7802753273' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ мария запросила КП на общую почту / 09.09.25 - закуп не ответ /', '2025-08-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ЭТЗ «ИВАРУС»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ ответил Александр, запросил инф письмо / 09.09.25 - пока нет потребности, 22.09.25 /', '2025-08-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЗАО ''Энергомашкомплект''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ секретарь запросила инф письмо /', '2025-08-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Электрощит' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Владиславу интерестно из наличия, заявки есть постоянно у них, запросил инф письмо, нужно доробатывать,   набрать 15.09.25 /', '2025-09-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «ЦРЗЭ»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Секретарь запросила инф письмо, работают на довальческом, уточнить расмотрение 15.09.25 /', '2025-09-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Энергетический Стандарт»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ /09.09.25 перезвонила Олеся, интересен Китай, попросила условия и инф письмо /', '2025-06-02'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''РиМтехэнерго''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/15.09.25 -  Запросили инф письмо / 30.09.25- пока нет заявок, не заебывать /', '2025-09-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОАЛЬЯНС"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ 15.09.25 - не ответ инф на почту / 30.09.25 -  набрать сегодня в 15.40', '2025-09-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОКОМ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ 15.09.25 -  не ответ инф на почту / 30.09.25 - не ответ /', '2025-09-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОКОМПЛЕКТ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ 15.09.25 - вышел на максима закуп, дал свой сотовый и попросил инф на ватсап / 30.09.25 - не интерестно, работают с россети, иногда присылать и позванивать  /', '2025-09-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛЕКТРОГАРАНТ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ 16.09.25 - наш товар редкий, основное это щитовое, запрос инф на почту /', '2025-09-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭЛСНАБ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ 16.09.25- не ответ, инф на почту / 30.09.25 - не ответ /', '2025-09-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПАРТНЕР ТТ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/30.09.25 инф письмо на почту /', '2025-09-30'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "КУБАНЬГАЗЭНЕРГОСЕРВИС"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Татьяны не былона месте, КП отправил/ 16.06.25 - попросили позвонить 20.05 татьяна будет на месте /23.06.25 - татьяна скинула заявку /25.06.25 - отправил цены на сухие 160,250,400 / 26.06.25 - Татьяна получила расчеты. свяжеться с нами/ 03.07.25 - Есть еще заявка на просчет,скинула заявку, отправил ерболу  / 04,07.25 - выставленны КП на трансы / 09.07.25 -  запрос в обработке, скинула новый / 11.08.25 - нет заявок, помнит про нас, набрать в сентябре / 08.09.25 - пока нет заявок / 07.04.2026 - И', '2025-06-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОКАПИТАЛ"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Алексей закупщик, заинтересован, попросил КП с ценами/ 16.06.25 - Александр Сухоруков, попросил КП, Алексей в опуске / 19.06.25 - прислапли на почту заявку на тсл 3150 / 26.06.25 - Яков мажеться, говорит некогда,прислал на почту запрос от СБ  / 01.07.25 - отправленные пояснения и бизнес карта / 09.07.25 - нет на месте / 14.07.25 - Яков просит позвонит 16.07.25 / 18.07.25 - Яков скинул заявку на сухие трансы, кп отправленно 21.07.25 / 22.07.25 - яков попросил цены на масло от 630 до 2500 ква в о', '2025-06-09'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Солар Системс»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Вышел на закуп, отправил КП/ Пришла заявка на транс тока, запрос отправил ерболу/ 04.07.25 - не ответ / 11.08.25 - пока нет заказов /', '2025-06-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Инжиниринговая Компания ТЭЛПРО' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/Входящий запрос тсл 1000 на почту /', '2025-05-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'SciTex Group' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Отправил на ватсапп инфу, заказов нет / 21.07.25 - пришел запрос на 1250 масло на почту / 30.09.25 - пока нет заявок о нас помнит, сильно не задрачивать /  07.04.2026 - Тяжелый, попросил инфу /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '(ООО «Челябинский завод «Подстанция») 7451263799' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Хороший заход, запросили КП на почту / 14.07.25- Сергей не на месте, набрать 15.07.25 / 22.07.25 - пока нет заказов, но интерестно, скинет на почту пример для просчета / 24.07.25 - отправил каталог / 11.08.25 - прислали опросник на тсл 2000 ответ на почту / 28.08.25 - в ответ на кп прислал запрос на 1250 сухой медь / 30.09.25 - пока нет запросов про нас помнит, сильно не задрачивать /', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''СибЭлектроМонтаж''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ не ответ инф на почту / 24.07.25 - Александру очень интерестно поставки из китая, дал свой номер и запросил инфу на ватсапп / 09.09.25 - занят на пергаворах / 16.09.25 - интересны от 110 кв, о нас ппомнит сильно не задрачивать, звонок начало октября /', '2025-07-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Кайрос Инжиниринг»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Берут наш товар, Евгений попросил КП на почту / 02.06.25 - нет заявок, попросил набрать в конце месяца/  05.08.25.- евгений попросил инфу на ватс апп и обещал заявку / 30.09.25 - попросил почту, есть заказ на ктп /', '2025-05-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ГК ''НЗО''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Попросил КП и перезвонить 08.07.25 / 08.07.25 - в ответ на КП прислал запрос на однофазные трансформаторы / 14.07.25 - не ответ / 20.08.25 - не дозвон /', '2025-07-08'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «СИРИУС-МК»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ закуп Сергей, плотно поговорили про китай и энергоэфективность .КП отправил/ 19.06 - он не получил инфу про нас, отправил повторно, долго тележили за китай, он пытался навялить что херня / 30.06.25 - Сергей запросил больше информации о трансформаторах, расширенный протокол испытаний (вопрос ерболу) / 10.07.25 - расширенные испытания отправленны, сергей не отвечает на телефон / 14.07.25 - Сергей в отпуске до 25.07.25 / 11.08.25 - мозгоеб про то что трансы не соответствуют ГОСТ, просит набрать 1', '2025-07-07'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО НПП «Элекор»' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ Андрей нач снаб, заинтересован в трансах / 30.06.25 - КП на рассмотрении ТЕХ отдела, просил набрать 14.07.25 / 14.07.25 - Андрей говорит тех отдел пока не рассмотрел наше предложение, наберт сам, если долго не выйдет на связь прожать его / 11.08.25 - пока нет заказ, набрать 25.08.25 / 25.08.25 - Андрей запросил 1250 сухой /', '2025-07-14'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ооо пкф спектор' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Валентин скиптичен к китайцам, посмотрел КП, диалог сложился нормально, разговор закончился не о чем /  24.07.25 - Валентин говорит рынок стоит, набрать в сентябре наш товар редкий   / 09.09.25 - пока нет заказов / 11.09.25 входяшка на трднс 25000 /', '2025-09-19'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПЭП"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', '/ 16.09.25 - не дозвон инф на почту / 30.09.25 - Александр попросил инф на почту / 22.12.25 - прислал запрос на тмг 2500 и 630', '2025-09-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Крия Инжиниринг' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Жду опросный лист БКТП. Свяжеться сам Вышел на ЛПР .', '2025-03-25'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Общество с ограниченной ответственностью ''Самур''' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил после звонка КП на почту. Не прошел секретаря', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Акционерное общество ''Дальневосточная электротехническая компания''' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП на почту . Не прошел секретаря', '2025-03-18'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО НСК' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'НЕ ЗАКУПАЮТ', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО МНПП «АНТРАКС»' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил на имя генерального директора ком перд на почту. Не прошел секретаря', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО РУСТРЕЙДКОМ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отрпавил информацию в whats app. Сказал вышлет пару опросных на подстанции.', '2025-03-18'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Сибтэк»' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Продукция интересует. Отправил на почту коммерческое предложение.', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО Дюртюлинские ЭиТС' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Потенциально могут закупать трансформаторы.', '2025-03-18'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Группа компаний «РИНАКО»' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Знают про СВЕРДЛОВЭЛЕКТРОЩИТ. Потербности нет.', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Энергоремонт»' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил информацию в отдел снабжения через секретаря. Возможно заинтересуются', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''СТАРТ''' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Связаться в понедельник. Вышли на договренность попробовать посотрудничать.', '2025-03-24'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПО «Радиан»' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Перезвонить, потенциально могут закупать', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ТРИНИТАС''' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Потенциальный клиент, вышел на личный контакт whatsapp, обратится при потребности', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ИМПУЛЬС"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Есть интерес в закупке НОВЫХ трансформаторов. Покупают у энетры и в брянске. ОТПРАВИТЬ КП на почту.', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПТМ"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Дозвонится', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПРОИЗВОДСТВЕННО-СТРОИТЕЛЬНАЯ КОМПАНИЯ "ТАГИЛЭНЕРГОКОМПЛЕКТ"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Дальний восток, связаться , потеницально могут закупать. Не ответил', '2025-03-25'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = '"ЭЛЕКТРИЧЕСКИЕ СЕТИ"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил информацию на почту, переодически есть потребность , можем сработать в будущем.', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Энергопрайм' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не довзонился. Отправил предложение на почту в отдел закупок.', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ ''Энерготранзит''' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Написал на почту. Позвонить. Дальний восток.', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО СКАТ ИНН 254 314 48 34' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Заполнил форму обратной связи. Выслал КП. Можно позвонить днем.', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО КЕДР' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил форму обратной связи . Можно позвонить', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ФАЗА"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Непрофильно, но участвуют в торгах. Отправил КП. Можно позвонить', '2025-03-20'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "КАВКАЗТРАНСМОНТАЖ"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил информацию на почту. Телефон не доступен.', '2025-03-26'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОПРОМ-МОНТАЖ"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'ЗВОНИЛ, СКАЗАЛИ ВСЕ ТОЛЬКО ЧЕРЕЗ ТОРГИ. ОТПРАВИЛ КП НА ПОЧТУ', '2025-03-26'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЮГ-ТРАНСЭНЕРГО"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП на почту. Не прошел секретаря.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "СТАНДАРТ"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают только через тендерные площадки. Можно попробовать пробится к ЛПР.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПРОФЭНЕРГО' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают трансформаторы. Хорошо разбирается в рынке, представился как диллер уральского силового', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЛИТВЕС"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают трансформаторы. На лпр не вышел, но добавили в список поставщиков.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ГЕОЗЕМКАДАСТР "' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не закупают', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "РСО-ЭНЕРГО"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Строительно-монтажные работы, потенциально сильный клиент. Не ответил.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОИНЖИНИРИНГ"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Строительно-монтажные работы, потенциально сильный клиент. Не ответил.', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ИВЭНЕРГОРЕМОНТ''' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Используют давальческий материал.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ТПК ДВ ЭНЕРГОСЕРВИС''' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают через B2B', '2025-04-02'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'БЕЛЭНЕРГОПРОМ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают трансы. Можно пробивать. Отправил КП УСТ на почту', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ИНЭСК' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвонился. Сетевая компания. Проводят торги. Скинул КП на почту от УралСилТранс', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ТК ЭНЕРГООБОРУДОВАНИЕ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Созвонился. Есть дейсвтующий партнер - завод. Новых не рассматривает. Возможно пробить в будущем', '2025-04-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО АРКТИК ЭНЕРГОСТРОЙ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить', '2025-04-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ИНЖЕНЕРНО-ТЕХНИЧЕСКИЙ ЦЕНТР НИИ ЭЛЕКТРОМАШИНОСТРОЕНИЯ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Номера не доступны', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ХИМРЕМОНТ"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил информацию по уралсилтранс в ватсапп. Пока нет ответа', '2025-04-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО РНК КЭПИТАЛ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'не закупают', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ЭНЕРГО СТРОЙ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Набрать !', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ИП Тарасова Екатерина Анатольевна' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП на почту. Завтра набрать или в ватсапп написать', '2025-04-16'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "КОНТРАКТ КОМПЛЕКТ 21"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Выполняют кадастровые работы. Вряд ли связаны с оборудованием, но можно пробовать.', '2025-04-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭТС"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не пробил серетаря.', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОАСГАРД"' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП на почту, набрать. Сотрудничают через почту', '2025-04-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ТД СЕВЕРНАЯ ЭНЕРГИЯ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Отправил КП на почту. Занимаются ремонтом, могут купить теоритически. Написать в ватсапп, набрать', '2025-04-15'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ТРАНСКОМ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил КП на почту. Заполнил форму обратной связи. Можно прозвонить', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО КПМ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил кп на почту. можно набрать. собирают ктп', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО МОНТАЖНИКПЛЮС' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил КП на почту. Собирают подстанции. Можно набрать', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ЭЛЕКТРОКОМПЛЕКТ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил кп на почту. Торговая компания. Обязательно набрать.  Диллеры завода СЗТТ', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ВАВИЛОН' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил КП. Занимаются монтажом энергообъектов', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ПКФ ЭЛЕКТРОКОМПЛЕКС' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Созвонился. Закупают. Целевой. Отправил КП  Совзонится в  среду.', '2025-04-23'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО НПО ЭЛРУ 040000861' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'НАПРАВИЛ КП В ВАТСАПП И ПОЧТУ. ЖДУ ОБРАТКУ', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ВОСТОКЭНЕРГО' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'НАПРАВИЛ НА ПОЧТУ. мЕЛКАЯ КОМПАНИЯ НО УЧАСТВУЕТ В ТОРГАХ.', '2025-04-18'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ДЭТК' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Пока заявок актуальных нет. Набрать на следующей недели', '2025-04-30'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО АЛГОРИТМ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Направил на почту коммерческое предложение. Телефона нет.', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ИП ЗАЦЕПИН РОМАН НИКОЛАЕВИЧ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Очень редко берут трансформаторы. Можно периодически выходить на связь.', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО МИР-ЭНЕРГО' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Созвонился, закупают. Передаст КП менеджерам. Отправляю СЭЩ. Можно позже Уралсилтранс', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО АЭКЛ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Набрал. Пока заявок, но закупают, можно сотрудничать. Отправил КП на почту. Переодически набирать. СЭЩ отправил, потом пробью СилТрансом', '2025-04-21'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ЗАО ТДМ ЦЕНТР' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Аварийная служба. Есть форма для поставщиков. Заполнил, отправил. Можно позвонить. Отправил от СИЛТРАНСА', '2025-04-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО ИНТЕР РАО ЭЛЕКТРОГЕНЕРАЦИЯ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Не дозвонился. Отправил КП на почту от СЭЩ', '2025-04-22'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'АО СОЛАР СЕРВИС' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Дозвонился. Закупают. Выслал инфу на почту с 2мя предложениями.', '2025-04-28'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ЛИСЕТ' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают у табриза и поставляют ему. Можно позже пробивать от силтранса и предлагать китай', '2025-04-24'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО «Тексис Груп»' AND usr.name ILIKE 'анар%' LIMIT 1;

INSERT INTO activities (id, company_id, user_id, type, content, created_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'заметка', 'Закупают алагеум алтранс и свэл. Можно бороться за них.', '2025-04-23'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ЭНЕРГОКАПИТАЛ"' AND usr.name ILIKE 'анар%' LIMIT 1;

-- ═══ PROPOSALS (КП) ═══
INSERT INTO proposals (id, company_id, manager_id, number, status, total_amount, valid_until, notes, created_at, updated_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'КП-1', 'отправлено', 32000002704000, NULL, NULL, '2025-08-29', '2025-08-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ооо пкф спектор' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO proposals (id, company_id, manager_id, number, status, total_amount, valid_until, notes, created_at, updated_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'КП-2', 'отправлено', 4380000, NULL, NULL, '2025-08-29', '2025-08-29'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''СибЭлектроМонтаж''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO proposals (id, company_id, manager_id, number, status, total_amount, valid_until, notes, created_at, updated_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'КП-3', 'отправлено', 0, NULL, NULL, '2025-09-11', '2025-09-11'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО "ПЭП"' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO proposals (id, company_id, manager_id, number, status, total_amount, valid_until, notes, created_at, updated_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'КП-4', 'отправлено', 0, NULL, NULL, '2025-09-30', '2025-09-30'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'ООО ''ГК ''НЗО''' AND usr.name ILIKE 'рам%' LIMIT 1;

INSERT INTO proposals (id, company_id, manager_id, number, status, total_amount, valid_until, notes, created_at, updated_at)
SELECT gen_random_uuid(), comp.id, usr.id, 'КП-5', 'отправлено', 0, NULL, NULL, '2025-06-01', '2025-06-01'
FROM companies comp CROSS JOIN users usr
WHERE comp.name = 'Крия Инжиниринг' AND usr.name ILIKE 'рам%' LIMIT 1;

-- Включаем RLS обратно
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE company_contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposals ENABLE ROW LEVEL SECURITY;
ALTER TABLE proposal_items ENABLE ROW LEVEL SECURITY;

-- ═══ ГОТОВО! ═══
-- Примечание: manager_id использует подстановочные UUID (MANAGER_ALIK_ID и т.д.)
-- Перед запуском замените их на реальные ID из таблицы users:
-- SELECT id, name, email FROM users;
-- Затем выполните: sed -i "s/MANAGER_ALIK_ID/реальный_uuid/g" этот_файл.sql
