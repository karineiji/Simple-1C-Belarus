﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Проводка = Движения.РегистрБухгалтерии.Добавить();
	Проводка.ЮрЛицо = ЮрЛицо;
	Проводка.Период = Дата;
	Проводка.СчетДт = СчетУчета;
	Проводка.СчетКт = ПланыСчетов.ПланСчетов.С60;
	Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
	Проводка.Сумма = Услуги.Итог("Сумма");
	
	Если Услуги.Итог("СуммаНДС") <> 0 Тогда
		Проводка = Движения.РегистрБухгалтерии.Добавить();
		Проводка.ЮрЛицо = ЮрЛицо;
		Проводка.Период = Дата;
		Проводка.СчетДт = ПланыСчетов.ПланСчетов.С18;
		Проводка.СчетКт = ПланыСчетов.ПланСчетов.С60;
		Проводка.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Контрагенты] = Контрагент;
		Проводка.Сумма = Услуги.Итог("СуммаНДС");
	КонецЕсли;
	
	
	Движения.РегистрБухгалтерии.Записывать = Истина;
	
КонецПроцедуры
