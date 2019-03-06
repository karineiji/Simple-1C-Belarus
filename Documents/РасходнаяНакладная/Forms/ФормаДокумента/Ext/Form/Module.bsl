﻿&НаСервереБезКонтекста
Функция СписокПокупныхЦен(ЮрЛицо, Дата, Товар, Склад)
	
	ЗапросСписка = Новый Запрос;
	
	ЗапросСписка.Текст = 
	  "ВЫБРАТЬ
	  |	СтоимостьТоваровПоФактуОстатки.Цена КАК Цена
	  |ИЗ
	  |	РегистрНакопления.СтоимостьТоваровПоФакту.Остатки(
	  |			&Дата,
	  |			Номенклатура.Ссылка = &Товар
	  |				И Склад = &Склад И ЮрЛицо = &ЮрЛицо) КАК СтоимостьТоваровПоФактуОстатки";
	
	ЗапросСписка.УстановитьПараметр("Товар", Товар);
	ЗапросСписка.УстановитьПараметр("Дата", Дата);
	ЗапросСписка.УстановитьПараметр("Склад", Склад);
	ЗапросСписка.УстановитьПараметр("ЮрЛицо", ЮрЛицо);
	РезультатЗапросСписка = ЗапросСписка.Выполнить();
	ВыборкаСписка = РезультатЗапросСписка.Выбрать();
	
	СписокЦен = Новый Массив;
	Пока ВыборкаСписка.Следующий() Цикл
		СписокЦен.Добавить(ВыборкаСписка.Цена);
	КонецЦикла;
	
	Возврат СписокЦен;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТоварыНоменклатураПриИзмененииНаСервере(Товар)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "Выбрать
	|  ЦенаПродажи
	|ИЗ
	|  Справочник.Номенклатура
	|ГДЕ
	|  Ссылка = &Товар";
	
	Запрос.УстановитьПараметр("Товар", Товар);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.ЦенаПродажи;
	
КонецФункции

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	Товар = Элементы.Товары.ТекущиеДанные.Номенклатура;
	Элементы.Товары.ТекущиеДанные.Цена = ТоварыНоменклатураПриИзмененииНаСервере(Товар);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	Элементы.Товары.ТекущиеДанные.СебестоимостьТовара = Элементы.Товары.ТекущиеДанные.ЦенаПокупки * Элементы.Товары.ТекущиеДанные.Количество;
	КлиентскаяРаботаСДокументами.СуммаЭлементаТЧ(Элементы.Товары.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	
	КлиентскаяРаботаСДокументами.СуммаЭлементаТЧ(Элементы.Товары.ТекущиеДанные);
	
КонецПроцедуры

&НаСервере
Функция ПечатьНаСервере()
	
	Если Объект.Товары.Количество() = 0 Тогда 
		Сообщить("Товаров нет, печать отменяется");
		Возврат 0;
	КонецЕсли;
	
	Если НЕ Объект.Проведен Тогда 
		Сообщить("Документ не проведён");
		Возврат 0;
	КонецЕсли;
	
	Табдок = Новый ТабличныйДокумент;
	Табдок.АвтоМасштаб  = Истина;
	Макет = Документы.РасходнаяНакладная.ПолучитьМакет("ТН2");
	Табдок.РазмерСтраницы = "A4";
	Табдок.ПолеСверху = 11;
	Табдок.ПолеСлева = 22;
	Табдок.ПолеСправа = 16;
	Табдок.ПолеСнизу = 17;
	
	ОблШапка = Макет.ПолучитьОбласть("ОблШапка");
	ОблСтрока = Макет.ПолучитьОбласть("ОблСтрока");
	ОблПодвал = Макет.ПолучитьОбласть("ОблПодвал");
	
	ОблШапка.Параметры.УНПЮрЛицо = Формат(Объект.ЮрЛицо.УНП,"ЧГ=0");
	ОблШапка.Параметры.ЮрЛицо = Объект.ЮрЛицо;
	ОблШапка.Параметры.ЮрАдрес = Объект.ЮрЛицо.ЮрАдрес;
	ОблШапка.Параметры.УНПполучателя = Формат(Объект.Контрагент.УНП,"ЧГ=0");
	ОблШапка.Параметры.Дата = Формат(Объект.Дата, "ДЛФ=DD");
	ОблШапка.Параметры.Контрагент = Объект.Контрагент;
	ОблШапка.Параметры.КонтрагентЮрАдрес = Объект.Контрагент.ЮрАдрес;
	
	ТабДок.Вывести(ОблШапка);
	
	Для Каждого СТР из Объект.Товары Цикл 
		ОблСтрока.Параметры.Номенклатура = СТР.Номенклатура.ПолноеНаименование;
		ОблСтрока.Параметры.Количество = СТР.Количество;
		ОблСтрока.Параметры.Цена = Формат(СТР.Цена,"ЧДЦ=2");
		ОблСтрока.Параметры.Сумма = Формат(СТР.Сумма,"ЧДЦ=2");
		ОблСтрока.Параметры.СтавкаНДС = СТР.СтавкаНДС;
		ОблСтрока.Параметры.СуммаНДС = Формат(СТР.СуммаНДС,"ЧДЦ=2");
		ОблСтрока.Параметры.СуммаСНДС = Формат(СТР.СуммаСНДС,"ЧДЦ=2");
		Табдок.Вывести(ОблСтрока);
	КонецЦикла;
	
	ИтогоСНДС = Объект.Товары.Итог("СуммаСНДС");
	ИтогоНДСа = Объект.Товары.Итог("СуммаНДС");
	ИтогоКоличество = Объект.Товары.Итог("Количество");
	ИтогоБезНДС = Объект.Товары.Итог("Сумма");
	ОблПодвал.Параметры.СуммаСНДСом = Формат(ИтогоСНДС,"ЧДЦ=2");
	ОблПодвал.Параметры.СуммаСНДСомПрописью = ЧислоПрописью(ИтогоСНДС,,"рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2");
	ОблПодвал.Параметры.СуммаКоличество = ИтогоКоличество;
	ОблПодвал.Параметры.СуммаЦена = Формат(ИтогоБезНДС,"ЧДЦ=2");
	ОблПодвал.Параметры.СуммаНДСа = Формат(ИтогоНДСа,"ЧДЦ=2");
	ОблПодвал.Параметры.СуммаНДСПрописью =  ЧислоПрописью(ИтогоНДСа,,"рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2");
	ОблПодвал.Параметры.Контрагент =  Объект.Контрагент;
	ОблПодвал.Параметры.ФИОПоДоверенности =  Объект.ФИОПоДоверенности;
	ОблПодвал.Параметры.НомерДатаДоверенности = Объект.НомерДатаДоверенности;	
	
	Табдок.Вывести(ОблПодвал);
	
	ТабДок.ОтображатьГруппировки = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.ОтображатьСетку = Ложь;
	
	Возврат ТабДок;
	
КонецФункции

&НаКлиенте
Процедура Печать(Команда)
	
	Табдок = ПечатьНаСервере();
	
	Если Табдок <> 0 Тогда 
		Табдок.Показать();
	КонецЕсли;
	
	Табдок.Напечатать(РежимИспользованияДиалогаПечати.Использовать);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТоварыПриНачалеРедактированияНаСервере()
	
	СтавкаНДС = Перечисления.СтавкиНДС.НДС20;
	Возврат СтавкаНДС;
	
КонецФункции

&НаСервереБезКонтекста
Функция ТоварыСчетНаСервере()
	
	СчетУчета = ПланыСчетов.ПланСчетов.С41с1;
	Возврат СчетУчета;
	
КонецФункции

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда 
		СТР = Элементы.Товары.ТекущиеДанные;
		СТР.СтавкаНДС = ТоварыПриНачалеРедактированияНаСервере();
		СТР.СчетУчета = ТоварыСчетНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПокупкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Товар = Элементы.Товары.ТекущиеДанные.Номенклатура;
	МассивЦен = СписокПокупныхЦен(Объект.ЮрЛицо, Объект.Дата, Товар, Объект.Склад);
	Элемент.СписокВыбора.ЗагрузитьЗначения(МассивЦен);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПокупкиПриИзменении(Элемент)
	
	Элементы.Товары.ТекущиеДанные.СебестоимостьТовара = Элементы.Товары.ТекущиеДанные.ЦенаПокупки * Элементы.Товары.ТекущиеДанные.Количество;
	
КонецПроцедуры

