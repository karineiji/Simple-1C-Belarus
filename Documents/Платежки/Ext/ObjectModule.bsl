﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.РегистрБухгалтерии.Записывать = Истина;
	Движение = Движения.РегистрБухгалтерии.Добавить();
	Движение.СчетДт = ПланыСчетов.ПланСчетов.РасчетыСПоставщикамиИПодрядчиками;
	Движение.СчетКт = ПланыСчетов.ПланСчетов.РасчетныйСчет;
	Движение.Период = Дата;
	Движение.Сумма = Сумма;

КонецПроцедуры
