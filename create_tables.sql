--SQL запросы на создание таблиц
CREATE TABLE [currency] (
	[id] [bigint] NOT NULL PRIMARY KEY,
	[name] [nvarchar](max) NOT NULL,
)

CREATE TABLE [game] (
	[id] [bigint] NOT NULL PRIMARY KEY,
	[name] [nvarchar](max) NOT NULL,
	[description] [nvarchar](max) NULL,
)


CREATE TABLE [current_price] (
	[game_id] [bigint] NOT NULL REFERENCES [game](id),
	[currency_id] [bigint] NOT NULL REFERENCES [currency](Id),
	[amount] [int] NOT NULL,
	PRIMARY KEY ([game_id], [currency_id])
)

CREATE TABLE [user](
	[id] [bigint] NOT NULL PRIMARY KEY,
	[name] [nvarchar](max) NOT NULL,
)

CREATE TABLE [payment_system](
	[id] [bigint] NOT NULL PRIMARY KEY,
	[name] [nvarchar](max) NOT NULL,
)

CREATE TABLE [user_account_token](
	[user_id] [bigint] NOT NULL,
	[payment_system_id] [bigint] NOT NULL,
	[token] [nvarchar](20) NOT NULL,
	PRIMARY KEY ([user_id],	[payment_system_id])
)

CREATE TABLE [payment](
	[number] [bigint] NOT NULL PRIMARY KEY,
	[game_id] [bigint] NOT NULL REFERENCES [game](id),
	[quantity] [int] NOT NULL,
	[current_currency_id] [bigint] NOT NULL REFERENCES [currency](id),
	[current_price] [int] NOT NULL,
	[user_id] [bigint] NOT NULL REFERENCES [user](id),
	[date] [datetime2](7) NOT NULL,
	[canceled] [bit] NOT NULL,
	[payment_currency_id] [bigint] NOT NULL REFERENCES [currency](id),
	[payment_amount] [int] NOT NULL,
	[vat] [int] NOT NULL,
	[payment_system_id] [bigint] NOT NULL REFERENCES [payment_system](id),
)

--Создание индексов, для ускорения обработки запросов
--SQL запрос: вывод всех успешно купленных за определенный период игр
--кластеризованный индекс на дату существенно ускорит поиск, так как поиск будет происходит в диапазоне дат:
CREATE CLUSTERED INDEX index_date ON [payment]([date]);		
--индекс на внешний ключ game_id, как так, мне кажется, по этому полю будет производится GROUP BY:
CREATE INDEX index_game_id ON [payment]([game_id]);	



--SQL запрос: вывод всех платежей по указанному токену сохраненного аккаунта пользователя
--индекс на внешний ключ user_id, как так по этому полю будет производиться JOIN:
CREATE INDEX index_user_id ON [payment]([user_id]);
--индекс на внешний ключ payment_system_id, как так по этому полю тоже будет производиться JOIN:
CREATE INDEX index_payment_system_id ON [payment]([payment_system_id]);	
--индекс на поле с токеном пользователя
CREATE INDEX index_token ON [user_account_token]([token]);


--SQL запрос: вывод всех платежей по указанному токену сохраненного аккаунта за определенный период времени
--думаю, для этого запроса индексов выше будет достаточно
